//
//  FirstViewController.m
//  MobileDataLogger
//
//  Created by Zhong Qi on 4/11/15.
//  Copyright (c) 2015 Zhong Qi. All rights reserved.
//
///var/mobile/Containers/Data/Application/835DF609-DF29-4663-9BF8-92C2E94CB957/Documents/textfile.txt
//
//
//  write a file to to signify start recording; remove a file when finish recording...
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
#import "FirstViewController.h"
#import "DBManager.h"
#include <objc/runtime.h>

@interface FirstViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
   ///var/mobile/Containers/Data/Application/8F6441FD-828C-4DAB-BC9E-40FFEC48F823/Documents
    
    //D67BB2A-1F29-4137-AA35-247FE711F094
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

     NSLog(@"%@", documentsDirectory);
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"History.db"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

NSInteger counter = 0;
- (IBAction)buttonPress {
    
    NSError * error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/startRecord.txt", documentsDirectory];
    
    //this file stops all the homekey pressed in the tweak from running so the system runs faster when not using MDL
    NSString *fileName_recording = [NSString stringWithFormat:@"%@/Recording.txt", documentsDirectory];
    
    //=========== Decrement the license ============================
     NSString *fileName_license = [NSString stringWithFormat:@"%@/license", documentsDirectory];
    
     NSString *license_count_str = [NSString stringWithContentsOfFile:fileName_license encoding:NSUTF8StringEncoding error:nil];//fetch the file content
    
     int license_count = 0;
    
     license_count = [license_count_str integerValue];
    
     if(license_count > 0) { license_count--;}
    
     NSString *content_license = [NSString stringWithFormat:@"%d\n", license_count];
    
     BOOL success_license_wr = [content_license writeToFile:fileName_license
                             atomically:NO
                               encoding:NSUTF8StringEncoding
                                  error:nil];
    
    if (counter == 0 )
    {
        [self.buttonLabel setText:@"Recording"];
        counter ++;
        
        
        //The following code display all the apps
        //Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
        //NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
        //NSLog(@"apps: %@", [workspace performSelector:@selector(allApplications)]);
        
        //create content - four lines of text
        NSString *content = @"recording";
        //save content to the documents directory
        
        BOOL success = [content writeToFile:fileName
                                 atomically:NO
                                   encoding:NSUTF8StringEncoding
                                      error:&error];
        
        NSLog(@"Success = %d, error = %@", success, error);
        
        BOOL success_recording = [content writeToFile:fileName_recording
                                 atomically:NO
                                   encoding:NSUTF8StringEncoding
                                      error:&error];
        
        NSLog(@"Success = %d, error = %@", success, error);
        
        NSLog(@"MobileDataLogger_filepath: %@", documentsDirectory); 
        
        
    }
    else if (counter == 1)
    {
        [self.buttonLabel setText:@"Stopped"];
        counter ++;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL success = [fileManager removeItemAtPath:fileName error:&error];
        
        BOOL success_recording = [fileManager removeItemAtPath:fileName_recording error:&error];
        
        NSLog(@"remove Success = %d, error = %@", success, error);
    }
    else if (counter == 2)
    {
        [self.buttonLabel setText:@"Start"];
        counter = 0;
    }
}

- (IBAction)recordButtonPress {
    
    //NSLog(@"RECORD BUTTON PRESSED");
    
    //get the file path
    NSError * error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName_keystroke = [NSString stringWithFormat:@"%@/raw_data_keystroke.txt",
                          documentsDirectory];
    NSString *fileName_keystroke_processed = [NSString stringWithFormat:@"%@/data_keystroke.txt",
                                    documentsDirectory];
    
    NSString *fileName_touch = [NSString stringWithFormat:@"%@/raw_data_touch.txt",
                                    documentsDirectory];
    NSString *fileName_touch_processed = [NSString stringWithFormat:@"%@/data_touch.txt",
                                documentsDirectory];
    
    NSString *fileName_runtime = [NSString stringWithFormat:@"%@/raw_data_runtime.txt",
                                documentsDirectory];
    NSString *fileName_runtime_processed = [NSString stringWithFormat:@"%@/data_runtime.txt",
                                  documentsDirectory];
    
    NSString *fileName3 = [NSString stringWithFormat:@"%@/exportButtonPressed.txt",
                           documentsDirectory];
    NSString *recordButtonPressedContent = @"Yes";
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    
    [DateFormatter setDateFormat:@"yyyy-MM-dd_hh:mm:ss"];
    
  // NSString *currentDateTime = [NSString stringWithFormat:@"%@", [DateFormatter stringFromDate:[NSDate date]]];
    
    NSString *fileName_url_data = [NSString stringWithFormat:@"%@/url_data.txt",
                           documentsDirectory];
    
    NSString *fileName_url_used_sig = [NSString stringWithFormat:@"%@/url_used_sig.txt",
                                   documentsDirectory];
    
    //get the content from the file.
    NSString* fileContents_runtime =
    [NSString stringWithContentsOfFile:fileName_runtime
                              encoding:NSUTF8StringEncoding error:&error];
    NSArray* dataList_runtime =
    [fileContents_runtime componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    
    NSString* fileContents_touch =
    [NSString stringWithContentsOfFile:fileName_touch
                              encoding:NSUTF8StringEncoding error:&error];
    NSArray* dataList_touch =
    [fileContents_touch componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    NSString* fileContents_keystroke =
    [NSString stringWithContentsOfFile:fileName_keystroke
                              encoding:NSUTF8StringEncoding error:&error];
    NSArray* dataList_keystroke =
    [fileContents_keystroke componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    
    
    
    
    unsigned int i, cnt = [dataList_runtime count];
    NSString *appName_temp= @"";
    NSString *logToWrite_runtime = @"";
    NSString *logToWrite_touch = @"";
    NSString *logToWrite_keystroke = @"";
    NSString *urlToWrite = @"";
    
    BOOL browserUsed = 0;
    
    for(i = 0; i < cnt-1; i++)
    {
        NSString *currentTime = [[[dataList_runtime objectAtIndex:i] componentsSeparatedByString:@" "] objectAtIndex:2];
        
        
        NSString *currentTimeStamp = [[[[[dataList_runtime objectAtIndex:i] componentsSeparatedByString:@":"] objectAtIndex:4] componentsSeparatedByString:@" "] objectAtIndex:1];
        NSString *type = [[[[[dataList_runtime objectAtIndex:i] componentsSeparatedByString:@":"] objectAtIndex:4] componentsSeparatedByString:@" "] objectAtIndex:2];
        
       // NSLog(@"pass1");
        //NSLog(@"PRINT:%@",type);
        
        if([type isEqualToString:@"start"])
        {
           // NSLog(@"enter2");
            appName_temp = [[[[[dataList_runtime objectAtIndex:i] componentsSeparatedByString:@":"] objectAtIndex:4] componentsSeparatedByString:@" "] objectAtIndex:3];
            
            //NSLog(@"appName_temp:%@!!",appName_temp);
            
            NSString *temp_logToWrite = [NSString stringWithFormat:@"%@\t%@\tStart\t%@\n",currentTime, currentTimeStamp, appName_temp];
            
            if ([appName_temp isEqualToString:@"Safari"])
            {
                browserUsed = 1;
            }
            
            logToWrite_runtime = [logToWrite_runtime stringByAppendingString:temp_logToWrite];
            
        }
        else if ([type isEqualToString:@"exit"])
        {
            NSString *temp_logToWrite = [NSString stringWithFormat:@"%@\t%@\tEnd\t%@\n",currentTime, currentTimeStamp, appName_temp];
            
            logToWrite_runtime = [logToWrite_runtime stringByAppendingString:temp_logToWrite];
        }
    }
    
    [logToWrite_runtime writeToFile:fileName_runtime_processed
                 atomically:NO
                   encoding:NSUTF8StringEncoding
                      error: nil];
    
    //=========== This part process the touch ===========//
    unsigned int j, cnt2 = [dataList_touch count];
    
    for(j = 0; j < cnt2-1; j++)
    {
        NSString *currentTime = [[[dataList_touch objectAtIndex:j] componentsSeparatedByString:@" "] objectAtIndex:2];
        
        
        NSString *currentTimeStamp = [[[[[dataList_touch objectAtIndex:j] componentsSeparatedByString:@":"] objectAtIndex:4] componentsSeparatedByString:@" "] objectAtIndex:1];

        // NSLog(@"enter2");
        appName_temp = [[[[[dataList_touch objectAtIndex:j] componentsSeparatedByString:@":"] objectAtIndex:4] componentsSeparatedByString:@" "] objectAtIndex:3];
        //NSLog(@"appName_temp:%@!!",appName_temp);
            
        NSString *temp_logToWrite = [NSString stringWithFormat:@"%@\t%@\tTouch\t%@\n",currentTime, currentTimeStamp, appName_temp];
        
            
        logToWrite_touch = [logToWrite_touch stringByAppendingString:temp_logToWrite];
        
    }
    
    
    [logToWrite_touch writeToFile:fileName_touch_processed
                 atomically:NO
                   encoding:NSUTF8StringEncoding
                      error: nil];
    //=========== This part process the keystroke ==========//
    unsigned int k, cnt3 = [dataList_keystroke count];
    
    for(k = 0; k < cnt3-1; k++)
    {
        NSString *currentTime = [[[dataList_keystroke objectAtIndex:k] componentsSeparatedByString:@" "] objectAtIndex:2];
        NSString *currentTimeStamp = [[[[[dataList_keystroke objectAtIndex:k] componentsSeparatedByString:@":"] objectAtIndex:4] componentsSeparatedByString:@" "] objectAtIndex:1];
        
        // NSLog(@"enter2");
        appName_temp = [[[[[dataList_keystroke objectAtIndex:k] componentsSeparatedByString:@":"] objectAtIndex:4] componentsSeparatedByString:@" "] objectAtIndex:3];
        
        //NSLog(@"appName_temp:%@!!",appName_temp);
        
        NSString *temp_logToWrite = [NSString stringWithFormat:@"%@\t%@\tKeystroke\t%@\n",currentTime, currentTimeStamp, appName_temp];
        
        logToWrite_keystroke = [logToWrite_keystroke stringByAppendingString:temp_logToWrite];
    }
    
    [logToWrite_keystroke writeToFile:fileName_keystroke_processed
                       atomically:NO
                         encoding:NSUTF8StringEncoding
                            error: nil];
    
   
   
    //this block deal with the url_raw data, only process the history database if broswer is used.
    if (browserUsed == 1)
    {
        //fetch the database file that has the url info.
        NSString *query = @"select * from history_visits";
        NSArray *url_db = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        
        browserUsed = 0;
        for (int i=1; i< [url_db count]; i++) //count start from 1 because the first data index 0 is always empty
        {
            NSString *timeStamp_url = [[url_db objectAtIndex:i] objectAtIndex:2];
        
            NSString *actualUrl = [[url_db objectAtIndex:i] objectAtIndex:3];
        
            float time_stamp_url_float = [timeStamp_url intValue] + 31*31536000 + 86400*8;
        
            NSTimeInterval timeInterval=time_stamp_url_float;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setLocale:[NSLocale currentLocale]];
            [dateformatter setDateFormat:@"yyyy-MM-dd_hh:mm:ss"];
        
            NSString *dateString=[dateformatter stringFromDate:date];
        
            NSString *temp_urlToWrite = [NSString stringWithFormat:@"%@\t%@\t%@\n", timeStamp_url, dateString,actualUrl];
            urlToWrite = [urlToWrite stringByAppendingString:temp_urlToWrite];
        }
    
        [urlToWrite writeToFile:fileName_url_data
                     atomically:NO
                       encoding:NSUTF8StringEncoding
                          error: nil];
        
        [urlToWrite writeToFile:fileName_url_used_sig
                     atomically:NO
                       encoding:NSUTF8StringEncoding
                          error: nil];
    }
    
    //recordButtonPressed signal file.
    [recordButtonPressedContent writeToFile:fileName3
                 atomically:NO
                   encoding:NSUTF8StringEncoding
                      error: nil];
    
     //NSLog(@"error_url = %@", error_url);    
    
}

@end
