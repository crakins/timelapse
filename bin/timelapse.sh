#!/bin/bash

# Declare variables
# Get timestamp
timestamp=$(date +%Y%m%d-%H%M%S)

# Get name of video, piccount, pictimer, frames per second, and music
# Error handling for duplicate directory names and greater than 15 second interval

echo “What is the name of this timelpase video?: ”
read NAME
if [ -d "/home/pi/timelapse/videos"$NAME ]
then
	oldNAME=$NAME
	NAME=${NAME}$timestamp
	echo -e "NOTICE: The name "$oldNAME" already exists! \nNOTICE: Your video name will be" $NAME"."
fi
echo “How many photos to take?”
read piccount
echo “How many seconds between each photo?[Must be great than 15]”
read pictimer
if [ $pictimer -le 14 ]
then
	pictimer=15
	echo "Nice try. Interval is" $pictimer "seconds."
fi
echo “How many frames per second [use 30 if you are not sure]?”
read framespersecond
echo “Delete all pictures after creating video [y/n]?”
# ADD: error handling for y or n response
read deletePics
echo "Would you like a random song as background music [y/n]?"
read randomSong
# ADD: error handling for y or n response

# Calculate time it will take to take all pictures
# add 4 seconds to $pictimer
pictimer_new=$(expr $pictimer + 4)
timeToTakeSeconds=$(expr $piccount \* $pictimer_new)
timeToTakeMinutes=$(expr $timeToTakeSeconds / 60)
timeToTakeInterval=$(expr $timeToTakeSeconds / $piccount)
echo "Got it. The webcam will take "$piccount" pictures, at "$pictimer" second intervals."
echo "Frame per second is "$framespersecond". "
echo "This will take approximately "$timeToTakeMinutes" minutes..."
echo ""

# Change to fswebcam directory
cd /home/pi/timelapse/videos

# Create new directory for timelapse from name provided
mkdir $NAME

# While loop to take photos with timelapse.conf
i=0
p=1

while [[ $i -lt $piccount ]]; do
   printf "3"
   sleep 1
   printf "  2"
   sleep 1
   printf "  1"
   sleep 1
   printf "  SAY CHEESE!!"
   sleep 1
   fswebcam -c "../bin/timelapse.conf" --save $NAME/$NAME-%Y-%m-%d%H:%M:%S.jpg
   let timeToTakeSeconds=$timeToTakeSeconds-$timeToTakeInterval
   let timeToTakeMinutes=$timeToTakeSeconds/60
   echo ""   
   echo "Picture "$p" of "$piccount" taken. Approximately "$timeToTakeMinutes" minutes remaining."
   echo ""
   sleep $pictimer 
   let p=$p+1
   let i=$i+1
done

# Create Timelapse video using mencoder
# navigate to directory
cd $NAME

# create frames.txt file for mencoder to read from
ls -1tr > frames.txt

# get random Music file if selected y
if [ "$randomSong" == "y" ]; then
   # use find command to find random .mp3 song
   randomSongPath=$(find /media/usb0/* -type f -name *.mp3 | shuf -n1)
   # run mencoder with song path
   mencoder -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 -vf scale=1920:1080 -mf type=jpeg:fps=$framespersecond mf://@frames.txt -o $NAME.avi -oac mp3lame -audiofile "$randomSongPath"
# else run mencoder with -nosound
else
   mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 -vf scale=1920:1080 -mf type=jpeg:fps=$framespersecond mf://@frames.txt -o $NAME.avi
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/9:vbitrate=8000000 -vf scale=640:480 -o $NAME.avi -mf type=jpeg:fps=$framespersecond mf://@frames.txt
fi

# run mencoder 
# mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 -vf scale=640:480 -mf type=jpeg:fps=$framespersecond mf://@frames.txt -o $NAME.avi
# mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/9:vbitrate=8000000 -vf scale=640:480 -o $NAME.avi -mf type=jpeg:fps=$framespersecond mf://@frames.txt

# remove all jpg and txt files if deletePics == y
if [ "$deletePics" == "y" ]; then
rm *.jpg *.txt
fi
