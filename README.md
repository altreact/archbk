# archbk

A shell script (bash / sh) that automates the installation an Arch Linux ARM base system, for use with the Samsung Series 3 ARM Chromebook. http://www.samsung.com/us/computer/chrome-os-devices/XE303C12-A01US-specs

This script automates the install instructions found here: https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook
   
To install Arch Linux ARM on a SDcard / USB drive:

   * Make sure that developer mode is enabled.

     hold down the ESC and Refresh keys and poke the ower button
     at the Recovery screen press Ctrl-D (there's no prompt - you have to know to do it).
     confirm switching to developer mode by pressing enter, and the laptop will reboot and reset the system. This takes about 15-20 minutes.
     Note: After enabling developer mode, you will need to press Ctrl-D each time you boot, or wait 30 seconds to continue booting.


   (the following steps work in chromeOS, and in most GNU/Linux distributions)
   (as long as the system has bash / dash, cgpt, grep, wget, sed) 

   1) get the script into your "~/Downloads" directory
   2) get CROSH shell going (press ctrl + alt + t, then enter "shell")
   3) "cd ~/Downloads" (moves to your current user's downloads directory)
   4) "sudo sh make-archbk_drv.sh"  or "sudo sh make-arch_drv.sh <dev>" (<dev> = sda, sdb, mmcblk1, ect)
   5) follow the instructions & let the script do it's thing.
   6) reboot, then press ctrl + u to boot Arch Linux ARM (username: root , password: root)
  
To install Arch Linux ARM to internal flash memory:

   1) create a chromeos recovery media device (https://goo.gl/FfCQkC)
   2) follow instructions above to install Arch Linux ARM on a SDcard / USB drive.
   3) "sudo poweroff" (shuts down chromebook), then remove all usb storage devices (USB drives, SDcards)
   4) boot Arch Linux ARM (username: root , password: root)
   5) get an internet connection "wifi-menu -o" (for hidden SSID, "sh hidden-ssid.sh")
   6) "pacman -S wget grep cgpt" (installs software that the script depends on)
   7) "sh make-arch_drv.sh" or "sudo sh make-arch_drv.sh <dev> (<dev> = mmcblk0 {to install to internal flash memory}, mmcblk1, sda, ect)
   8) follow the instructions & let the script do it's thing.
   9) reboot, then press ctrl + d to boot Arch Linux ARM (username: root , password: root)
   
After Installation:

   1) update you mirrorlist "/etc/pacman.d/mirrorlist" (https://wiki.archlinux.org/index.php/mirrors)
   2) "pacman -Syu" (updates system and all software)
   3) post install recommendations (https://wiki.archlinux.org/index.php/General_recommendations)
   4) if you done't fancy the command line interface and want a decent Graphical User Interface (GUI, DE), look below.

Upcomming features:
  
  * run script from any Mac
  
Possible helper scripts

  * Script that automates the install of MATE Desktop Environment https://mate-desktop.org/ to make the volume and brightness keys work with MATE, to remap the search key as the caps lock key, ect, based on the instructions found here: https://calvin.me/arch-linux-samsung-arm-chromebook/
