#!/bin/bash
#Checks if user is root
if [[ "$(whoami)" != 'root'  ]];then
  echo "This script must be run as root!"
  exit
fi
#Checks for adb
if [[ -x /usr/bin/adb ]]
  then
    adblocation=/usr/bin/adb
  else if [[ -x ./adb ]]; 
  then
    adblocation=./adb
    #File permission fix - Thanks to Mark Lord
    sudo chmod a+rx adb
  else
  echo "Please enter the directory which contains adb"
  read adb
  adblocation=echo "${adb}/adb"
fi
fi

echo "---------------------------------------------------------"
echo "WhatsTab - WhatsApp Installer for Tablets"
echo "Created by @Complex360 (Twitter) cyr0s (xda-developers)"
echo "---------------------------------------------------------"
echo "Connect your MOBILE PHONE and press [ENTER]"
read mobile
$adblocation reboot recovery
echo "When recovery opens, mount data and press [ENTER]"
read mounted
echo "Extracting phone data..."
$adblocation pull /data/data/com.whatsapp/shared_prefs/PhoneRegister.xml PhoneRegister.xml
echo "Extracting account data..."
$adblocation pull /data/data/com.whatsapp/files/ ./files/
echo "Unplug your mobile and plug in your tablet, then, press [ENTER]"
read tablet
#Script will install WhatsApp if it hasn't already been installed
echo "Have you already installed WhatsApp? (y/n)"
read installation
if [[ $installation == "n" ]]; then
#Download and install WhatsApp apk.
echo "Downloading WhatsApp.apk..."
wget http://www.whatsapp.com/android/current/WhatsApp.apk
echo "Installing WhatsApp.apk..."
$adblocation install WhatsApp.apk
echo "WhatsApp installed sucessfully!"
fi
$adblocation reboot recovery
echo "When recovery opens, mount data and press [ENTER]"
read canadian_mounted_police
echo "Patching phone data..."
$adblocation push PhoneRegister.xml /data/data/com.whatsapp/shared_prefs/PhoneRegister.xml
echo "Patching account data..."
$adblocation rm -r /data/data/com.whatsapp/files/ ./files/
$adblocation push ./files/ /data/data/com.whatsapp/files/
echo "Cleaning up..."
sudo rm -r files && rm PhoneRegister.xml
echo "Done! Whatsapp should now function correctly on your tablet!"