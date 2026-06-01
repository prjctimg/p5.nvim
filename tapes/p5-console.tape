Output assets/p5-console.gif

Set Shell bash
Set FontFamily "JetBrains Mono"
Set FontSize 18
Set Width 1200
Set Height 800
Set TypingSpeed 150ms
Set PlaybackSpeed 0.8
Set Theme "Catppuccin Frappe"
Set Padding 20
Set WindowBar Colorful

Hide
Sleep 1s
Type "ROOT=$PWD"
Enter
Type "export TERM=xterm-256color"
Enter
Type "PS1='$ '"
Enter
Type "mkdir -p ~/Sketches"
Enter
Type "mkdir -p ~/Sketches/my-sketch/assets/types ~/Sketches/my-sketch/assets/libs"
Enter
Type "printf 'function setup(){createCanvas(400,400)}function draw(){background(220)}' > ~/Sketches/my-sketch/sketch.js"
Enter
Type "printf '{\`version\`:\`2.0.5\`,\`major\`:2,\`libs\`:{},\`includes\`:[\`sketch.js\`]}' > ~/Sketches/my-sketch/p5.json"
Enter
Type "clear"
Enter
Sleep 500ms
Type "clear"
Enter
Show

Type "cd ~/Sketches/my-sketch && nvim -u $ROOT/tapes/init.lua sketch.js"
Sleep 500ms
Enter
Sleep 1.5s
Type ":P5 server"
Sleep 400ms
Enter
Sleep 2.5s
Type ":P5 console"
Sleep 300ms
Enter
Sleep 2s
Type ":P5 console"
Sleep 300ms
Enter
Sleep 2s
Type ":q!"
Sleep 400ms
Enter
Sleep 1s
