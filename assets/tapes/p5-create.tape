Output assets/p5-create.gif

Set Shell bash
Set FontFamily "JetBrains Mono"
Set FontSize 18
Set Width 1200
Set Height 800
Set TypingSpeed 300ms
Set PlaybackSpeed 1.0
Set Theme "Catppuccin Frappe"
Set Padding 20
Set WindowBar Colorful

Hide
Sleep 1s
Type "export TERM=xterm-256color"
Enter
Type "PS1='$ '"
Enter
Type "mkdir -p ~/Sketches"
Enter
Show

Type "cd ~/Sketches && nvim"
Sleep 300ms
Enter
Sleep 4s
Type ":P5 create my-sketch"
Enter
Sleep 3s
Type ":e my-sketch/sketch.js"
Enter
Sleep 2s
Type ":q!"
Enter
