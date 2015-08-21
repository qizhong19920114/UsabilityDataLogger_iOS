###DeveloperNotes

DEBUG: Aug-21-2015 14:17: 

- Need to fix all the non-system icons;
                          
- Data being recorded without start; 
                          
- Need to accumulate data unless clear button being hit (can be done through syslogd);

- Data mismatch can be handled by using 'estimated data'. So the data is displayed tho it's not accurate. And we can use asterisk and note to remind user that it may because improper operation such as reopen app, using some system app and etc..



TEST: Aug-21-2015 13:54: Test all the apps on iPad: DMPHG0CYDJ8R
      
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



      

BUG: Aug-20-2015 22:02: Test Setting tab, RunTime showing as X even after re-enabled. 
