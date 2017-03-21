#!/usr/bin/env bash

# automated Arch Linux ARM install to target device
# target formatting, partitioning
# transfer rootfs, write kernel image
# optional - let's you keep arch tarball for later use
install_arch () {
  echo " "
  echo "enabling USB booting && booting of operating systems that aren't signed by google"
  crossystem dev_boot_usb=1 dev_boot_signed_only=0 2>/dev/null

  echo " "
  echo "1) unmounting target device"
  umount /dev/$media* 2>/dev/null
  
  fdisk /dev/$media <<EOF
  g
  w
EOF
  
  echo " "
  echo "2) creating GPT partition table with fdisk"
  cgpt create /dev/$media
  
  echo " "
  echo "3) creating kernel partition on target device"
  cgpt add -i 1 -t kernel -b 8192 -s 32768 -l Kernel -S 1 -T 5 -P 10 /dev/$media
  
  echo " "
  echo "4) calculating how big to make the root partition on target device, using information from cgpt show"
  sec="$(cgpt show /dev/$media | grep "Sec GPT table" | sed -r 's/[0-9]*[ ]*Sec GPT table//' | sed 's/[ ]*//')"
  
  sub="$(expr $sec - 40960)"
  
  echo " "
  echo "5) creating root partition on target device"
  c="$(echo "cgpt add -i 2 -t data -b 40960 -s $sub -l Root /dev/$media")"
  
  eval $c

  echo " "
  echo "6) refreshing what the system knows about the partitions on target device"
  partx -a "/dev/$media"
  
  echo " "
  echo "7) formating target device root partition as ext4"
  mkfs.ext4 -F "/dev/$p2"
  
  echo " "
  echo "8) moving to working directory"

  mkdir arch_tmp
  cd arch_tmp
  
  if [ !$path_to_tarball ]; then
    echo " "
    echo "9) downloading latest $ALARM tarball"
    wget http://os.archlinuxarm.org/os/$ARCH
    path_to_tarball="$ARCH"
  fi
  
  echo " "
  echo "10) mounting root partition"
  mkdir root
  mount /dev/$p2 root/
  
  echo " "
  echo "11) extracting rootfs to target device root partition"
  tar -xf $path_to_tarball -C root/
  
  # moves script and tarball into /root of target
  # enables one to run script again from ne arch install
  # see README.md for more info
  cp $path_to_tarball root/root/$ARCH
  cp $DIR/make-arch_drv.sh root/root/make-arch_drv.sh
  
  echo " "
  echo "12) writing kernel image to target device kernel partition"
  dd if=root/boot/vmlinux.kpart of=/dev/$p1
  
  echo " "
  echo "13) unmounting target device"
  umount root

  echo " "
  echo "syncing"
  sync
  
  echo " "
  echo "installation finished!"
  echo " "
  if [ -e "$ARCH" ]; then
    read -p "would you like to keep $ARCH in your "Downloads" directory for future installs? [y/n] : " a
    if [ $a = 'y' ]; then
      mv $ARCH $DIR/$ARCH
      
    fi
  fi
  
  cd .. && rm -rf arch_tmp
  
  echo " "
  if [ ${#media} -lt 3 ]; then
    echo "drives will not boot from the blue USB 3.0 port"
    echo "remember to plug drive into black USB 2.0 port to boot from it "
    read -p "poweroff the chromebook now? [y/n] : " b
    if [ $b = 'y' ]; then
      poweroff
    else
      echo " "
      echo "on boot, press ctrl+u to boot $ALARM."
      echo " "
    fi
  else
    read -p "reboot now? [y/n] : " c
    if [  $c = 'y' ]; then
      reboot
    fi
  fi
}

# confirms that only the install target device is connected
# stores appropriate device names, based on drive inserted (sda, mmcblk1, mmcblk1p2, ect)
init () {
  if [ "$(cat /etc/lsb-release | head -n1 | sed 's/[_].*$//')" = "CHROMEOS" ]; then
    os_dev="mmcblk0"
  else
    os_dev="$(lsblk | grep '[/]$' | sed 's/[^0-9a-z]*//' | sed 's/[^0-9a-z]*[ ].*//' | sed 's/[p].*//')"
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
      echo " " 1>&2
      echo "Make sure that only one media storage device (USB drive / SD card / microSD card) is plugged into this device." 1>&2
      echo " " 1>&2
      echo " " 1>&2
      echo "to safely remove a media storage device:" 1>&2
      echo "    1) go to files," 1>&2
      echo "    2) click the eject button next to the device you wish to remove," 1>&2
      echo "    3) unpug the device" 1>&2
      echo " " 1>&2
      echo " " 1>&2
      read -p "press any key to continue..." n
      count=0
    elif [ $count -lt 1 ]; then
      echo " " 1>&2
      echo "##################################" 1>&2
      echo '# no install media was detected. #' 1>&2
      echo "##################################" 1>&2
      echo " " 1>&2
      echo 'insert the media you want arch linux to be installed on,' 1>&2
      echo " " 1>&2
      echo " " 1>&2
      read -p "press any key to continue..." n
      count=0
    fi
  done
  echo $media
}

  echo " " 1>&2
  echo "remove all devices (USB drives / SD cards / microSD cards), except for the device you want Arch Linux ARM installed on." 1>&2
  echo " " 1>&2
  echo "to safely remove a media storage device:" 1>&2
  echo " " 1>&2
  echo "    1) go to files," 1>&2
  echo "    2) click the eject button next to the device you wish to remove," 1>&2
  echo "    3) unpug the device" 1>&2
  echo " " 1>&2
  echo " " 1>&2
  read -p "press any continue..." n
  
  if [ !$target_dev ]; then
    media="$(find_target_device)"
    echo "find_target_device"
  else
    media=$target_dev
    echo "target_dev"
  fi
 
  if [ ${#media} -gt 3 ]; then
    p1=$media"p1"
    p2=$media"p2"
  else
    p1=$media"1"
    p2=$media"2"
  fi
  
  echo " " 1>&2
  echo "****************" 1>&2
  echo "**            **" 1>&2
  echo "**  Warning!  **" 1>&2
  echo "**            **" 1>&2
  echo "****************" 1>&2
  echo " " 1>&2
  echo " " 1>&2
  echo "the device you entered will be formatted." 1>&2
  echo "all data on the device will be wiped," 1>&2
  echo "and Arch Linux ARM will be installed on this device." 1>&2
  echo " " 1>&2
  echo " " 1>&2
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
    echo " "                                              1>&2
    echo "\"$ARCH\" was found"                            1>&2
    echo " "                                              1>&2
    read -p "install $ALARM without re-downloading? [y/n] : " a
    echo " "
    if [ $a ]; then
      if [ $a = 'y' ]; then
        echo "$ALARM will be installed from local \"$ARCH\"" 1>&2
        echo "$DIR/$ARCH"
      else
        echo " " 1>&2
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
  
  manual_drive_selection () {
    if [ $1 ]; then
      release="$(cat /etc/lsb-release | head -n1 | sed 's/[_].*$//')"
      root_dev="$(lsblk 2>/dev/null | grep '[/]$' | sed 's/[0-9a-z]*//' | sed 's/[^0-9a-z]*[ ].*//' | sed 's/[p].*//')"
      here="$(lsblk 2>/dev/null | grep "$1[ ][ ]*" | sed -r 's/[^0-9a-z]*[ ].*//')"

      if [ -e $here ] || [ $2 ]; then
        echo "invalid device name" 1>&2
        exit 1
      elif [ $release = "CHROMEOS" ] && [ $1  = 'mmcblk0' ] || [ $1 = $root_dev ] 2>/dev/null; then
        echo "cannot install to $1. os is running from here" 1>&2
	exit 1
      else
        echo "$1"      
      fi
    fi
  }
  
  target_dev="$(manual_drive_selection $1)"

  if [ "$target_dev" != "$1" ]; then
    exit 1
  fi

  DIR="$(pwd)"
  ARCH='ArchLinuxARM-peach-latest.tar.gz'
  ALARM='Arch Linux ARM'
  path_to_tarball="$(have_arch)"
  
  if [ !$path_to_tarball ]; then
    confirm_internet_connection
  fi
}

main () {
  essentials $1
  init
  install_arch
}

main $1
