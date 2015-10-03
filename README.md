# UsabilityDataLogger_iOS

UsabilityDataLogger_iOS (UDL_iOS) is for human machine interaction and mobile application usability study and research. 

The majoy four functions are: 
- Record screen touch (locations and counts)
- Record keyboard touches (keys and counts)
- Record run time on each app
- Record browse history on browsers 

## Installation part 1 (Cydia Tweak)
  Jail break the device. Nees to be iOS8 or above. 
  - Downlaod [TaiG Jailbreak](http://www.taig.com) tool 
  If  your ios version is not 8.3, do the following two steps; otherwise, you can skip it. 
  - Download iOS system (ios 8.3) [firmware](http://www.iphonehacks.com/download-iphone-ios-firmware)
  - Install firmware by going to iTune and restore the iphone using firmware
  
Install Cydia. 
  
Install OpenSSH from Cydia. 
  - To test ssh on iphone, type 'ssh root@(your iPhone's IP address)' without the quotes or parentheses into the Terminal console and hit return. Enter the password 'alpine' and hit return. SSH is a good tool to debug the code, especially to check if there is any file missing. 
  
Install theos in your computer following the instruction: 
http://iphonedevwiki.net/index.php/Theos/Setup
or
https://www.youtube.com/watch?v=5XyoTtfCiMY

Install cydia tweak from tweaktest3_2 by running the upload.sh file or runing the shell command as shown below.Make sure to change the IP to the IP of your iPhone. The iPhone will re-spring after installation of tweak. Check if tweak is successfully installed by going to 'Installed' tab of Cydia and see if 'UsabilityDataLogger' tweak is in the list. 

(Make sure cydia is turned off when using upload.sh script)

  ```
  #!/bin/sh

  make
  make package 
  export THEOS_DEVICE_IP=192.168.1.72
  
  make package install
  
  ```

Install syslogd from Cydia. Also create an empty syslog file for reseting syslog. Name this file rst_syslog and put in /var/log/ directory. Need to use chmod 777 syslog to change the permission of syslog file so that it can be overwritten by resetlog. The commands are below:
- ssh root@172.29.2.123
- cd /var/log
- cat >rst_syslog (press ctrl+c to exit)
- chmod 777 syslog 
- use ls -l to check the permission change of syslog

Install [deviceconsole](https://www.theiphonewiki.com/wiki/System_Log) on Mac device.   
  
  
## Installation part 2 (User Interface)
Install the xcode project in MobileDataLogger folder. Make sure the device ID is profiled (registered) in the iOS developer account and the iOS version is set correctly. 
To register/profile an iOS device, we need to get the device's UUID in the XCode's device menu, then go to apple's developer website, select Devices, to register the device with UUID. Then select provisioning profiles based on that device , that app id , then download the provisioning profiles. Double-click the provisioning profile to install. 

## Installation part 3 (SandBox Path)
Need to change the SandBox Path in cydia tweak code to be able to find and modify data files. The biggest challenge of iOS jailbreak development is file operation. Directoreis of user applications and system applications are encoded with a sequence of numbers and letters and the sandbox sequence changes everytime the application re-installed. Therefore, certain sandbox sequence (for Usability Data Logger UI and for Pro Documents) need to be known and added to the tweak code. All other apps's data are accessed using the Unix "find" command. 

###Step1: find out the file path of Mobile Data Logger app. 
Open deviceconsole on your Macbook terminal. Open the application on your mobile device. Go to Recording tab and click on "start button". The file path should be shown in the terminal. For example, you should see a line similar to the line below. The file path of the app in this example is /var/mobile/Containers/Data/Application/2437026F-3995-48EB-B2A3-86B3ECC01297. And the sandbox sequence is 2437026F-3995-48EB-B2A3-86B3ECC01297.  (make sure you write this down because you will need this for the tweak source code)

```
Aug 19 23:25:16 iPad29 MobileDataLogger[2123] <Warning>: MobileDataLogger_filepath: /var/mobile/Containers/Data/Application/2437026F-3995-48EB-B2A3-86B3ECC01297/Documents
```
###Step2: find out the file path of Documents Pro 

### need to chmod on the /var/mobile/Containers/Data/Application/ folder....

### need to install keyboard and capture the keyboard file path...
 - use XCode to install it. 
 - We also need to change the sequence ID in the tweek.mx file. 
 - To find the sequence ID of the keyboard, we need to set the customized keyboard as the default keyboard in the language setting. 
 - then run the deviceconsole, find the sequence ID where it has PluginKitPlugin. The sequence ID after PluginKitPlugin is the ID for the keyboard. 
 - replace the sequence ID in the tweek.mx with the sequence ID you just get. 
 
### need to cd to /Applications then chmod -R 777 to give permission to write data to Calender, Photo and Slideshow app. 
  - use "ssh root@192.131.250.025" to log in the ipad. 
  - the password is "alpine"
  - then run "chmod 777 /var/mobile/Containers/Data/Application/2437026F-3995-48EB-B2A3-86B3ECC01297" to give it all permissions. 
  - chmod -R 777 /Applications/
  - ls -l /Applications/ to check the permission changes. (-l parameter is for details.)
## Testing the app
Here comes our testing drive. Please fasten your seat belt.

On the 'Analysis' tab, in order to refresh, drag the page down to 1/4 of the screen and hold for 1 second before releasing. 

