#!/usr/bin/env python3
import i3ipc
import os

i3          = i3ipc.Connection()
splitv_text = '↓'
splith_text = '→'
split_none  = '•'
parent      = i3.get_tree().find_focused().parent

if parent.layout   == 'splitv' :
    print( splitv_text )
    cmd='dunstify "{} Vertical"'.format(splitv_text)
    os.system('killall dunst')
    os.system(cmd)
elif parent.layout == 'splith' :
    print( splith_text )
    cmd='dunstify "{} Horizontal"'.format(splith_text)
    os.system('killall dunst')
    os.system(cmd)
else                           :
    print( split_none  )
