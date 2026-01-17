#!/bin/bash
# Create Neovim help file header
cat > doc/p5-nvim.txt << 'EOF'
*p5-nvim.txt*    Better editor support for p5.js in Neovim

==============================================================================
TABLE OF CONTENTS                                          *p5-nvim-contents*

1. Requirements .......................... |p5-nvim-requirements|
2. Installation ........................... |p5-nvim-installation|
3. Features ................................ |p5-nvim-features|
4. Configuration .......................... |p5-nvim-configuration|

==============================================================================
    
EOF

# Process README.md line by line
in_code_block=false
while IFS= read -r line; do
    # Skip empty lines
    if [[ -z "$line" ]]; then
        continue
    fi
    
    # Handle code blocks
    if [[ "$line" == '```'* ]]; then
        if $in_code_block; then
            in_code_block=false
        else
            in_code_block=true
            echo ">"
        fi
        continue
    fi
    
    # If in code block, just print the line
    if $in_code_block; then
        echo "$line"
        continue
    fi
    
    # Keep emojis in documentation
    
    # Process different markdown elements
    if [[ "$line" == "# "* ]]; then
        # Main headers - convert to uppercase and remove #
        echo "$line" | sed 's/^# //' | tr '[:lower:]' '[:upper:]'
    elif [[ "$line" == "## "* ]]; then
        # Sub headers - remove ##
        echo "$line" | sed 's/^## //'
    elif [[ "$line" == "### "* ]]; then
        # Sub sub headers - remove ### and indent
        echo "$line" | sed 's/^### /  /'
    elif [[ "$line" == "> ["* ]]; then
        # Alert blocks - convert to plain text
        echo "$line" | sed 's/^> \[!\([a-z]*\)\]/\1:/'
    elif [[ "$line" == ">"* ]]; then
        # Blockquotes - remove >
        echo "$line" | sed 's/^> //'
    else
        # Regular lines
        echo "$line"
    fi
done < README.md >> doc/p5-nvim.txt

# Add section tags
sed -i 's/^REQUIREMENTS/*p5-nvim-requirements*/' doc/p5-nvim.txt
sed -i 's/^INSTALLATION/*p5-nvim-installation*/' doc/p5-nvim.txt
sed -i 's/^FEATURES/*p5-nvim-features*/' doc/p5-nvim.txt
sed -i 's/^CONFIGURATION/*p5-nvim-configuration*/' doc/p5-nvim.txt