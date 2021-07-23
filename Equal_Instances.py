import os
import sys
import datetime

#Use this script to create a text file filled with dates and times spaced at equal intervals between a start and end date

#Opening the file. Change "schedule.txt" to change the file name
#"w" means the file is overwritten each use. Change to "a" to simply append to the same file
scheduleFile = open(r"schedule.txt", "w")


#Can use a specific start date instead, but the system can manage a backlogged schedule
currentDate = datetime.datetime

#Set to desired end date and time, currently set for september 30th, 2022
endDate = datetime.datetime(2022, 9, 30)

#Time interval between schedule instances
hours = 3
while currentDate < endDate:
    
    #Creating next scheduled interval
    hours_added = datetime.timedelta(hours = hours)

    currentDate = currentDate + hours_added
    input = currentDate.strftime("%m/%d/%Y  %H:%M:%S\n")
    
    #writing to schedule file
    scheduleFile.write(input)


#closing schedule file
scheduleFile.close()
