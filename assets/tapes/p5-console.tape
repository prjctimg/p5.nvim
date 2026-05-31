Output assets/p5-console.gif

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
Type "cd /tmp/demo && nvim -u $R/assets/init.lua --headless -c 'P5 create my-sketch' -c 'qa!'"
Enter
Show

Type "cd /tmp/demo/my-sketch && nvim -u $R/assets/init.lua sketch.js"
Sleep 500ms
Enter
Sleep 2s
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
