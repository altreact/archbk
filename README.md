# archbk

* confirmed to work with the Samsung Series 3 ARM Chromebook. 


A "bash" / "sh" shell script that automates the installation an Arch Linux ARM base system on removable storage, for use with the Samsung Series 3 ARM Chromebook. 

This script automates the install instructions found here: https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook

Big thanks to: 
  Richard Stallman for the GNU operating system, https://www.gnu.org/home.en.html
  Linus Torvalds for the Linux kernel and git, https://en.wikipedia.org/wiki/Linus_Torvalds
  the people at Arch Linux ARM, https://archlinuxarm.org
  github,
  and to everyone else involved for making this possible.



Instructions:



Make sure that developer mode is enabled.

  hold down the ESC and Refresh keys and poke the ower button
  at the Recovery screen press Ctrl-D (there's no prompt - you have to know to do it).
  confirm switching to developer mode by pressing enter, and the laptop will reboot and reset the system. This takes about 15-20 minutes.
  Note: After enabling developer mode, you will need to press Ctrl-D each time you boot, or wait 30 seconds to continue booting.
  
  
  
  
Things to be aware of before attempting to run this script:

  * As of now, this script is designed to run on the Samsung Series 3 ARM Chromebook, from within chromeOS.
      (Option to be able to run this script on another device are in the works.)
      (see the bottom of this document for a list of upcoming features and additional script plans)

  * The script will not run completely unless only one form of install media is mounted.
    (only 1 SD card / microSD car, or 1 usb drive should be mounted)    
    
  * There is currently no option to install to internal flash memory
      (feature is in the works)
    
  * You must be connected to the internet when the script is ran. - This script downloads the Arch Linux ARM GNU/Linux distribution. Without being connected to the internet. No internet, and the script can't do it's thing.
  
  
  
  
Download the script, and move it to the root of your Downloads folder

  1) Click the green "Clone or download button at the top-right hand side of the page, then clik the blue "Download ZIP" button.
  2) open the "archbk-master.zip" file, open the "archbk-master" folder, then drag and drop the "make-archbk_drv.sh" into your "Downloads" folder.
  

  3) press "ctrl + alt + t" (this brings up the crosh shell)
  
Crosh Shell commands

*Everything in quotes is ment to be entered into the Crosh Shell*
  
  4) "cd" (makes sure you are in you "home" directory. "makes it easier to navigate to the Downloads directory")
  5) "cd Downloads" (navigates to your Downloads directory using the crosh shell)
  6) "#sudo su" . (gives you root access - the script cannot do it's thing, unless it's ran root access)
  7) "chmod +x make-archbk_drv" (makes the script executable, let's the script run properly)
  8) "sh make-archbk_drv" (this runs the script)
  9) Follow the instructions the scrip gives you (The script will let you kows if something is funky)
  9.5) Let the scrpt do it's thing.
  10) enjoy!

Upcomming features:

  * Install from previous Arch Linux ARM download option (eliminating the need for an internet connection / downloading the operating system every time the script runs.)

  * Run this script from any device, to create a USB drive / SD card / microSD card that will let you run Arch Linux ARM on the Samsung Series 3 ARM Chromebook.
  
  * Install to internal flash memory (in order to do this, you must run the script from a removable storage device with Arch Linux ARM installed on it.)
  
Possible helper scripts

  * Script that automates the install of Mate Desktop Environment, to make the volume and brightness keys work with Mate, to remap the search key as the caps lock key, ect.
  
  Do you have any questions, comments, and/or concerns? 
  Feedback is welcomed and encoraged.
  Send me an email: altreact@gmail.com
