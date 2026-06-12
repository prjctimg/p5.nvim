import { readFileSync, writeFileSync, mkdirSync } from 'fs'
import { join, sep } from 'path'

const [jsonPath, outDir, p5Version] = process.argv.slice(2)
if (!jsonPath || !outDir) {
  console.error('Usage: node json-to-md.mjs <ref.json> <out-dir> [p5-version]')
  process.exit(1)
}

const data = JSON.parse(readFileSync(jsonPath, 'utf8'))
mkdirSync(outDir, { recursive: true })

// --- Step 1: Build file → module mapping ---
const fileModule = new Map()
for (const item of data) {
  if (item.kind !== 'module') continue
  const file = item.context?.file
  if (!file) continue
  const moduleTag = item.tags?.find(t => t.title === 'module')
  if (!moduleTag) continue
  const moduleName = moduleTag.name || moduleTag.description
  if (moduleName) fileModule.set(file, moduleName)
}

// --- Step 2: Group items by module using context.file ---
const moduleItems = new Map()
for (const item of data) {
  if (item.kind === 'module') continue
  const file = item.context?.file
  if (!file) continue

  let mod = fileModule.get(file)
  if (!mod) mod = 'Other'
  if (!moduleItems.has(mod)) moduleItems.set(mod, [])
  moduleItems.get(mod).push(item)
}

// --- Step 3: Helper: extract plain text from MDAST-like description ---
function descText(desc) {
  if (!desc) return ''
  if (typeof desc === 'string') return desc
  if (desc.type === 'root' && desc.children) {
    return desc.children.map(c => descText(c)).join('').trim()
  }
  if (desc.type === 'paragraph' && desc.children) {
    return desc.children.map(c => descText(c)).join('')
  }
  if (desc.type === 'text' || desc.type === 'link') {
    return desc.value || ''
  }
  if (desc.type === 'inlineCode') {
    return '`' + (desc.value || '') + '`'
  }
  if (desc.type === 'code') {
    return (desc.value || '')
  }
  if (Array.isArray(desc)) {
    return desc.map(c => descText(c)).join('')
  }
  return ''
}

function typeString(t) {
  if (!t) return ''
  if (typeof t === 'string') return t
  if (t.type === 'NameExpression' || t.type === 'Identifier') return t.name || ''
  if (t.type === 'UnionType' && t.elements) {
    return t.elements.map(e => typeString(e)).join('|')
  }
  if (t.type === 'TypeApplication' && t.expression) {
    const base = typeString(t.expression)
    const args = t.applications ? t.applications.map(a => typeString(a)).join(', ') : ''
    return `${base}<${args}>`
  }
  if (t.type === 'OptionalType' && t.expression) {
    return typeString(t.expression) + '?'
  }
  if (t.type === 'AllLiteral') return 'Any'
  if (t.type === 'NullLiteral') return 'null'
  if (t.type === 'UndefinedLiteral') return 'undefined'
  if (t.type === 'BooleanLiteral') return 'boolean'
  if (t.type === 'NumericLiteral') return 'number'
  if (t.type === 'StringLiteral') return 'string'
  if (t.name) return t.name
  return JSON.stringify(t)
}

function paramRow(param) {
  const name = param.name || ''
  const opt = param.optional ? '?' : ''
  const t = typeString(param.type)
  const desc = descText(param.description)
  return `| \`${name}${opt}\` | ${t ? '`' + t + '`' : ''} | ${mdEscape(desc)} |`
}

function mdEscape(s) {
  return s.replace(/\|/g, '\\|').replace(/\n/g, ' ')
}

function makeTag(name) {
  return name
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
}

// --- Step 4: Re-group items by mapped file slug ---
const moduleSlugMap = {
  'Environment': 'core',
  'Structure': 'core',
  'Rendering': 'core',
  'Transform': 'core',
  'Constants': 'core',
  '3D': 'webgl',
  'Shaders & Compute': 'webgl',
}

const slugModules = new Map()
for (const [modName, items] of moduleItems) {
  const slug = moduleSlugMap[modName] || makeTag(modName)
  if (!slugModules.has(slug)) slugModules.set(slug, new Map())
  slugModules.get(slug).set(modName, items)
}

// --- Step 5: Generate markdown per slug file ---
for (const [slug, modMap] of slugModules) {
  const moduleHeading = `p5-${slug}`

  const lines = []

  for (const [modName, items] of modMap) {
    lines.push(`# ${modName}`)
    lines.push('')
    lines.push(`p5.js v${p5Version || '?'} reference documentation.`)
    lines.push('')

    // Collect unique items (by name) for TOC
    const seen = new Set()
    const uniqueItems = items.filter(item => {
      const n = item.name
      if (!n || seen.has(n)) return false
      seen.add(n)
      return true
    })

    if (modMap.size === 1) {
      lines.push('## Table of Contents')
      lines.push('')
      for (const item of uniqueItems) {
        lines.push(`- [${item.name}](#${makeTag(item.name)})`)
      }
      lines.push('')
    }

    // --- Item sections ---
    const seenItems = new Set()
    for (const item of items) {
      if (!item.name || seenItems.has(item.name)) continue
      seenItems.add(item.name)

      const desc = descText(item.description)

      const tagTypes = item.tags?.map(t => t.title) || []
      const isMethod = tagTypes.includes('method')
      const isProperty = tagTypes.includes('property')
      const isReadOnly = tagTypes.includes('readOnly')
      const isChainable = tagTypes.includes('chainable')
      const isPrivate = tagTypes.includes('private')
      const submodule = item.tags?.find(t => t.title === 'submodule')
      const submoduleName = submodule ? descText(submodule.description) || submodule.name : ''

      if (isPrivate) continue

      lines.push(`## ${item.name}`)
      lines.push('')

      if (desc) {
        lines.push(desc)
        lines.push('')
      }

      if (submoduleName && submoduleName !== modName) {
        lines.push(`*Sub-module: ${submoduleName}*`)
        lines.push('')
      }

      const typeInfo = []
      if (isMethod) typeInfo.push('method')
      if (isProperty) typeInfo.push('property')
      if (isChainable) typeInfo.push('chainable')
      if (isReadOnly) typeInfo.push('read-only')
      if (typeInfo.length) {
        lines.push(`*${typeInfo.join(', ')}*`)
        lines.push('')
      }

      const params = item.params || []
      if (params.length) {
        lines.push('### Parameters')
        lines.push('')
        lines.push('| Name | Type | Description |')
        lines.push('|------|------|-------------|')
        for (const p of params) {
          lines.push(paramRow(p))
        }
        lines.push('')
      }

      const properties = item.properties || []
      if (properties.length) {
        lines.push('### Properties')
        lines.push('')
        lines.push('| Name | Type | Description |')
        lines.push('|------|------|-------------|')
        for (const p of properties) {
          lines.push(paramRow(p))
        }
        lines.push('')
      }

      const returns = item.returns || []
      if (returns.length) {
        lines.push('### Returns')
        lines.push('')
        for (const r of returns) {
          const rt = typeString(r.type)
          const rd = descText(r.description)
          lines.push(rt ? `\`${rt}\`` : '')
          if (rd) lines.push('')
          if (rd) lines.push(rd)
        }
        lines.push('')
      }

      const examples = item.tags?.filter(t => t.title === 'example') || []
      if (examples.length) {
        lines.push('### Examples')
        lines.push('')
        for (const ex of examples) {
          const code = ex.description || ''
          if (code.trim()) {
            lines.push('```javascript')
            lines.push(code.trim())
            lines.push('```')
            lines.push('')
          }
        }
      }

      lines.push('---')
      lines.push('')
    }
  }

  const outPath = join(outDir, `${moduleHeading}.md`)
  writeFileSync(outPath, lines.join('\n'), 'utf8')
  console.error(`  wrote ${moduleHeading}.md (${lines.length} lines)`)
}

console.log(`Done. Generated ${slugModules.size} files.`)
