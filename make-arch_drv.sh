# automated Arch Linux ARM install to target device
# target formatting, partitioning
# transfer rootfs, write kernel image
# optional - let's you keep arch tarball for later use
install_arch () {
  
  # creates, enables, and starts netctl profile for hidden ssid in Arch Linux
  # or starts wifi-menu for ssid that's not hidden
  # installs wget and cgpt, if user chooses option to install Arch Linux ARM to internal flash memory
  # gives option to install Arch Linux ARM to internal flash memory
  helper_script() {

    echo '#!/usr/bin/env bash
    
    echo "enter new root password"
    passwd root

    read -p "enter a username for your user: " username 
    useradd -m -G wheel -s /bin/bash $username
    passwd $username
    
    read -p "is your ssid hidden? [y/n]: " a
    echo
    if [ $a = "y" ]; then
      echo
      read -p "enter hidden SSID: " a
      ssid=$a
      read -sp "enter password: " a
      passwd="$(wpa_passphrase $ssid $a | grep -e "[ ]*psk" | tail -n1 | sed "s/[^0-9]*//")"
      cat /etc/netctl/examples/wireless-wpa | sed "s/wlan/mlan/g" | sed "s/#P/P/" | sed "s/#H/H/" | sed "s/MyNetwork/$ssid/" | sed "s/WirelessKey/$passwd/" > /etc/netctl/network
      netctl enable network && netctl start network
    else
      wifi-menu -o
    fi
    
    c="$(ping -c 1 google.com 2>/dev/null | head -1 | sed "s/[ ].*//")"
    if [ $c ]; then
      echo
      echo "you are now connected to the internet"
      echo
      echo "adding your new user to sudoers"
      pacman -S sudo vboot-utils --noconfirm
      echo "$username ALL=(ALL) ALL" >> /etc/sudoers
      crossystem dev_boot_usb=1 dev_boot_signed_only=0
    else
      echo
      echo "ssid and / or passphrase are invalid."
      exit 1
    fi
     
    echo
    read -p "do you plan on installing Arch Linux ARM to the internal flash memory? [y/n]: " a
     
    if [ $a = "y" ]; then
      echo
      echo "installing necessary programs"
      echo
      pacman -S cgpt wget --noconfirm
     
      echo
      read -p "install Arch Linux ARM to internal flash memory now? [y/n]: " a
      echo
           
      if [ $a = "y" ]; then 
        echo' > helper
     
      echo "      sh $SCRIPTNAME mmcblk0
        fi
      fi
      read -p 'the system will now reboot. login as your newly created user to continue' a
      reboot" >> helper
  }

  step=1

  echo
  # enabling USB booting && booting of operating systems that aren't signed by google
  crossystem dev_boot_usb=1 dev_boot_signed_only=0 2> /dev/null

  echo
  echo "$step) unmounting target device"
  step="$(expr $step + 1)"
  umount /dev/$media* 2> /dev/null
  
  fdisk /dev/$media 1> /dev/null <<EOF
  g
  w
EOF
  
  echo
  echo "$step) creating GPT partition table with fdisk"
  step="$(expr $step + 1)"
  cgpt create /dev/$media 1> /dev/null
  
  echo
  echo "$step) creating kernel partition on target device"
  step="$(expr $step + 1)"
  cgpt add -i 1 -t kernel -b 8192 -s 32768 -l Kernel -S 1 -T 5 -P 10 /dev/$media 1> /dev/null
  
  echo
  echo "$step) calculating how big to make the root partition on target device, using information from cgpt show"
  step="$(expr $step + 1)"
  sec="$(cgpt show /dev/$media | grep "Sec GPT table" | sed -r 's/[0-9]*[ ]*Sec GPT table//' | sed 's/[ ]*//')"
  sub="$(expr $sec - 40960)"

  echo
  echo "$step) creating root partition on target device"
  step="$(expr $step + 1)"
  c="$(echo "cgpt add -i 2 -t data -b 40960 -s $sub -l Root /dev/$media")"
  
  eval $c 1> /dev/null

  echo
  echo "$step) refreshing what the system knows about the partitions on target device"
  step="$(expr $step + 1)"
  partx -a "/dev/$media" 1> /dev/null 2>&1
  
  echo
  echo "$step) formating target device root partition as ext4"
  step="$(expr $step + 1)"
  mkfs.ext4 -F "/dev/$p2" 1> /dev/null 2>&1
  
  echo
  echo "$step) moving to working directory"
  step="$(expr $step + 1)"
  cd /tmp && mkdir arch_tmp 2> /dev/null && cd arch_tmp
  
  if [ ! $path_to_tarball ]; then
    echo
    echo "$step) downloading latest $ALARM tarball"
    echo
    step="$(expr $step + 1)"
    wget http://os.archlinuxarm.org/os/$ARCH
    path_to_tarball="$ARCH"
  fi
  
  echo
  echo "$step) mounting root partition"
  step="$(expr $step + 1)"
  mkdir root 2> /dev/null 1>&2
  mount /dev/$p2 root/
  
  echo
  echo "$step) extracting rootfs to target device root partition"
  step="$(expr $step + 1)"
  tar -xf $path_to_tarball -C root/ 2> /dev/null
  
  # moves script and tarball into /root of target
  # enables one to run script again from ne arch install
  # see README.md for more info
  cp $path_to_tarball root/root/$ARCH
  cp $DIR/$SCRIPTNAME root/root/$SCRIPTNAME
  
  # creates helper script that initiates / automates internet connection
  # moves script to root/ user's directory
  helper_script
  mv helper root/root/helper.sh
  
  echo
  echo "$step) writing kernel image to target device kernel partition"
  step="$(expr $step + 1)"
  dd if=root/boot/vmlinux.kpart of=/dev/$p1 1> /dev/null 2>&1
  
  echo
  echo "$step) unmounting target device"
  step="$(expr $step + 1)"
  umount root

  echo
  echo "$step) syncing"
  step="$(expr $step + 1)"
  sync
  
  echo
  echo "installation finished!"
  echo
  if [ ! -e "$DIR/$ARCH" ]; then
    read -p "would you like to keep $ARCH for future installs? [y/n] : " a
    if [ $a = 'y' ]; then
      mv $ARCH $DIR/$ARCH
      
    fi
  fi
  
  cd .. && rm -rf arch_tmp

  echo
  echo "********************************************************************"
  echo
  echo "press ctrl+u at startup screen to boot $ALARM."
  echo
  
  if [ ${#media} -lt 4 ]; then
    echo "drives will not boot from the blue USB 3.0 port"
    echo "remember to plug drive into black USB 2.0 port to boot from it "
    echo
    read -p "poweroff this device now? [y/n] : " b
    echo
    if [ $b = 'y' ]; then
      poweroff
    fi
  else
    read -p "reboot now? [y/n] : " c
    echo
    if [  $c = 'y' ]; then
      reboot
    fi
  fi
}

# confirms that only the install target device is connected
# stores appropriate device names, based on drive inserted (sda, mmcblk1, mmcblk1p2, ect)
init () {
  if [ "$(cat /etc/lsb-release 2> /dev/null | head -n1 | sed 's/[_].*$//')" = "CHROMEOS" ]; then
    os_dev="mmcblk0"
  else
    os_dev="$(lsblk 2> /dev/null | grep '[/]$' | sed 's/[^0-9a-z]*//' | sed 's/[^0-9a-z]*[ ].*//' | sed 's/[p].*//')"
  fi
  
find_target_device () {
  count=0
  while [ $count -lt 1 ]
  do
    base="$(lsblk -ldo NAME,SIZE 2> /dev/null | sed 's/^l.*$//g' | sed 's/^z.*$//g' |  sed "s/^$os_dev.*$//g" | grep 'G')"
    devices="$(echo $base | sed "s/[ ]*[0-9]*\.[0-9]G$//g")"
    
    for dev in $devices;
    do
      count=`expr "$count" + 1`
      media=$dev
    done
    
    if [ $count -gt 1 ]; then
      echo "#############################################" 1>&2
      echo '# more than one install media was detected. #' 1>&2
      echo "#############################################" 1>&2
      echo 1>&2
      echo 'Make sure that only one media storage device (USB drive / SD card / microSD card) is plugged into this device.)' 1>&2
      echo 1>&2
      echo 1>&2
      echo "to safely remove a media storage device:" 1>&2
      echo "    1) go to files," 1>&2
      echo "    2) click the eject button next to the device you wish to remove," 1>&2
      echo "    3) unpug the device" 1>&2
      echo 1>&2
      echo 1>&2
      read -p "press any key to continue..." n
      count=0
    elif [ $count -lt 1 ]; then
      echo 1>&2
      echo "##################################" 1>&2
      echo '# no install media was detected. #' 1>&2
      echo "##################################" 1>&2
      echo 1>&2
      echo 'insert the media you want arch linux to be installed on,' 1>&2
      echo 1>&2
      echo 1>&2
      read -p "press any key to continue..." n
      count=0
    fi
  done
  echo $media
}

  if [ $target_dev ]; then
    media=$target_dev
  else
    echo 1>&2
    echo "remove all devices (USB drives / SD cards / microSD cards), except for the device you want Arch Linux ARM installed on." 1>&2
    echo 1>&2
    echo "to safely remove a media storage device:" 1>&2
    echo 1>&2
    echo "    1) go to files," 1>&2
    echo "    2) click the eject button next to the device you wish to remove," 1>&2
    echo "    3) unpug the device" 1>&2
    echo 1>&2
    echo 1>&2
    read -p "press any continue..." n
    media="$(find_target_device)"
  fi
  
  if [ ${#media} -gt 3 ]; then
    p1=$media"p1"
    p2=$media"p2"
    if [ $media = "mmcblk0" ]; then
      type="Internal Flash Memory aka"
    else
      type="SDcard"
    fi
  else
    p1=$media"1"
    p2=$media"2"
    type="USB drive"
  fi
  
  echo 1>&2
  echo "****************" 1>&2
  echo "**            **" 1>&2
  echo "**  Warning!  **" 1>&2
  echo "**            **" 1>&2
  echo "****************" 1>&2
  echo 1>&2
  echo 1>&2
  echo "$type $media will be formatted." 1>&2
  echo "all data on the device will be wiped," 1>&2
  echo "and Arch Linux ARM will be installed on this device." 1>&2
  echo 1>&2
  echo 1>&2
  read -p "do you want to continue with this install? [y/n] : " a
  if [ $a ]; then
    if [ $a = 'n' ]; then
      exit 1
    fi
  else
    continue
  fi
}

# gives user the option to skip download, if arch linux arm tarball is detected
have_arch () {
  # if Arch Linux tarball is found
  if [ -e $ARCH ]; then
    # ask user if they want to skip download of new tarball
    echo 1>&2
    echo "\"$ARCH\" was found" 1>&2
    echo 1>&2
    read -p "install $ALARM without re-downloading? [y/n] : " a
    echo 1>&2
    if [ $a ]; then
      if [ $a = 'y' ]; then
        echo "$ALARM will be installed from local \"$ARCH\"" 1>&2
        echo "$DIR/$ARCH"
      else
        echo 1>&2
        echo "Arch Linux ARM will be downloaded" 1>&2
      fi
    fi
  fi
}

# checks if arch linux arm download is possible
# loops until the user establishes internet connection, or quits
confirm_internet_connection () {
  
  # checks for a good ping to URL
  check_conn () {
    c="$(ping -c 1 $1 2>/dev/null | head -1 | sed 's/[ ].*//')"
    if [ $c ]; then
      echo "0"
    fi
  }
  
  while [ true ]
  do
    # try to connect to archlinuxarm.org
    if [ "$(check_conn 'archlinuxarm.org')" ]; then
      break
    # if connection was bad,
    else
      # try to connect to duckduckgo.com
      if [ "$(check_conn 'google.com')" ]; then
        echo "failed to connect to archlinuxarm.org" 1>&2
        echo "site may be down" 1>&2
        echo "try again later" 1>&2
        exit 1
      # if both connections failed
      else
        clear
        echo " "                                                                 1>&2
        echo "#################################################################" 1>&2
        echo " "                                                                 1>&2
        echo "ArchLinuxARM-peach-latest.tar.gz was not found in this directory," 1>&2
        echo "   and cannot be downloaded without an internet connnection"       1>&2
        echo " "                                                                 1>&2
        echo "           connect to the internet and try again."                 1>&2
        echo " "                                                                 1>&2
        echo "   **********************************************************"     1>&2
        echo "   ***   press enter to retry, or press q+enter to quit   ***"     1>&2
        echo "   **********************************************************"     1>&2
        echo " "                                                                 1>&2
        echo "#################################################################" 1>&2
        echo " "                                                                 1>&2
        read -p " " a
        if [ $a ]; then
          if [ $a = 'q' ]; then
            exit 1
          fi
        fi
      fi
    fi
  done
}

# looks for install tarball in current directory, sets path to tarball, if found
# checks for internet connection, if needed
essentials () {
  
  # idiot-proofs manual drive selection
  manual_drive_selection () {

    release="$(cat /etc/lsb-release 2> /dev/null | head -n1 | sed 's/[_].*$//')"
    chromeos_root_dev="$(lsblk 2> /dev/null | grep /mnt/stateful_partition | tail -n1 | sed 's/part[ ]*\/mnt\/stateful_partition//g' | sed 's/[^0-9a-z]*[ ].*//' | sed 's/[^0-9a-z]*//g' | sed 's/p[0-9]//')"
    root_dev="$(lsblk 2> /dev/null | grep '[/]$' | sed 's/[0-9a-z]*//' | sed 's/[^0-9a-z]*[ ].*//' | sed 's/[^0-9a-z]*//g' | sed 's/[p].*//')"
    here="$(lsblk 2> /dev/null | grep "$1[ ][ ]*" | sed -r 's/[^0-9a-z]*[ ].*//')"
      
    if [ ${#1} -lt 3 ] || [ $2 ] || [ ! $here ]; then
      echo "invalid device name" 1>&2
    elif [ $release = 'CHROMEOS' 2> /dev/null ] || [ $release = 'DISTRIB' 2> /dev/null ] &&  [ $1  = "$chromeos_root_dev" ] || [ $1 = $root_dev 2> /dev/null ]; then
      echo "cannot install to $1. os is running from here" 1>&2
    else
      echo "$1"
    fi
  }
  
  have_prog () {
    $($1 2>fail.txt 1>/dev/null)
    res="$(cat fail.txt 2>/dev/null | sed "s/\n//g" 2>/dev/null | sed 's/ //g')"
    rm fail.txt
    
    if [ $res 2>/dev/null ]; then
      $(echo "$1" >> fail.res)
    fi
  }

  if [ $1 ]; then
    target_dev="$(manual_drive_selection $1 $2)"
    if [ ! $target_dev ]; then
      exit 1
    fi
  fi
  
  have_prog sed
  have_prog grep
  have_prog lsblk
  have_prog wget
  have_prog cgpt
  
  if [ -e fail.res ]; then
    echo
    echo "install"
    cat fail.res
    echo "then run this script again"
    echo
    rm fail.res
    exit 1
  fi

  # determine which Arch Linux ARM rootfs to use
  
  # sudo /usr/sbin/chromeos-firmwareupdate -V gives valuable model info
  # have testers run this command and report output

  chr_codename="$(/usr/sbin/chromeos-firmwareupdate -V | head -n2 | tail -n1 | sed 's/^.*d\///' | sed 's/\/u.*$//')"

  # samsung chromebook, HP Chromebook 11 G1, HP Chromebook 11 G2, Samsung Chromebook 2 13", Samsung Chromebook 2 11". "Exynos, daisy board variants", use "ALARM peach"
  # Acer Chromebook R13 "elm board" "Mediatek MT8173 Cortex-A72/A53 2.1GHz/1.7GHz quad-core HMP processor", use "ALARM oak"
  # ASUS Chromebook Flip C100PA,vASUS Chromebook C201, AOpen Chromebase Mini, Asus Chromebit CS10, AOpen Chromebox Mini, Hisense Chromebook C11, "Rockchip RK3288" use "ALARM veyron"
  # Samsung Chromebook Plus, "Rockchip RK3399" uses "ALARM gru"
  # Acer Chromebase, Acer Chromebook 13 (CB5-311), HP Chromebook 14 G3, "Tegra K1 nyan" are unaccounted for so far"
  
  # we need to determine if any of the devices above has a different installation process than our current single installation process.
  # if so, we need to set up the proper instsallation process, and link that process to the chromebook that needs it
 

  # note: r13 and chromebook plus installs are identical, yet have different kernel partiton sizes than daisy and veyron. both r13 and chromebook plus had identical partition sizes.
 
  # we need to organize the residual files left over by the install
  # if the user decides to keep the script and the tarball, lets create an appropriately named directory, rename the script to reflect the chromebook, and put tarball and script in the one directory, just in case the user is dealing with more than one chromebook.
  # let's keep things tidy!
  
  # let's have the generated helper script loop if the passwords are incorrect and / or if the internet connection failed
  # let's also have the script be ran at boot, via root's .bashrc, then remive itself from the bash rc after completion
  # give the user the option to keep parts of the helper script (hidden ssid, create user, ect)
  
  # come up with a script to link to the README.md that will harvest chromebook info and send it to us via email, in order to have enought info to account for unconfirmed chromebooks.


  if [ "$(echo "$chr_codename" | grep 'daisy')"  ] || [ "$(echo "$chr_codename" | grep 'peach')" ]; then
    alarm_codename='peach'
    echo $alarm_codename
  elif [ "$(echo "$chr_codename" | grep 'veyron')"  ]; then 
    alarm_codename='veyron'
    echo $alarm_codename
  fi
 
  # get the name of this script
  SCRIPTNAME=`basename "$0"`
  DIR="$(pwd)"
  ARCH="ArchLinuxARM-"$alarm_codename"-latest.tar.gz"
  ALARM='Arch Linux ARM'
  path_to_tarball="$(have_arch)"
  
  if [ ! $path_to_tarball ]; then
    confirm_internet_connection
  fi
}

main () {
  essentials $1 $2
  init
  install_arch
}

main $1 $2
