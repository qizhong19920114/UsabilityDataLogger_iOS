/********************************************************************************************************************

Revision note: 

Apr/18/2015: finally able to call the bash command...

find the file and copy: 
                        find /home/shantanu/processed/ -name '*2011*.xml' -exec cp {} /home/shantanu/tosend  \;

find the file and delete: 
                        find . -name "FILE-TO-FIND" -exec rm -rf {} \;

                        find /Users/zhongqi/Documents/TweakTest -name 'Makefile_copy1' -exec cp {} /Users/zhongqi/Documents  \;

                        find /Users/zhongqi/Documents/TweakTest -name 'Makefile_copy' -exec rm -rf {} \;


Revision notes: 
                * Apr/30/2015: Now able to obtain the app nanme (no need to grep)
                                Now able to save the touchcnt and realtouch signal file using system call
                                 not sure if it will work when cydia recovers from the chmod 777
                                  three apps still have sandbox issue: maybe need to find a diff place to save them
                                    they are: calendar, photos, camera....

                                Clean up the code...Seems to work... May have some little glitches but can work on it
                                    later. 

                                Now add different marks for diffent data: Appname: MDL1; TOUCH: MDL2; KEYstroke: MDL3; 
                                                                        HomekeyPress: MDL4 ??

                                Awk doesn't exist, so just save it and process it in MDL app code....           

                * Jun/25/2015: >Fix the keystroke count bug (count don't overlap between apps)
                               >Add a line in the XCode Project to provent the crash (if lines of name and touch and keystrokes 
                                    not equal, then don't display)
                               >Fix the keystrokes didn't count as realtouch bug
                               >Fix the touchcount not reset bug 
                               >Fix the touchcount increment not based on read file bug 
                * Jun/26/2014: >Fix the Calender, photo, camera sandbox issue
                               >Clear the browser data when click homekey
*********************************************************************************************************************/

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static int touchcount = 0; 
static int keystrokecount = 0; 
static int homekeypressvar = 0; 

//Create a string array for system apps (versus user apps)
//including the keyboard app
//
NSArray *sysAppArray =[NSArray arrayWithObjects: @"com.apple.PhotosViewService", @"com.apple.MobileReplayer", @"com.apple.MailCompositionService", 
                        @"com.apple.DataActivation", @"com.apple.iad.iAdOptOut", 
                         @"com.apple.appleaccount.AACredentialRecoveryDialog", @"com.apple.AccountAuthenticationDialog",
                        @"com.apple.AskPermissionUI",@"com.apple.TencentWeiboAccountMigrationDialog",
                          @"com.apple.family", @"com.apple.purplebuddy", @"com.apple.mobilesms.notification", 
                          @"com.apple.ios.StoreKitUIService", @"com.apple.SiriViewService", @"com.apple.AdSheetPhone",
                          @"com.apple.CompassCalibrationViewService", @"com.apple.SharedWebCredentialViewService",
                          @"com.apple.WebSheet", @"com.apple.CoreAuthUI", @"com.apple.FacebookAccountMigrationDialog", 
                          @"com.apple.MusicUIService", @"om.apple.datadetectors.DDActionsService", 
                          @"com.apple.WebViewService", @"com.apple.gamecenter.GameCenterUIService", @"com.apple.InCallService",
                          @"com.apple.mobilecal.widget", 
                          @"com.ueseo.MobileDataLogger", @"com.apple.springboard",@"BJHStudios.iOSKeyboardTemplateContainer.iOSKeyboardTemplate",
                          @"com.apple.mobilemail", @"com.savysoda.WiFiHDFree",
                          
                          nil];


@interface UIApplication ()
    - (void)updateTouches:(NSSet *)touches;
@end 



%hook UIApplication

- (void)_run {
    %log; 

    //Obtain appID 
    NSString* appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSLog(@"App ID is: %@", appID);

    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *infoDict = [bundle infoDictionary];
    NSString *appName = [[NSBundle mainBundle] localizedInfoDictionary][@"CFBundleDisplayName"];//this work for some but not for all....

              

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName_touchcnt = [NSString stringWithFormat:@"%@/touchcnt.txt",
                                      documentsDirectory];

    
   

        if (appName == nil)
        {
              appName = [infoDict objectForKey:@"CFBundleName"]; //only works for the system default apps
              

              if (appName == nil) // this time just use the id if both way of fetch app name failed
              {
                    appName = appID;

              }
        }

        //Here is how to obtain timeStamp
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];

        //NSLog(@"App ID is: %@", appID);

        if ([sysAppArray containsObject: appID]) 
        {
            NSLog(@"Run");
        }
        else 
        {
            //clear the touchcnt to 0 everytime launch the app
            NSString *content = [NSString stringWithFormat:@"%d", 0];
            BOOL success3 = [content writeToFile:fileName_touchcnt
                                atomically:NO 
                                   encoding:NSUTF8StringEncoding 
                                          error: nil];
            NSLog(@"Success_start write cnt = %d", success3);



            //Try to fix the photo sandbox issue
            if([appID isEqualToString:@"com.apple.mobileslideshow"])
            {
                //clear the touchcnt to 0 everytime launch the app
                
                BOOL success_photo = [content writeToFile:@"/Applications/PhotosViewService.app/touchcnt.txt"
                                atomically:NO 
                                   encoding:NSUTF8StringEncoding 
                                          error: nil];
                NSLog(@"Success_start_photo write cnt = %d", success_photo);
            }

            //Try to fix the Calender sandbox issue 
            if([appID isEqualToString:@"com.apple.mobilecal"])
            {
                //clear the touchcnt to 0 everytime launch the app
                
                BOOL success_calender = [content writeToFile:@"/Applications/MobileCal.app/touchcnt.txt"
                                atomically:NO 
                                   encoding:NSUTF8StringEncoding 
                                          error: nil];
                NSLog(@"Success_start_calender write cnt = %d", success_calender);
            }
            //Try to fix the Camera sandbox issue
            if([appID isEqualToString:@"com.apple.camera"])
            {
                //clear the touchcnt to 0 everytime launch the app
                
                BOOL success_camera = [content writeToFile:@"/Applications/Camera.app/touchcnt.txt"
                                atomically:NO 
                                   encoding:NSUTF8StringEncoding 
                                          error: nil];
                NSLog(@"Success_start_camera write cnt = %d", success_camera);
            }

            // //clear history upon starting broswer
            // if([appID isEqualToString:@"com.apple.mobilesafari"])
            // {
            //     system("rm /private/var/mobile/Containers/Data/Application/33D6BC43-EE8E-4049-9520-66F9C35DCBCC/Library/Safari/History*");
            //      NSLog(@"clear the broswer history");

            // }

            //NSLog(@"MDL: Run");
            NSLog(@"MDL1: %@",appName);
            NSLog(@"RawData1: %@ start %@", timeStampObj, appName);
        }   

        touchcount = 0; 
        
    %orig;
}

//*************** Touch log ******************************************************//
//#import <SpringBoard/SpringBoard.h>
//#import <SpringBoard/UIApplicationDelegate-Protocol.h>
//UIView *_touchView; // may not work this way, need to fetch the value of _touchView

//%hook UIApplication 
-(void) sendEvent:(UIEvent*) event 
{
    %orig;
    //%log; 
    //NSLog(@"In sendEvent2");
   



    	if([event type] == UIEventTypeTouches){

            //NSLog(@"In sendEvent");
    		//NSSet* touches = [event allTouches];
    		[self updateTouches:[event allTouches]];
    	}
        else 
        {
                homekeypressvar ++; // one home key press will generate two this event, but we only need to write once..
                 NSLog(@"homekeypressvar == %d !!!!", homekeypressvar);
                if (homekeypressvar == 2)
                {    
                    homekeypressvar = 0;

                    NSLog(@"homekeypressvar == 2 !!!!");
                    BOOL fileExists1 = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/startRecord.txt"];
                    if (fileExists1)
                    {
                        NSLog(@"Start Record File exists!!!\n");
                        //if this file exist, then reset the syslog file to start recording.
                        NSError * error1 = nil; //error variable


                        //reset syslog only when clear data is clicked. 
                        BOOL fileExists_clearData = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/clearData.txt"];
                        if (fileExists_clearData)
                        {
                            system("cat /var/log/resetlog > /var/log/syslog"); //don't use remove just cat
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                
                            //remove the clear data signal once used. 
                            BOOL success = [fileManager removeItemAtPath:@"/var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/clearData.txt" error:&error1];
                
                            NSLog(@"remove clear Data signal file Success = %d, error = %@", success, error1);  

                        }


                        //Then remove the start recording signal file....
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                
                        BOOL success = [fileManager removeItemAtPath:@"/var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/startRecord.txt" error:&error1];
                
                        NSLog(@"remove signal file Success = %d, error = %@", success, error1);          
                    }

                    //find the file and copy to the Documents folder...
                    //the realapptouch file is a signal file that prevent springboard action being recorded. Because only touches on 
                    // apps will generate that signal file.
                    system("find /var/mobile/Containers/Data/Application/ -name 'realapptouch.txt' -exec cp {} /var/mobile/Documents/  \\;");
                    system("find /var/mobile/Containers/Data/Application/ -name 'realapptouch.txt' -exec rm -rf {} \\;");

                    //photo sandbox issue
                    system("find /Applications/PhotosViewService.app/ -name 'realapptouch.txt' -exec cp {} /var/mobile/Documents/  \\;");
                    system("find /Applications/PhotosViewService.app/ -name 'realapptouch.txt' -exec rm -rf {} \\;");


                    //calender sandbox issue
                    system("find /Applications/MobileCal.app/ -name 'realapptouch.txt' -exec cp {} /var/mobile/Documents/  \\;");
                    system("find /Applications/MobileCal.app/ -name 'realapptouch.txt' -exec rm -rf {} \\;");

                    //camera sandbox issue
                    system("find /Applications/Camera.app/ -name 'realapptouch.txt' -exec cp {} /var/mobile/Documents/  \\;");
                    system("find /Applications/Camera.app/ -name 'realapptouch.txt' -exec rm -rf {} \\;");


                    //To fix the case when entering the Notepad but only use keyboard and no touching other part. Make sure this is realapprouch as well
                    system("find /var/mobile/Containers/Data/PluginKitPlugin/E218849B-F22B-4F14-AB19-054CA1095914/Documents/ -name 'realapptouch.txt' -exec cp {} /var/mobile/Documents/  \\;");
                    system("find /var/mobile/Containers/Data/PluginKitPlugin/E218849B-F22B-4F14-AB19-054CA1095914/Documents/ -name 'realapptouch.txt' -exec rm -rf {} \\;");

                   
                    BOOL  realapptouchExist = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Documents/realapptouch.txt"];

                    if (realapptouchExist)
                    {    
                        //Remove the file once the signal file is used
                        NSLog(@"realapptouchExist file does exists!!!!");
                        NSError * error5 = nil; //error variable                
                        NSFileManager *fileManager2 = [NSFileManager defaultManager];           
                        BOOL success = [fileManager2 removeItemAtPath:@"/var/mobile/Documents/realapptouch.txt" error:&error5];           
                        NSLog(@"remove signal file Success = %d, error = %@", success, error5);

                        //Fetch the keyboardstroke info
                        NSString *fileNam = @"/var/mobile/Containers/Data/PluginKitPlugin/E218849B-F22B-4F14-AB19-054CA1095914/Documents/keystroke.txt" ; 
                        NSString *keystrokecountstr = [NSString stringWithContentsOfFile:fileNam encoding:NSUTF8StringEncoding error:nil];//fetch the file content
                        NSLog(@"MDL3: keystrokecountstr: %@\n", keystrokecountstr); 
                        //NSLog(@"RawData: keystrokes: %@\n", keystrokecountstr); 


                        system("find /var/mobile/Containers/Data/Application/ -name 'touchcnt.txt' -exec cp {} /var/mobile/Documents/  \\;");
                        system("find /var/mobile/Containers/Data/Application/ -name 'touchcnt.txt' -exec rm -rf {} \\;");

                        //photo sand box
                        system("find /Applications/PhotosViewService.app/ -name 'touchcnt.txt' -exec cp {} /var/mobile/Documents/touchcnt.txt  \\;");
                        system("find /Applications/PhotosViewService.app/ -name 'touchcnt.txt' -exec rm -rf {} \\;");

                        //calender sand box
                        system("find /Applications/MobileCal.app/ -name 'touchcnt.txt' -exec cp {} /var/mobile/Documents/touchcnt.txt  \\;");
                        system("find /Applications/MobileCal.app/ -name 'touchcnt.txt' -exec rm -rf {} \\;");

                         //camera sand box
                        system("find /Applications/Camera.app/ -name 'touchcnt.txt' -exec cp {} /var/mobile/Documents/touchcnt.txt  \\;");
                        system("find /Applications/Camera.app/ -name 'touchcnt.txt' -exec rm -rf {} \\;");



                        NSString *fileNam2 = @"/var/mobile/Documents/touchcnt.txt"; 
                        NSString *touchcountstr = [NSString stringWithContentsOfFile:fileNam2 encoding:NSUTF8StringEncoding error:nil];//fetch the file content
                        NSLog(@"MDL2: touchcountstr: %@", touchcountstr);
                        //NSLog(@"RawData: touch count: %@", touchcountstr);

                        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];


                        NSLog(@"MDL4: HomeKeyPress");
                        NSLog(@"RawData1: %@ exit", timeStampObj);

                        //The code below reset the value of keyboard stroke count...(after fetch the value)
                        NSError * error1 = nil; //error variable     
                        int keystrokecount_local=0; 
                        NSString *content1 = [NSString stringWithFormat:@"%d\n", keystrokecount_local];
                        BOOL success1 = [content1 writeToFile:@"/var/mobile/Containers/Data/PluginKitPlugin/E218849B-F22B-4F14-AB19-054CA1095914/Documents/keystroke.txt" 
                                                 atomically:NO 
                                                       encoding:NSUTF8StringEncoding 
                                                              error:&error1];
                        NSLog(@"Reset keystroke Success = %d, error = %@", success1, error1);
                        
                        //system("cd /var/mobile/Documents; mkdir hello");
                        NSLog(@"RUN sys call>>");
                        //system("cd /var/mobile/Documents; ./abc.sh");

                        //system("cd /var/log/; cat /var/log/syslog | grep \"MDL\" > log");

                        system("cd /var/log/; cat /var/log/syslog | grep \"MDL1\" > /var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/appName"); 

                        system("cd /var/log/; cat /var/log/syslog | grep \"MDL2\" > /var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/touchCount");

                        system("cd /var/log/; cat /var/log/syslog | grep \"MDL3\" > /var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/keyStoke");

                        system("cd /var/log/; cat /var/log/syslog | grep \"MDL4\" > /var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/endTime");

                        
                        system("cd /var/log/; cat /var/log/syslog | grep \"RawData\" > /var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/toBeFormated.txt");
                        system("cd /var/log/; cat /var/log/syslog | grep \"RawData1\" > /var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/raw_data_runtime.txt");   
                        system("cd /var/log/; cat /var/log/syslog | grep \"RawData2\" > /var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/raw_data_touch.txt");   
                        system("cd /var/log/; cat /var/log/syslog | grep \"RawData3\" > /var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/raw_data_keystroke.txt"); 


                        //copy the database file of safari to the MDL app folder
                        system("cp /private/var/mobile/Containers/Data/Application/1A2F04E2-47E6-4745-9084-0CA12F4C1F6F/Library/Safari/History* /var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/");
                        //clear data broswer data
                        system("rm /private/var/mobile/Containers/Data/Application/1A2F04E2-47E6-4745-9084-0CA12F4C1F6F/Library/Safari/History*");
                    }  
                        
                        //This part copy the data to the record data to Document Pro (Export data)
                        BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/exportButtonPressed.txt"];
                        if (fileExists2)
                        {
                            //Then remove the start recording signal file....
                            NSFileManager *fileManager = [NSFileManager defaultManager];


                
                            [fileManager removeItemAtPath:@"/var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/exportButtonPressed.txt" error:nil];

                            //Put this outside of if real touch statement because this action needs to be done in MDL app which is excluded in real touch statement.
                            //The raw data should be saved in here: /var/mobile/Containers/Data/Application/2D1B0A69-8E7F-414D-9B90-964F7D9FE2FC/Documents 
                            //this is the place where Documents Pro files are stored. 

                            system("mkdir -p /var/mobile/Containers/Data/Application/349B7DDF-0358-476B-B4D4-6408710444D4/Documents/$(date +\"%m-%d-%y-%H-%M\");cp /var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/data* /var/mobile/Containers/Data/Application/349B7DDF-0358-476B-B4D4-6408710444D4/Documents/$(date +\"%m-%d-%y-%H-%M\")/");                   
                           
                            BOOL fileExists_url_used_sig = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/url_used_sig.txt"];
                    
                            if (fileExists_url_used_sig)
                            {
                                system("mkdir -p /var/mobile/Containers/Data/Application/349B7DDF-0358-476B-B4D4-6408710444D4/Documents/$(date +\"%m-%d-%y-%H-%M\"); cp /var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/url_data* /var/mobile/Containers/Data/Application/349B7DDF-0358-476B-B4D4-6408710444D4/Documents/$(date +\"%m-%d-%y-%H-%M\")/"); 
                           
                                [fileManager removeItemAtPath:@"/var/mobile/Containers/Data/Application/23306C91-42C6-4383-84B3-0D2555601861/Documents/url_used_sig.txt" error:nil];
                            }
                       }
                 }
        }
    
}

%new 
- (void)updateTouches:(NSSet *)touches
{
    //NSLog(@"Enter updateTouches");  
    for (UITouch *touch in touches)
    {
        //locationInView is a method defined in UITouch class
        //and we probably don't need to change locationInView, but
        //definite need to do something about touchView
        //CGPoint point = [touch locationInView:_touchView];

        //CGPoint point = [touch locationInView:nil]; //maybe I can just use nil
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];

        CGPoint point = [touch locationInView:touch.view];
        NSString *fileName_touchcnt = [NSString stringWithFormat:@"%@/touchcnt.txt",
                                      documentsDirectory];

        NSString* appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];

        NSLog(@"appID when touch: %@", appID);

        //Here is how to obtain timeStamp
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];

        NSString *touchcountstr;

        //UIView *fingerView = (UIView *)CFDictionaryGetValue(_touchDictionary, (__bridge const void *)(touch));
        NSLog(@"The point x is: %f and the point y is %f", point.x, point.y );

        
        if (touch.phase == UITouchPhaseEnded)
        {    
            //reload the touchcount value everytime event occurs(if statement for photo, camera and calender sandbox issue)
            if ([appID isEqualToString:@"com.apple.mobileslideshow"])
            {
                touchcountstr = [NSString stringWithContentsOfFile:@"/Applications/PhotosViewService.app/touchcnt.txt" encoding:NSUTF8StringEncoding error:nil];//fetch the file content
            }
            else if ([appID isEqualToString:@"com.apple.mobilecal"])
            {
                touchcountstr = [NSString stringWithContentsOfFile:@"/Applications/MobileCal.app/touchcnt.txt" encoding:NSUTF8StringEncoding error:nil];//fetch the file content
            }
            else if ([appID isEqualToString:@"com.apple.camera"])
            {
                touchcountstr = [NSString stringWithContentsOfFile:@"/Applications/Camera.app/touchcnt.txt" encoding:NSUTF8StringEncoding error:nil];//fetch the file content
            }
            else 
            {
                 touchcountstr = [NSString stringWithContentsOfFile:fileName_touchcnt encoding:NSUTF8StringEncoding error:nil];//fetch the file content
            }


            touchcount = [touchcountstr integerValue];
            touchcount ++; 
            NSLog(@"touchcount: %d \n",touchcount); 

            NSLog(@"RawData2: %@ touch [%f,%f]", timeStampObj, point.x, point.y );
        }







        if (![appID isEqualToString:@"com.apple.springboard"] && ![appID isEqualToString:@"com.ueseo.MobileDataLogger"] && ![appID isEqualToString:@"com.savysoda.WiFiHDFree"] )
        {           
            //make a file name to write the data to using the documents directory:
            NSString *fileName = [NSString stringWithFormat:@"%@/realapptouch.txt",
                                  documentsDirectory];

            NSLog(@"In update touches filepath: %@", fileName);
            
            NSString *content1 = @"abc";
            NSError * error4 = nil;

            BOOL success4 = [content1 writeToFile:fileName 
                                        atomically:NO 
                                            encoding:NSUTF8StringEncoding 
                                                error: &error4];
            NSLog(@"Success write realapptouch = %d, error = %@", success4, error4);

            //system("cat > /var/mobile/Documents/real.txt");

            NSString *content = [NSString stringWithFormat:@"%d", touchcount];
            NSError * error3 = nil;



            NSLog(@"fileName_touchcnt PATH: %@", fileName_touchcnt);

            BOOL success3 = [content writeToFile:fileName_touchcnt
                         atomically:NO 
                               encoding:NSUTF8StringEncoding 
                                      error: &error3];
            NSLog(@"Success write cnt = %d, error = %@", success3, error3);

            //fix the photo app sandbox issue
            if([appID isEqualToString:@"com.apple.mobileslideshow"])
            {
                //clear the touchcnt to 0 everytime launch the app
                 BOOL success_photo_realtouch = [content1 writeToFile:@"/Applications/PhotosViewService.app/realapptouch.txt" 
                                        atomically:NO 
                                            encoding:NSUTF8StringEncoding 
                                                error: nil];
                NSLog(@"Success_photo write realapptouch = %d", success_photo_realtouch);
                
                BOOL success_photo = [content writeToFile:@"/Applications/PhotosViewService.app/touchcnt.txt"
                                atomically:NO 
                                   encoding:NSUTF8StringEncoding 
                                          error: nil];
                NSLog(@"Success_start_photo write cnt = %d", success_photo);
            }

            //fix the Calender app sandbox issue
            if([appID isEqualToString:@"com.apple.mobilecal"])
            {
                //clear the touchcnt to 0 everytime launch the app
                 BOOL success_calender_realtouch = [content1 writeToFile:@"/Applications/MobileCal.app/realapptouch.txt" 
                                        atomically:NO 
                                            encoding:NSUTF8StringEncoding 
                                                error: nil];
                NSLog(@"Success_calender write realapptouch = %d", success_calender_realtouch);
                
                BOOL success_photo = [content writeToFile:@"/Applications/MobileCal.app/touchcnt.txt"
                                atomically:NO 
                                   encoding:NSUTF8StringEncoding 
                                          error: nil];
                NSLog(@"Success_start_calender write cnt = %d", success_photo);
            }


            //fix the Camera app sandbox issue
            if([appID isEqualToString:@"com.apple.camera"])
            {
                //clear the touchcnt to 0 everytime launch the app
                 BOOL success_camera_realtouch = [content1 writeToFile:@"/Applications/Camera.app/realapptouch.txt" 
                                        atomically:NO 
                                            encoding:NSUTF8StringEncoding 
                                                error: nil];
                NSLog(@"Success_camera write realapptouch = %d", success_camera_realtouch);
                
                BOOL success_camera = [content writeToFile:@"/Applications/Camera.app/touchcnt.txt"
                                atomically:NO 
                                   encoding:NSUTF8StringEncoding 
                                          error: nil];
                NSLog(@"Success_start_camera write cnt = %d", success_camera);
            }




        }
    }

}

%end 

//*****************************************************************************************//

//The code above is for keystrok Log; 
//The keyboard is third party keyboard iOSCustomKeyboard from github; 

%hook _UITextDocumentInterface

- (void)insertText:(id)arg1
{
   

        // %log; 
        //Here is how to obtain timeStamp
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];

        NSString* keystroke = @"";

        keystroke = [keystroke stringByAppendingString:arg1];

        if([keystroke isEqualToString:@" "])
        {
            keystroke = @"SPACE";
        }

        if([keystroke isEqualToString:@"\n"])
        {
            keystroke = @"ENTER";
        }


        NSLog(@"Hook_pressed: %@ ", keystroke);
        NSLog(@"RawData3: %@ key %@ ", timeStampObj, keystroke);


        //read the value 
        NSString *fileNam = @"/var/mobile/Containers/Data/PluginKitPlugin/E218849B-F22B-4F14-AB19-054CA1095914/Documents/keystroke.txt" ; 
        NSString *keystrokecountstr = [NSString stringWithContentsOfFile:fileNam encoding:NSUTF8StringEncoding error:nil];//fetch the file content

        keystrokecount = [keystrokecountstr integerValue];

        keystrokecount++; 
        NSLog(@"keystrokecount: %d\n",keystrokecount); 

        //The code below saves the record content to a file...
        NSError * error = nil; //error variable
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//fetch current path
        NSString *documentsDirectory = [paths objectAtIndex:0];//convert to string 

        NSString *fileName = [NSString stringWithFormat:@"%@/keystroke.txt", documentsDirectory]; //the file path

        NSLog(@"PATH IS: %@\n", fileName); 

        int keystrokecount_local=keystrokecount; 

        NSString *content = [NSString stringWithFormat:@"%d\n", keystrokecount_local];


        BOOL success = [content writeToFile:@"/var/mobile/Containers/Data/PluginKitPlugin/E218849B-F22B-4F14-AB19-054CA1095914/Documents/keystroke.txt" 
                                 atomically:NO 
                                       encoding:NSUTF8StringEncoding 
                                              error:&error];

        NSLog(@"Success = %d, error = %@", success, error);
        //NSLog(@"keystrokecount_after_written: %d\n",keystrokecount_local); 
       
    %orig;
}
%end 
















