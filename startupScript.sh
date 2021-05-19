#!/bin/bash

#aaaah this is how I comment, cool
#This isn't operational yet, I have to implement it somehow

#Set all the various GPIO pins

#Setting up the Relay
#echo "136" > /sys/class/gpio/export
#echo "out" > /sys/class/gpio/gpio136/direction

#Setting up the keypad
#echo "117" > /sys/class/gpio/export
#echo "in" > /sys/class/gpio/gpio117/direction

#some code to turn on the camera
echo "1" > /sys/class/gpio/gpio136/value

#it seems I can wait until a particular command has completed, that sounds useful
sleep 5

#Take the photo and save it 
gphoto2 --capture-image #-and-download #--filename #%Y_%m_%d_%H_%M_%S.JPG #-u
#some code to rename the file

sleep 5

#Check for button press

button_press=$(cat /sys/class/gpio/gpio117/value)

echo "Button press value is: $button_press"


#Put Jessie to sleep
if test $button_press == 0;
then 
	echo "Time to sleep"
	echo "0" > /sys/class/gpio/gpio136/value
	tsmicroctl --sleep 3
else
	echo "carry on"
	echo "0" > /sys/class/gpio/gpio136/value
fi
