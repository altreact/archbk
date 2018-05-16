# archbk

A robust shell script (bash / sh) that automates the installation of an Arch Linux ARM base system, for use with ARM Chromebooks, based on the install instructions at [Arch Linux ARM](https://archlinuxarm.org/).

<br/>

Confirmed devices:
    
   * [Samsung Series 3 ARM Chromebook](http://www.samsung.com/us/computer/chrome-os-devices/XE303C12-A01US-specs)
   * [Acer Chromebook R13](https://www.acer.com/ac/en/US/content/series/acerchromebookr13)  
   * [Epik 11.6](https://www.walmart.com/ip/11-6-Chromebook-Laptop-Quad-Core-Processor-4GB-Ram-32GB-Hard-Drive/54445637)
   
   External only (sdcard, usb stick /drive) click [here](https://github.com/altreact/archbk/issues/3) for patch progress
   
   * [Asus Flip C100PA](https://www.asus.com/us/Commercial-Notebooks/ASUS_Chromebook_Flip_C100PA/)
   * [Asus C201](https://www.asus.com/Notebooks/ASUS_Chromebook_C201/)<br/>
    
Unconfirmed Devices:

   if you try the script for one of these devices, and it works, please let me know which chromebook it worked for, so i can add it to confimed devices. thank you.

   * [HP Chromebook 11 G1](https://goo.gl/GA02tj)
   * [HP Chromebook 11 G2](http://h20564.www2.hp.com/hpsc/doc/public/display?docId=emr_na-c04316411)
   * [Samsung Chromebook 2 11"](https://www.amazon.com/Samsung-Chromebook-Laptop-Exynos-Black/dp/B00J49ZH6K)
   * [Samsung Chromebook 2 13"](http://www.samsung.com/us/business/computing/chrome-devices/XE503C32-K01US)

   * and possibly other Chromebooks with the Exynos ARM Processor<br/>

   * [AOpen Chromebase Mini](http://www.aopen.com/us/chrome-mini-products)
   * [Asus Chromebit CS10](http://www.aopen.com/us/chrome-mini-products)
   * [Hisense Chromebook C11](https://www.engadget.com/products/hisense/chromebook/specs/)

   * and possibly other Chromebooks with the Rockchip RK3288 ARM Processor<br/>
   
   * [Samsung Chromebook Plus](http://www.samsung.com/us/computing/chromebooks/12-14/xe513c24-k01us-xe513c24-k01us/)
   
Possible Future Upcomming Devices:
   
   * [Acer Chromebase](https://goo.gl/9MVg8o)
   * [Acer Chromebook 13 (CB5-311)](https://www.acer.com/ac/en/US/content/model/NX.MPRAA.013)
   * [HP Chromebook 14 G3](http://support.hp.com/us-en/product/hp-chromebook-14-g3/7096564/manuals)
   
   <br/>
   
To install Arch Linux ARM on a SDcard / USB drive:

   ___* Make sure that developer mode is enabled.
   (enabling developer mode will wipe everything on the chromebook's internal flash memory. back up anything you want to keep.)___

     Hold down the ESC and Refresh keys and poke the Power button.
     At the Recovery screen press Ctrl-D 
     (there's no prompt - you have to know to do it).
     
     Confirm switching to developer mode by pressing enter, 
     and the laptop will reboot and reset the system. 
     
     This takes about 15-20 minutes.
     
     Note: After enabling developer mode, 
     you will need to press Ctrl-D each time you boot, 
     or wait 30 seconds to continue booting.
    <br/>

   _the following steps work in chromeOS_

   1) get CROSH shell going (press ctrl + alt + t, then enter `shell`)
   2) `cd ~/Downloads` (moves to your current user's downloads directory)
   3) `curl -LO https://raw.githubusercontent.com/altreact/archbk/master/make-arch_drv.sh`
   4) `sudo sh make-arch_drv.sh`  or `sudo sh make-arch_drv.sh (dev)` (where dev = sda, sdb, mmcblk1, ect)
   5) follow the instructions & let the script do it's thing.
   6) reboot, then press ctrl + u to boot Arch Linux ARM (username: root , password: root)
  
To install Arch Linux ARM to internal flash memory:

   1) [create a chromeos recovery media device](https://goo.gl/FfCQkC)
   2) follow instructions above to install Arch Linux ARM on a SDcard / USB drive.
   3) `sh helper.sh`(allows you to easily: change root password, create new sudo user, connect to wifi, install Arch on internal flash memory)
   4) follow the instructions & let the script do it's thing.
   5) press ctlr + d, then login with your new user credentials.
   
After Installation:

   1) [update your mirrorlist](https://wiki.archlinux.org/index.php/mirrors)
   2) `pacman -Syu` (updates system and all software)
   3) [other post install recommendations](https://wiki.archlinux.org/index.php/General_recommendations)
   4) if you don't fancy the command line interface and want a decent Graphical User Interface (GUI, DE), [install MATE Desktop Environment](https://calvin.me/arch-linux-samsung-arm-chromebook/)

Upcomming features:
 


 * ability to install [MATE Desktop Environment](https://mate-desktop.org/), based on the instructions found at [calvin.me](https://calvin.me/arch-linux-samsung-arm-chromebook/)
