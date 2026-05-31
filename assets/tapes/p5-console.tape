Output assets/p5-console.gif

Set Shell bash
Set FontFamily "JetBrains Mono"
Set FontSize 18
Set Width 1200
Set Height 800
Set TypingSpeed 80ms
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
Type "cd ~/Sketches && nvim --headless -c 'P5 create my-sketch' -c 'qa!'"
Enter
Show

Type "cd ~/Sketches/my-sketch && nvim sketch.js"
Sleep 300ms
Enter
Sleep 4s
Type ":P5 server"
Enter
Sleep 4s
Type ":P5 console"
Enter
Sleep 3s
Type ":P5 console"
Enter
Sleep 2s
Type ":q!"
Enter
