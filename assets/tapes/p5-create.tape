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
Type "export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring"
Enter
Type "mkdir -p ~/Sketches"
Enter
Type "clear"
Enter
Show

Type "cd ~/Sketches && nvim"
Sleep 1s
Enter
Sleep 3s
Type ":P5 create my-sketch"
Sleep 500ms
Enter
Sleep 3s
Type ":e my-sketch/sketch.js"
Sleep 500ms
Enter
Sleep 3s
Type ":q!"
Sleep 1s
Enter
Sleep 3s
