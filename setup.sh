#!/bin/bash 

#Setting up the relay
echo "136" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio136/direction

sleep 1 

#Setting up the keypad
echo "117" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio117/direction
