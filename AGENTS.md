# p5.nvim

## Dev environment tips

- Create test cases for every refactor.
- Clean up test files after you're done and before you commit the changes.
- Commit the changes using conventional commit guidelines.

## Coding Guidelines

- Use consistent and preferably short variable names.
- Avoid declaring single use variables when possible.
- Avoid repetitive calls to chained methods/fields and instead alias them so that the LOC remain small.
- Use non deprecated Neovim APIs (v0.11.0+)
- Instead of the default `M` variable for a module's export, use the module's filename first letter.
- Use non-blocking constructs for indefinitely running tasks.
- Update the README for any user facing changes.
