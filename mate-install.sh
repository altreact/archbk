#!/usr/bin/env bash

pacman -S mate mate-extra xorg-server lightdm lightdm-gtk-greeter xf86-input-synaptics networkmanager network-manager-applet alsa-utils mate-power-manager xorg-xmodmap

--noconfirm

systemctl enable lightdm.service
systemctl enable NetworkManager.service
systemctl enable tp-wake-disable.service

f /sys/class/backlight/backlight.12/brightness 0666 - - - 800


echo 'Section "InputClass"
        Identifier "touchpad"
        Driver "synaptics"
        MatchIsTouchpad "on"
        Option "FingerHigh" "5"
        Option "FingerLow" "5"
        Option "TapButton1" "1"
        Option "TapButton2" "3"
        Option "TapButton3" "2"
        Option "HorizTwoFingerScroll" "on"
        Option "VertTwoFingerScroll" "on"
EndSection' >> /etc/X11/xorg.conf.d/70-synaptics.conf

echo '#!/bin/bash
cur_bri=$(/usr/bin/cat /sys/class/backlight/backlight.12/brightness)

if [ $1 == "up" ] ; then
    bri=$(($cur_bri+200))
    `echo $bri > /sys/class/backlight/backlight.12/brightness`
fi

if [ $1 == "down" ] ; then
    bri=$(($cur_bri-200))
    `echo $bri > /sys/class/backlight/backlight.12/brightness`
fi

if [ $1 == "-s" ]; then
    `echo $2 > /sys/class/backlight/backlight.12/brightness`
fi' >> /usr/local/bin/brightness

chmod +x /usr/local/bin/brightness

echo '[Unit]
Description=Disable trackpad waking computer

[Service]
Type=oneshot
ExecStart=/bin/sh -c "echo disabled > /sys/devices/12c70000.i2c/i2c-1/1-0067/power/wakeup"

[Install]
WantedBy=multi-user.target' >>  /etc/systemd/system/tp-wake-disable.service

echo '"xvkbd -xsendevent -text "[Prior]""
    m:0x4 + c:111
    Control + Up

"xvkbd -xsendevent -text "[Next]""
    m:0x4 + c:116
    Control + Down

"xvkbd -xsendevent -text "[Delete]""
    m:0x4 + c:22
    Control + BackSpace

"xvkbd -xsendevent -text "[End]""
    m:0x4 + c:114
    Control + Right

"xvkbd -xsendevent -text "[Home]""
    m:0x4 + c:113
    Control + Left' >> ~/.xbindkeysrc

echo 'xbindkeys &' >> ~/.xprofile

hostnamectl set-hostname arch-chromebook


