set rtp+=.
set rtp+=..
set rtp+=../..
runtime plugin/plenary.vim

set packpath=
set runtimepath=

lua << EOF
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path
EOF
