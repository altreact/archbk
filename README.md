# archbk

A shell script (bash / sh) that automates the installation an Arch Linux ARM base system, for use with the Samsung Series 3 ARM Chromebook. http://www.samsung.com/us/computer/chrome-os-devices/XE303C12-A01US-specs

This script automates the install instructions found here: https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook


   
To install Arch Linux ARM on a SDcard / USB drive:

Make sure that developer mode is enabled.

  hold down the ESC and Refresh keys and poke the ower button
  at the Recovery screen press Ctrl-D (there's no prompt - you have to know to do it).
  confirm switching to developer mode by pressing enter, and the laptop will reboot and reset the system. This takes about 15-20 minutes.
  Note: After enabling developer mode, you will need to press Ctrl-D each time you boot, or wait 30 seconds to continue booting.

   1) get the script into your "~/Downloads" directory
   2) get CROSH shell going (press ctrl + alt + t, then enter "shell")
   3) "sudo sh ~/Downloads/make-archbk_drv.sh"
   4) follow the instructions & let the script do it's thing.
   5) reboot, then press ctrl + u to boot Arch Linux ARM (username: root , password: root)
  
To install Arch Linux ARM to internal flash memory:

   1) create a chromeos recovery media device (https://goo.gl/FfCQkC)
   2) follow instructions above to install Arch Linux ARM on a SDcard / USB drive.
   3) "sudo poweroff", then remove all usb storage devices (USB drives, SDcards)
   4) boot Arch Linux ARM (username: root , password: root)
   5) get an internet connection "wifi-menu -o" (for hidden SSID, see https://wiki.archlinux.org/index.php/netctl)
   6) "pacman -S wget cgpt"
   7) "sh make-arch_drv.sh"
   8) reboot, then press ctrl + d to boot Arch Linux ARM (username: root , password: root)
   
After Installation:

   * start to set up arch the way you want it (https://wiki.archlinux.org/index.php/General_recommendations)

Upcomming features:
  
  * run script from any GNU/Linux box
  * run script from any Mac
  
Possible helper scripts

  * Script that automates the install of MATE Desktop Environment https://mate-desktop.org/ to make the volume and brightness keys work with MATE, to remap the search key as the caps lock key, ect, based on the instructions found here: https://calvin.me/arch-linux-samsung-arm-chromebook/
