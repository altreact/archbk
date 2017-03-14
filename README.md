# archbk

*note: confirmed to work with the samsung series 3 arm chromebook.

A bash script that automates the installation an arch linux arm base system on removable storage, for use with the samsung series 3 arm chromebook. 

It's amost a word for word automation of the install instructions found here: https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook


*****
|=>  disclaimer: by downloading this script, you are agreeing to use it, at your own risk. I am in no way responsible for any consequences you may encounter if you choose not to follow these directions. <=|
*****


Instructions:

enable developer mode.

  hold down the ESC and Refresh keys and poke the ower button
  at the Recovery screen press Ctrl-D (there's no prompt - you have to know to do it).
  confirm switching to developer mode by pressing enter, and the laptop will reboot and reset the system. This takes about 15-20 minutes.
  Note: After enabling developer mode, you will need to press Ctrl-D each time you boot, or wait 30 seconds to continue booting.
  
  after chromebook reboots:
  
  1) log in as guest (this speeds up the process leaving more more hardware resources to be used for the install
  2) press ctrl + alt + t (this brings up the crosh shell)
  3) enter "$cd Downloads" in the crosh shell (navigates to your Downloads directory using the crosh shell)
  4) get the script (click the green "clone or download" button, or just copy and paste the code into a new file. For simplicity's sake, name the file "make-archbk_drv" and make sure the file is in your Downloads directory)
  4.5) if you chose to download the file, instead of copying and pasting the code to a newly created file, extract the file using a chrome extension.
  5) get root access in crosh shell "#sudo su" . the script cannot do it's thing, unless it has root access)
  6) "#chmod +x make-archbk_drv (makes the script executable, let's you run the script)
  7) "#sh make-archbk_drv (this runs the script)
  8) let the scrpt do it's thing
  9) enter "#reboot" 
