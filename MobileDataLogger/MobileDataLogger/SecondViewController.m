//
//  SecondViewController.m
//  MobileDataLogger
//
//  Created by Zhong Qi on 4/11/15.
//  Copyright (c) 2015 Zhong Qi. All rights reserved.
//

#import "SecondViewController.h"
#import "MDLTableViewCell.h"
#import "DBManager.h"



@interface SecondViewController ()

- (NSString *)calculateRunTime:(NSString *)starttime forend: (NSString *)endtime;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation SecondViewController
{
    NSArray *tableData;// TOUCH
    NSArray *tableData1;// NAME
    NSArray *tableData2;// KEYSTROKE
    NSArray *tableData3;// ENDTIME
    //NSArray *readTableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadDataMDL];
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"History.db"];
    
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Initialize the refresh control.
    self.refreshControl.backgroundColor = [UIColor blueColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadDataMDL)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableViewObject addSubview:self.refreshControl]; //assumes tableView is @property
    
}

- (void )reloadDataMDL
{
    //write a file for touchCount
    NSError * error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName2 = [NSString stringWithFormat:@"%@/touchCount",
                           documentsDirectory];
    
    // read everything from text
    NSString* fileContents =
    [NSString stringWithContentsOfFile:fileName2
                              encoding:NSUTF8StringEncoding error:&error];
    // separate by new line
    tableData =
    [fileContents componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    //FOR APPNAME
    NSString *fileName_APPNM = [NSString stringWithFormat:@"%@/appName",
                                documentsDirectory];
    
    NSString* fileContents_APPNM =
    [NSString stringWithContentsOfFile:fileName_APPNM
                              encoding:NSUTF8StringEncoding error:&error];
    tableData1 =
    [fileContents_APPNM componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    //FOR KEYSTROKE
    NSString *fileName_KEYST= [NSString stringWithFormat:@"%@/keyStoke",
                               documentsDirectory];
    
    NSString* fileContents_KEYST =
    [NSString stringWithContentsOfFile:fileName_KEYST
                              encoding:NSUTF8StringEncoding error:&error];
    
    tableData2 = [fileContents_KEYST componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    //FOR ENDTIME
    NSString *fileName_ENDTIME= [NSString stringWithFormat:@"%@/endTime",
                               documentsDirectory];
    
    NSString* fileContents_ENDTIME =
    [NSString stringWithContentsOfFile:fileName_ENDTIME
                              encoding:NSUTF8StringEncoding error:&error];
    
    tableData3 = [fileContents_ENDTIME componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    
    
    
    //TO REFRESH THE DATA
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)reloadData
{
    // Reload table data
    [self.tableViewObject reloadData];
    
    
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"MMM d, h:mm a"];
        
        NSString *title = [NSString stringWithFormat:@"Drag to 1/4 of the screen and hold for half second to update"];
        
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        
        self.refreshControl.attributedTitle = attributedTitle;
        
        
        
        [self.refreshControl endRefreshing];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(([tableData1 count] == [tableData count]) && ([tableData1 count] == [tableData2 count]) && ([tableData1 count] == [tableData3 count]) )
    {
        if([tableData1 count] == 0)
            [self.statusTestField setText:@"Status: No data available!"];
        else
            [self.statusTestField setText:@"Status: Successfully load data!!!"];
        
        return [tableData1 count] - 1; // change the number of rows here
    }
    else
    {
        NSLog(@"Data Error!!! Please Restart the tester!");
        [self.statusTestField setText:@"* means improper operation occured and there could data missing"];
        //return 0; // change the number of rows here
        
        int smallestCNT=[tableData count];
        
        if(smallestCNT > [tableData1 count])
        {
            smallestCNT=[tableData1 count];
        }
        
        if(smallestCNT > [tableData2 count])
        {
            smallestCNT = [tableData2 count];
        }
        
        if(smallestCNT > [tableData3 count])
        {
            smallestCNT = [tableData3 count];
        }
        
        
        
        
        return smallestCNT - 1; // still return with data even there is data mismatch
                                                                                                        // get the lowest number of 4 table list count by using dividing
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //this is a incomplete list of app Names stored in dictionary...
    NSArray *keys = [NSArray arrayWithObjects:@" Notes", @" Reminders",@" FaceTime",@" Calendar",@" Photos",@" Camera",@" Contacts",@" Clock",@" Maps",@" Video",@" Photo Booth",@" Game Center",@" Newsstand",@" iTunes Store",@" AppStore",@" iBooks",@" Messages",@" Mail",@" Safari",@" Music",@" YouTube",@" Dropbox", @" netdisk_iPad", nil];
    
    NSArray *objs = [NSArray arrayWithObjects:@"Notes.png", @"Reminders.png",@"FaceTime.png",@"Calendar.png",@"Photos.png",@"Camera.png",@"Contacts.png",@"Clock.png",@"Maps.png",@"Videos.png",@"Photo_booth.png",@"Game_Center.png",@"Newsstand.png",@"Itumes_Store.png",@"App_Store.png",@"iBook.png",@"Messages.png",@"Mail.png",@"Safari.png",@"Music.png", @"Youtube.png", @"Dropbox.png", @"netdisk_baidu.png", nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
    
    NSString *query = @"select * from history_visits";
    
    NSArray *url_db = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // then obtain the last item of url_db, and use "|" as delimiter and then get the first item which is the id
    //  of the last item which is also the number of url visit...
    //NSString *url_total_visit = [[[url_db objectAtIndex: [url_db count]-1] componentsSeparatedByString:@"|"] objectAtIndex:0];
    
    //NSLog(@"url total visit:%d", [url_db count]);
    
    //NSLog(@"Count is: %d", [url_db count]);

    MDLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //cell.backgroundColor = indexPath.row % 2
   // ? [UIColor colorWithRed: 160.0 green: 160.0 blue: 160.0 alpha: 1.0]
   // : [UIColor whiteColor];

    NSString* name = [[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@":"] objectAtIndex:[[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@":"] count]-1];
    
    
    NSString* name_without_space = [[name componentsSeparatedByString:@" "]objectAtIndex:1];
    
    
    NSString* nameLink = [NSString stringWithFormat:@"http://hejibo.info/files/usabilityDataLoggerIcons/%@.png",name_without_space];
    
    
    
    if([UIImage imageNamed: [dict objectForKey:name]] == nil)
    {
        //cell.MDL_icon.image = [UIImage imageNamed:@"ios_icon_generic.png"];
        
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: nameLink]];
        
        if(imageData == nil)
        {
            cell.MDL_icon.image = [UIImage imageNamed:@"ios_icon_generic.png"];
        }
        else
        {
            cell.MDL_icon.image = [UIImage imageWithData: imageData];
        }
    }
    else
    {
        cell.MDL_icon.image= [UIImage imageNamed: [dict objectForKey:name]];
    }
    //NSLog(@"Pass Icon!!");
    
    //the following logic is for app with long names.
//    NSString * complete_NAME = [[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@" "] objectAtIndex: 6];
//    int index_count = 7;
//    if (index_count < [[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@" "] count])
//    {
//        complete_NAME = [complete_NAME stringByAppendingString: [[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@" "] objectAtIndex: index_count]];
//        index_count ++;
//    }
//    index_count = 0;
    
    //NAME
    //May 14 21:35:29 DrHede-iPad MobileNotes[11087]: MDL1: Notes
    
//  cell.MDL_name.text = complete_NAME;
    
   
    

    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileTouchDisable = [NSString stringWithFormat:@"%@/slide_touch.txt",
                                  documentsDirectory];
    NSString *fileRunDisable = [NSString stringWithFormat:@"%@/slide_run.txt",
                                documentsDirectory];
    NSString *fileKeystrokeDisable = [NSString stringWithFormat:@"%@/slide_key.txt",
                                      documentsDirectory];
    NSString *fileURLDisable = [NSString stringWithFormat:@"%@/slide_url.txt",
                                documentsDirectory];
    
    
    
    
    NSString* start_Time;
    NSString* end_Time;
    //RUNTIME
    if ([[[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@" "] objectAtIndex:1] isEqualToString:@""])
    {
        start_Time = [[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@" "] objectAtIndex:3];
        
    }
    else
    {
        start_Time = [[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@" "] objectAtIndex:2];
    }
    
     NSLog(@"start_Time:%@",start_Time);
    
    int row_shifter = 0;
    do // use a while loop to shift index when endTime - startTime is negative.
    {
        if ([[[[tableData3 objectAtIndex:(indexPath.row+row_shifter)] componentsSeparatedByString:@" "] objectAtIndex:1] isEqualToString:@""])
        {
            end_Time = [[[tableData3 objectAtIndex:(indexPath.row+row_shifter)] componentsSeparatedByString:@" "] objectAtIndex:3];
            NSLog(@"EndTime:%@",end_Time);
        }
        else
        {
            end_Time = [[[tableData3 objectAtIndex:(indexPath.row+row_shifter)] componentsSeparatedByString:@" "] objectAtIndex:2];
        }
        
        if ([self calculateRunTime_int:start_Time forend:end_Time] < 0)
        {
            row_shifter = row_shifter+ 1;
            NSLog(@"Row Shifter: %i", row_shifter);
        }
        
        
    
    }while([self calculateRunTime_int:start_Time forend:end_Time] < 0 );
    
    
    // add a start to the app name when row shifter is used.
    if (row_shifter == 0)
    {
        cell.MDL_name.text = [[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@":"] objectAtIndex:[[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@":"] count]-1];
    }
    else
    {
        cell.MDL_name.text = [[[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@":"] objectAtIndex:[[[tableData1 objectAtIndex:indexPath.row] componentsSeparatedByString:@":"] count]-1] stringByAppendingString:@"*"];
    }
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:fileRunDisable])
    {
        cell.MDL_time.text = @"X";
    }
    else
    {
        
        NSLog(@"startTime: %@",start_Time);
        NSLog(@"endTime: %@",end_Time);

        cell.MDL_time.text = [self calculateRunTime:start_Time forend:end_Time];

        
    }
    
    
    //Add the lines below because in the tweak, keystroke doesn't increase touchcnt, so i need to manually sum them up here
    NSString *touchcnt_str = [[[tableData objectAtIndex:(indexPath.row+row_shifter)] componentsSeparatedByString:@":"] objectAtIndex:[[[tableData objectAtIndex:(indexPath.row+row_shifter)] componentsSeparatedByString:@":"] count]-1];
    
    NSInteger touchcnt_int = [touchcnt_str integerValue];
    
    NSString *keystroke_str = [[[tableData2 objectAtIndex:(indexPath.row+row_shifter)] componentsSeparatedByString:@":"] objectAtIndex:[[[tableData2 objectAtIndex:(indexPath.row+row_shifter)] componentsSeparatedByString:@":"] count]-1];
    
    NSInteger keystroke_int = [keystroke_str integerValue];
    
    NSInteger total_touchcnt_int = keystroke_int + touchcnt_int;
    
    NSString* total_touchcnt_str = [NSString stringWithFormat:@"%i", total_touchcnt_int];
    
    //TOUCH
    if([[NSFileManager defaultManager] fileExistsAtPath:fileTouchDisable])
    {
        cell.MDL_touch.text = @"X";
    }
    else
    {

        cell.MDL_touch.text = total_touchcnt_str;

    }
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:fileKeystrokeDisable])
    {
        cell.MDL_key.text = @"X";
    }
    else
    {
        cell.MDL_key.text = [[[tableData2 objectAtIndex:(indexPath.row+row_shifter)] componentsSeparatedByString:@":"] objectAtIndex:[[[tableData2 objectAtIndex:(indexPath.row+row_shifter)] componentsSeparatedByString:@":"] count]-1];
    }
    
    NSString *url_visit_str;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:fileURLDisable])
    {
        cell.MDL_url.text = @"X";
    }
    else if ([cell.MDL_name.text isEqualToString:@" Safari"])
    {
        
        url_visit_str = [NSString stringWithFormat:@"%d",[url_db count]];
       
        cell.MDL_url.text = url_visit_str;
    }
    else
    {
        cell.MDL_url.text = @" NotApply";
    }
    
    return cell;
}


- (NSString *)calculateRunTime:(NSString *)starttime forend: (NSString *)endtime{
    
    int start_min = [[[starttime componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
    
    int start_sec = [[[starttime componentsSeparatedByString:@":"] objectAtIndex:2] intValue];
    
    int end_min = [[[endtime componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
    
    int end_sec = [[[endtime componentsSeparatedByString:@":"] objectAtIndex:2] intValue];
    
    int totaltime = 0;
    
    if (end_min >= start_min)
    {
        totaltime = (end_min*60 + end_sec) - (start_min*60 + start_sec);
    }
    else
    {
        totaltime = ((end_min+60)*60 + end_sec) - (start_min*60 + start_sec);
    }
    
    NSString *totoalRuntime = [NSString stringWithFormat:@"%d sec",totaltime];
   
    return totoalRuntime;
}

- (int)calculateRunTime_int:(NSString *)starttime forend: (NSString *)endtime{
    
    int start_min = [[[starttime componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
    
    int start_sec = [[[starttime componentsSeparatedByString:@":"] objectAtIndex:2] intValue];
    
    int end_min = [[[endtime componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
    
    int end_sec = [[[endtime componentsSeparatedByString:@":"] objectAtIndex:2] intValue];
    
    int totaltime = 0;
    
    if (end_min >= start_min)
    {
        totaltime = (end_min*60 + end_sec) - (start_min*60 + start_sec);
    }
    else
    {
        totaltime = ((end_min+60)*60 + end_sec) - (start_min*60 + start_sec);
    }
    
    return totaltime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearAllDataPressed {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *directory = [NSString stringWithFormat:@"%@/",  documentsDirectory];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:directory error:nil];
    for (NSString *filename in fileArray)
    {
        if(![filename isEqualToString:@"slide_run.txt"]&& ![filename isEqualToString:@"slide_touch.txt"]&& ![filename isEqualToString:@"slide_url.txt"] && ![filename isEqualToString:@"slide_key.txt"] )
        {
            [fileMgr removeItemAtPath:[directory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    
    
    //Create a clear Data indicator so that tweak can check it to see if syslogd needs to be reset.
    NSString *fileName = [NSString stringWithFormat:@"%@/clearData.txt",
                          documentsDirectory];
    NSLog(@"%@", fileName);
    NSError * error = nil;
    //create content - four lines of text
    NSString *content = @"clearData";
    //save content to the documents directory
    
    BOOL success = [content writeToFile:fileName
                             atomically:NO
                               encoding:NSUTF8StringEncoding
                                  error:&error];
    
    NSLog(@"Success = %d, error = %@", success, error);
    
    
    
    
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
        //NSString *currentTime = [[[dataList_runtime objectAtIndex:i] componentsSeparatedByString:@" "] objectAtIndex:2];
        
        NSString *currentTime = [[[dataList_runtime objectAtIndex:i] componentsSeparatedByString:@":"] objectAtIndex:0];
        currentTime = [currentTime stringByAppendingString:@":"];
        currentTime = [currentTime stringByAppendingString:[[[dataList_runtime objectAtIndex:i] componentsSeparatedByString:@":"] objectAtIndex:1]];
        currentTime = [currentTime stringByAppendingString:@":"];
        currentTime = [currentTime stringByAppendingString:[[[[[dataList_runtime objectAtIndex:i] componentsSeparatedByString:@":"] objectAtIndex:2]componentsSeparatedByString:@" "] objectAtIndex:0]];
        
        
        
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
        //NSString *currentTime = [[[dataList_touch objectAtIndex:j] componentsSeparatedByString:@" "] objectAtIndex:2];
        
        NSString *currentTime = [[[dataList_touch objectAtIndex:j] componentsSeparatedByString:@":"] objectAtIndex:0];
        currentTime = [currentTime stringByAppendingString:@":"];
        currentTime = [currentTime stringByAppendingString:[[[dataList_touch objectAtIndex:j] componentsSeparatedByString:@":"] objectAtIndex:1]];
        currentTime = [currentTime stringByAppendingString:@":"];
        currentTime = [currentTime stringByAppendingString:[[[[[dataList_touch objectAtIndex:j] componentsSeparatedByString:@":"] objectAtIndex:2]componentsSeparatedByString:@" "] objectAtIndex:0]];
        
        
        
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
        NSString *currentTime = [[[dataList_keystroke objectAtIndex:k] componentsSeparatedByString:@":"] objectAtIndex:0];
        currentTime = [currentTime stringByAppendingString:@":"];
        currentTime = [currentTime stringByAppendingString:[[[dataList_keystroke objectAtIndex:k] componentsSeparatedByString:@":"] objectAtIndex:1]];
        currentTime = [currentTime stringByAppendingString:@":"];
        currentTime = [currentTime stringByAppendingString:[[[[[dataList_keystroke objectAtIndex:k] componentsSeparatedByString:@":"] objectAtIndex:2]componentsSeparatedByString:@" "] objectAtIndex:0]];
        
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
