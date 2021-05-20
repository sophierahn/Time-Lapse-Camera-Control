#!/bin/bash

#Set all the various GPIO pins

#Setting up the Relay
echo "136" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio136/direction

#Setting up the keypad
echo "117" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio117/direction

#check the current date and time
now=$(date)

echo "Current date is: $now"

#check the schedule
schedule=$(head -n 1 ~/Time-Lapse-Camera-Control/schedule.txt)

echo "Next up on the schedule is: $schedule"

#Convert now and the scheduled time to seconds
#because thats what makes this math work

now_s=$(date -d "$now" '+%s')
schedule_s=$(date -d "$schedule" '+%s')

diff=$(($now_s - $schedule_s))

echo "Time difference is: $diff"
 
#only turn on the camera and take a picture if things are on schedule
if test $diff -ge -180; #if the difference is greater than or equal to 3 mins
then
	if test $diff -le 180;#if the difference is less than or equal to 3 mins
	then # we did it, we're on schedule
		echo "1" > /sys/class/gpio/gpio136/value
		sleep 5
		gphoto2 --capture-image
		#only delete the top entry once we've followed it
		#if we're planning to follow it, we'll need it again
		sed -i 1d ~/Time-Lapse-Camera-Control/schedule.txt
	else #we've way overshot the schedule 
		#so we definitely don't need that last entry
		sed -i 1d ~/Time-Lapse-Camera-Control/schedule.txt

		#now we fight back to our schedule
		schedule=$(head -n 1 ~/Time-Lapse-Camera-Control/schedule.txt)
	fi
else
	neg=-1	
	((time_sleep=neg*diff))
	echo $time_sleep
fi




#if test $now == $line;
#then 
	#something
#elif test $now -lt $line; #lt is greater than, le is greater than or equal to 
#then
	#something
#elif $now -gt $line; #
#then
	#something
 


#it seems I can wait until a particular command has completed, that sounds useful
#sleep 5

#Take the photo and save it 
#gphoto2 --capture-image #-and-download #--filename #%Y_%m_%d_%H_%M_%S.JPG #-u
#some code to rename the file

#date >> ~/Time-Lapse-Camera-Control/timestamps.txt

#sleep 5

#Check for button press

#button_press=$(cat /sys/class/gpio/gpio117/value)

#echo "Button press value is: $button_press"




#Put Jessie to sleep
#if test $button_press == 0;
#then 
#	echo "Time to sleep"
#	echo "0" > /sys/class/gpio/gpio136/value
#	tsmicroctl --sleep 3
#else
#	echo "carry on"
#	echo "0" > /sys/class/gpio/gpio136/value
#fi
