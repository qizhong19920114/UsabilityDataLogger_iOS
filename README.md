# UsabilityDataLogger_iOS

UsabilityDataLogger_iOS (UDL_iOS) is for human machine interaction and mobile application usability study and research. 

The majoy four functions are: 
- Record screen touch (locations and counts)
- Record keyboard touches (keys and counts)
- Record run time on each app
- Record browse history on browsers 

## Installation 
  Jail break the device. Nees to be iOS8 or above. 
  
  Install Cydia. 
  
  Install OpenSSH from Cydia. 
  - To test ssh on iphone, type 'ssh root@(your iPhone's IP address)' without the quotes or parentheses into the Terminal console and hit return. Enter the password 'alpine' and hit return. SSH is a good tool to debug the code, especially to check if there is any file missing. 
  
Install cydia tweak from tweaktest3_2 by running the upload.sh file (make sure to change the IP to the IP of your iPhone). The iPhone will re-spring after installation of tweak. Check if tweak is successfully installed by going to 'Installed' tab of Cydia and see if 'UsabilityDataLogger' tweak is in the list. 
  ```
  #!/bin/sh

  make
  make package 
  export THEOS_DEVICE_IP=192.168.1.72
  
  make package install
  
  ```


