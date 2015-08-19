# UsabilityDataLogger_iOS

UsabilityDataLogger_iOS (UDL_iOS) is for human machine interaction and mobile application usability study and research. 

The majoy four functions are: 
- Record screen touch (locations and counts)
- Record keyboard touches (keys and counts)
- Record run time on each app
- Record browse history on browsers 

## Installation (Cydia Tweak)
  Jail break the device. Nees to be iOS8 or above. 
  - Downlaod [TaiG Jailbreak](http://www.taig.com) tool 
  - Download iOS system [firmware](http://www.iphonehacks.com/download-iphone-ios-firmware)
  - Install firmware by going to iTune and restore the iphone using firmware
  
Install Cydia. 
  
Install OpenSSH from Cydia. 
  - To test ssh on iphone, type 'ssh root@(your iPhone's IP address)' without the quotes or parentheses into the Terminal console and hit return. Enter the password 'alpine' and hit return. SSH is a good tool to debug the code, especially to check if there is any file missing. 
  
Install cydia tweak from tweaktest3_2 by running the upload.sh file or runing the shell command as shown below.Make sure to change the IP to the IP of your iPhone. The iPhone will re-spring after installation of tweak. Check if tweak is successfully installed by going to 'Installed' tab of Cydia and see if 'UsabilityDataLogger' tweak is in the list. 

  ```
  #!/bin/sh

  make
  make package 
  export THEOS_DEVICE_IP=192.168.1.72
  
  make package install
  
  ```

Install syslogd from Cydia

Install [deviceconsole](https://www.theiphonewiki.com/wiki/System_Log) on Mac device.   
  
  
## Installation (User Interface)
Install the xcode project in MobileDataLogger folder

## Installation (SandBox Path)
Need to change the SandBox Path in cydia tweak code to be able to find and modify data files. 
