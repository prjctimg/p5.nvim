Output assets/p5-docs.gif

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
Show

Type "nvim -u $R/assets/init.lua"
Sleep 500ms
Enter
Sleep 2s
Type ":P5 docs"
Enter
Sleep 3s
Type ":q!"
Enter
