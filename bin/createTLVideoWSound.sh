#!/bin/bash

# ask for video name
# save name to videoname variable
# cd to videoname variable [error handling if it does not exist]
# select random song from usbstick
# echo randomsongtitle and ask if okay (y/n) 
# save randomsongpath
# if no select random song again and ask if okay
# check if image files exist or just video
# if just video echo so and exit program
# if files do exist run mencoder with songname

# mencoder snippet
mencoder -audiofile $randomsongpath -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 -vf scale=640:480 -mf type=jpeg:fps=$framespersecond mf://@frames.txt -o $NAME.avi

mencoder -audiofile file.mp3 -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 -vf scale=640:480 -mf type=jpeg:fps=10 mf://@frames.txt -o oscarPlaywSound.avi

mencoder -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 -vf scale=640:480 -mf type=jpeg:fps=10 mf://@frames.txt -o emilywSound2.avi -oac mp3lame -audiofile '/media/usb0/Music/Matches - Superman.mp3'

mencoder -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 -vf scale=640:480 -mf type=jpeg:fps=10 mf://@frames.txt -o emilywSound2.avi -oac mp3lame -audiofile "$randomsong"


# select random song from usbstick

find /media/usb0/Music -type f | shuf -n1



