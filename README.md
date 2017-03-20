# archbk

A "bash" / "sh" shell script that automates the installation an Arch Linux ARM base system, for use with the Samsung Series 3 ARM Chromebook. http://www.samsung.com/us/computer/chrome-os-devices/XE303C12-A01US-specs

This script automates the install instructions found here: https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook


   
To install Arch Linux ARM on a SDcard / USB drive:

Make sure that developer mode is enabled.

  hold down the ESC and Refresh keys and poke the ower button
  at the Recovery screen press Ctrl-D (there's no prompt - you have to know to do it).
  confirm switching to developer mode by pressing enter, and the laptop will reboot and reset the system. This takes about 15-20 minutes.
  Note: After enabling developer mode, you will need to press Ctrl-D each time you boot, or wait 30 seconds to continue booting.
    
Download the script, and move it to the root of your Downloads folder

   1) Click the green "Clone or download button at the top-right hand side of the page, then clik the blue "Download ZIP" button.
   2) open the "archbk-master.zip" file, open the "archbk-master" folder, then drag and drop the "make-archbk_drv.sh" into your "Downloads" folder.
   3) get CROSH shell going (press ctrl + alt + t, then enter "shell")
   4) "sudo sh ~/Downloads/make-archbk_drv.sh" (this runs the script as root. no root, and the script can't do it's thing)
   5) Follow the instructions the scrip gives you (The script will let you kows if something is funky)
   5.5) Let the scrpt do it's thing.
   6) boot Arch Linux ARM enjoy!
  
   username: root
   password: root
  
To install Arch Linux ARM to internal flash memory:

   1) follow instructions above to install Arch Linux ARM on a SDcard / USB drive.
   2) create a chromeos recovery media device (https://goo.gl/FfCQkC)
   3) safely eject all usb storage devices (USB drives, SDcards)
   4) boot Arch Linux ARM (username: root , password: root)
   5) get an internet connection "wifi-menu -o" (for hidden SSID, see https://wiki.archlinux.org/index.php/netctl)
   6) "pacman -S wget cgpt"
   7) "sh make-arch_drv.sh"

Upcomming features:
  
  * Run script from any GNU/Linux box
  
  * Run script from any Mac
  
Possible helper scripts

  * Script that automates the install of MATE Desktop Environment https://mate-desktop.org/ to make the volume and brightness keys work with MATE, to remap the search key as the caps lock key, ect, based on the instructions found here: https://calvin.me/arch-linux-samsung-arm-chromebook/
