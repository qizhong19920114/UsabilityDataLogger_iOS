###DeveloperNotes

BUG: Aug-24-2015 12:01: 
- Need to make a Chinese version. 

FIX: Aug-23-2015 10:52: 
- Seperate the tableView from the viewController so that tab bar and status bar won't be scrolled off the screen 

- Add the background image, button images and tab icons

BUG/Improvement: Aug-23-2015 13:00:

- fix the tab name when scrolling down to the bottom 

- The status text are not shown when scrolling down to the bottom 

- Table row switching color so it looks better. 


BUG (FIX): Aug-23-2015 12:56:

- Add drag notice ("drag table to 1/4 of the screen to refresh")

- Change all the text label to non-editable

- Add special key recording for Keyboard (DELETE, RETURN, SPACE)

- Fix the setting tab (signal files wasn't initialized)

- Keep data in analysis tab unless Clear button is clicked. 


BUG: Aug-21-2015 14:17: 

- Need to fix all the non-system icons;
                          
- Data being recorded without start; 
                          
- Need to accumulate data unless clear button being hit (can be done through syslogd);

- Data mismatch can be handled by using 'estimated data'. So the data is displayed tho it's not accurate. And we can use asterisk and note to remind user that it may because improper operation such as reopen app, using some system app and etc..



TEST: Aug-21-2015 13:54: 

Test all the apps on iPad: DMPHG0CYDJ8R. Video needs to be further tested, it shows Spring board on my test because there is no video downloaded; Newsstand and Music has the same problem; Mail and Tips won't record because they starts differntly by the system. Documents Pro is designed to not being recorded. 
      
| App     | Test |
| ------- | ---- |
| `Messages`| Check|
| `Calendar`| Check|
| `Reminders`| Check|
| `Map`     | Check|
| `Clock`   | Check|
| `Video` | Fail|
|`Contact`|Check|
|`Game Center`|Check|
|`iTune Store`|Check|
|`App Store`|Check|
|`News Stand`|Fail|
|`Camera`|Check|
|`Photo booth`|Check|
|`Setting`|Check|
|`iBook`|Check|
|`Photo`|Check|
|`FaceTime`|Check|
|`Music`|Check|
|`Safari`|Check|
|`Mail`|Check|
|`Documents Pro`|*|
|`Tips`|Fail|
|`SDKDemos`|Check|
|`Cydia`|Check|
|`Keyboard`|Keyboard|



      

BUG: Aug-20-2015 22:02: 

Test Setting tab, RunTime showing as X even after re-enabled. 
