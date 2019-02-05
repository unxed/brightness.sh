#!/bin/bash
#
# backlight.sh
# Adjusts screen brightness based on webcam image
#
# Installation:
#
# sudo apt-get install fswebcam xbacklight redshift
# sudo mkdir /opt/sh
# sudo cp ./backlight.sh /opt/sh
# sudo crontab -e
# */30 * * * * /opt/sh/backlight.sh
#
TMPFILE=`mktemp /tmp/tmp.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.jpg`
echo "Reading image from webcam..."
fswebcam -q --jpeg 95 $TMPFILE
echo "Calculating average brightness of an image..."
AVG=`convert $TMPFILE -format "%[mean]" info:`
rm -rf $TMPFILE
BRIGHT=`echo $AVG | awk '{print int($1/65535*100+30)}'`
if [ "$BRIGHT" -gt "100" ] ; then
 BRIGHT=100
fi
echo "Setting backlight brightness to $BRIGHT%"
#xbacklight -set $BRIGHT -time 2000
#pkexec mate-power-backlight-helper --set-brightness $BRIGHT
#correct way:
basedir="/sys/class/backlight/"
handler=$basedir$(ls $basedir)"/"
max_brightness=$(cat $handler"max_brightness")
new_brightness=$(( $max_brightness * $BRIGHT / 100 ))
sudo chmod 666 $handler"brightness"
echo $new_brightness > $handler"brightness"
#upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | grep discharging
#redshift -l `curl -s ipinfo.io/loc | tr "," ":"` -o
