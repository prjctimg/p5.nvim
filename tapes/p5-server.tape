Output assets/p5-server.gif

Set Shell bash
Set FontFamily "JetBrains Mono"
Set FontSize 18
Set Width 1200
Set Height 800
Set TypingSpeed 333ms
Set PlaybackSpeed 0.8
Set Theme "Catppuccin Frappe"
Set Padding 20
Set WindowBar Colorful
Env NVIM_APPNAME "p5nvim"

Hide
Sleep 1s
Type "ROOT=$PWD"
Enter
Type "export TERM=xterm-256color"
Enter
Type "PS1='$ '"
Enter
Type "rm -rf ~/Sketches ~/.config/p5nvim"
Enter
Type "mkdir -p ~/.config/p5nvim && ln -sf $ROOT/tapes/init.lua ~/.config/p5nvim/init.lua"
Enter
Type "mkdir -p ~/Sketches"
Enter
Type "cd ~/Sketches && nvim --headless -c 'P5 create --1 my-sketch' -c 'sleep 3' -c 'qa!' && cd my-sketch"
Enter
Sleep 8s
Type "clear"
Enter
Sleep 500ms
Type "clear"
Enter
Show

Type "nvim sketch.js"
Sleep 300ms
Enter
Sleep 1.5s
Type ":P5 server"
Sleep 300ms
Enter
Sleep 2.5s
Type ":P5 server"
Sleep 300ms
Enter
Sleep 2s
Type ":q!"
Sleep 300ms
Enter
Sleep 500ms
Hide
Type "rm -f ~/.config/p5nvim/init.lua && rmdir ~/.config/p5nvim 2>/dev/null; rm -rf ~/Sketches"
Enter
Sleep 500ms
