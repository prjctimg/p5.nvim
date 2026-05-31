Output assets/p5-create.gif

Set Shell bash
Set FontSize 20
Set Width 1200
Set Height 800
Set TypingSpeed 100ms
Set PlaybackSpeed 1.5
Set Theme "Catppuccin Frappe"
Set Padding 20
Set WindowBar Colorful

Hide
Type "R=$PWD"
Enter
Type "rm -rf /tmp/demo && mkdir -p /tmp/demo"
Enter
Show

Type "cd /tmp/demo && nvim -u $R/assets/init.lua"
Sleep 500ms
Enter
Sleep 2s
Type ":P5 create my-sketch"
Enter
Sleep 3s
Type ":e my-sketch/sketch.js"
Enter
Sleep 2s
Type ":q!"
Enter
