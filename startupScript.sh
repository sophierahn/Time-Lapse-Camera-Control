#!/bin/bash

#Set all the various GPIO pins

#Setting up the Relay
#echo "136" > /sys/class/gpio/export
#echo "out" > /sys/class/gpio/gpio136/direction

sleep 1

#Setting up the keypad
#echo "117" > /sys/class/gpio/export
#echo "in" > /sys/class/gpio/gpio117/direction

#check the current date and time
now=$(date)

echo "Current date is: $now"

#check the schedule
schedule=$(head -n 1 ~/Time-Lapse-Camera-Control/schedule.txt)

if test -z "$schedule";
then 
	echo "End of Schedule, shutting down"
else

	echo "Next up on the schedule is: $schedule"

	#Convert now and the scheduled time to seconds
	#because thats what makes this math work

	now_s=$(date -d "$now" '+%s')
	schedule_s=$(date -d "$schedule" '+%s')

	diff=$(($now_s - $schedule_s))

	echo "Time difference is: $diff"

	neg=1
	 
	#only turn on the camera and take a picture if things are on schedule
	if test $diff -ge -180; #if the difference is greater than or equal to 3 mins past the scheduled time (meaning we aren't super early)
	then
		if test $diff -le 180;#if the difference is less than or equal to 3 mins
		then # we did it, we're on schedule
			echo "On schedule, taking photo"
			sleep 0.5
			echo "1" > /sys/class/gpio/gpio136/value
			sleep 3
			gphoto2 --capture-image-and-download --keep
			JPG=(*.JPG)
			JPGsize=$(du *.JPG)
			now=$(date)
			#date >> ~/Time-Lapse-Camera-Control/timestamps.txt
			echo "$now $JPGsize" >> ~/Time-Lapse-Camera-Control/timestamps.txt
			rm $JPG
			#only delete the top entry once we've followed it
			#if we're planning to follow it, we'll need it again
			sed -i 1d ~/Time-Lapse-Camera-Control/schedule.txt
	
			
		else #we've way overshot the schedule 
			echo "Late wake up time, adjusting schedule"
			#so we definitely don't need that last entry
			while test $diff -gt 180;
			do
				sed -i 1d ~/Time-Lapse-Camera-Control/schedule.txt
				#now we fight back to our schedule
				now=$(date)
				now_s=$(date -d "$now" '+%s')
				schedule=$(head -n 1 ~/Time-Lapse-Camera-Control/schedule.txt)
				schedule_s=$(date -d "$schedule" '+%s')
				diff=$(($now_s - $schedule_s))

				if test -z "$schedule";
				then 
					#if after editing, the schedule is empty
					diff=-181
				fi
				
				
			done
			echo "Done editing the schedule"
			if test $diff -ge -180;
			then
				echo "Schedule caught up, current time is scheduled period"
				echo "Taking photo"
				sleep 0.1
				echo "1" > /sys/class/gpio/gpio136/value
				sleep 5
				gphoto2 --capture-image-and-download --keep
				JPG=(*.JPG)
				JPGsize=$(du *.JPG)
				now=$(date)
				#date >> ~/Time-Lapse-Camera-Control/timestamps.txt
				echo "$now $JPGsize" >> ~/Time-Lapse-Camera-Control/timestamps.txt
				#Get rid of the JPG so that it doesn't clog up the machine
				rm $JPG
				sed -i 1d ~/Time-Lapse-Camera-Control/schedule.txt
			else
				echo "Schedule caught up"
			fi
			
		fi		
	else
		echo "Early wakeup"
		#setting up variables for future arithmatic
	
	fi
	
	#The job of the nested if was to adjust the head of the schedule or not 
	#depending on the scenario
	#Now the new sleep time can be found

	if test $diff == -181;
	then 
		#indicator has been given, remain on
		echo "Schedule is empty, action is needed"
	else

		schedule=$(head -n 1 ~/Time-Lapse-Camera-Control/schedule.txt)
		now=$(date)
	
		now_s=$(date -d "$now" '+%s')
		schedule_s=$(date -d "$schedule" '+%s')
		#add a negative bc if the time is in the future (as it should be) itll be a negative sleep time
		neg=-1
		diff=$(($now_s - $schedule_s))
	
		echo "Calculating time to sleep"	
		((time_sleep=neg*diff))
		echo "Time to sleep: $time_sleep"
		
		sleep 5
		
		#Check for button press
		
		button_press=$(cat /sys/class/gpio/gpio117/value)
			
		
		
		
		#Put Jessie to sleep
		if test $button_press == 0;
		then 
			echo "Going to sleep"
			echo "0" > /sys/class/gpio/gpio136/value
			sleep 2
			if test $diff -gt 0;
			then
				#tsmicroctl --sleep $time_sleep
				echo "Would be sleeping"
			else
				echo "Input is unacceptable, closing program"
			fi

		else
			echo "Loop exit entered, closing program and remaining ON"
			echo "0" > /sys/class/gpio/gpio136/value
		fi	
	fi
fi
	
