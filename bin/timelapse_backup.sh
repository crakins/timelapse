#!/bin/bash

# Get name of video, piccount, pictimer, and FPS
# need to add error handling for creating dir name to ensure not duplicate
echo “What is the name of this timelpase video?: ”
read NAME
echo “How many pictures to take?”
read piccount
echo “How many seconds between picture?”
read pictimer
echo “How many frames per second [use 30 if you are not sure]?”
read framespersecond
echo “Delete all pictures after creating video [y/n]?”
read deletePics
echo "Got it. The webcam will now take "$piccount" pictures, at "$pictimer" second intervals.  FPS is "$framespersecond". This may take a while..."

# Declare variables
# Get timestamp
timestamp=$(date +%Y%m%d-%H%M%S)

# Change to fswebcam directory
cd /home/pi/timelapse

# Create new directory for timelapse from timestamp
mkdir $NAME

# While loop to take photos with timelapse.conf
i=0

while [[ $i -lt $piccount ]]; do
   fswebcam -c timelapse.conf --save $NAME/$NAME-%Y-%m-%d%H:%M:%S.jpg
   sleep $pictimer
   let i=$i+1
done

# Create Timelapse video using mencoder
# navigate to directory
cd $NAME

# create frames.txt file for mencoder to read from
ls -1tr > frames.txt

# run mencoder 
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 -vf scale=640:480 -mf type=jpeg:fps=$framespersecond mf://@frames.txt -o $NAME.avi

# remove all jpg and txt files if deletePics == y
if [ "$deletePics" == "y" ]; then
rm *.jpg *.txt
fi
