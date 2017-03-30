# archbk

A robust shell script (bash / sh) that automates the installation of an Arch Linux ARM base system, for use with ARM Chromebooks

Confirmed devices:
    
   Samsung Series 3 ARM Chromebook http://www.samsung.com/us/computer/chrome-os-devices/XE303C12-A01US-specs
    
Upcomming Devices:
    
   Asus Flip C100P https://www.asus.com/us/Commercial-Notebooks/ASUS_Chromebook_Flip_C100PA/
   Asus C201 https://www.asus.com/Notebooks/ASUS_Chromebook_C201/
   (check out the asus branch for more info)    

This script automates the install instructions found here: https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook
   
To install Arch Linux ARM on a SDcard / USB drive:

   * Make sure that developer mode is enabled.
   (enabling developer mode will wipe everything on the chromebook's internal flash memory. back up anything you want to keep.)

     hold down the ESC and Refresh keys and poke the ower button
     at the Recovery screen press Ctrl-D (there's no prompt - you have to know to do it).
     confirm switching to developer mode by pressing enter, and the laptop will reboot and reset the system. This takes about 15-20 minutes.
     Note: After enabling developer mode, you will need to press Ctrl-D each time you boot, or wait 30 seconds to continue booting.


   (the following steps work in chromeOS, and in most GNU/Linux distributions)
   (as long as the system has bash / dash, cgpt, grep, wget, sed) 

   1) get CROSH shell going (press ctrl + alt + t, then enter "shell")
   2) "cd ~/Downloads" (moves to your current user's downloads directory)
   3) "wget https://raw.githubusercontent.com/altreact/archbk/master/make-arch_drv.sh"
   4) "sudo sh make-arch_drv.sh"  or "sudo sh make-arch_drv.sh (dev)" ((dev) = sda, sdb, mmcblk1, ect)
   5) follow the instructions & let the script do it's thing.
   6) reboot, then press ctrl + u to boot Arch Linux ARM (username: root , password: root)
  
To install Arch Linux ARM to internal flash memory:

   1) create a chromeos recovery media device (https://goo.gl/FfCQkC)
   2) follow instructions above to install Arch Linux ARM on a SDcard / USB drive.
   3) reboot, then press ctrl + u to boot Arch Linux ARM (username: root , password: root)
   4) "sh helper.sh"
   5) follow the instructions & let the script do it's thing.
   6) reboot, then press ctrl + d to boot Arch Linux ARM (username: root , password: root)
   
After Installation:

   1) update your mirrorlist "/etc/pacman.d/mirrorlist" (https://wiki.archlinux.org/index.php/mirrors)
   2) "pacman -Syu" (updates system and all software)
   3) post install recommendations (https://wiki.archlinux.org/index.php/General_recommendations)
   4) if you don't fancy the command line interface and want a decent Graphical User Interface (GUI, DE), look below.

Upcomming features:
 
 * ability to use one script for multiple devices.
     
 * ability to install MATE Desktop Environment (https://mate-desktop.org/), based on the instructions found here: https://calvin.me/arch-linux-samsung-arm-chromebook/
