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



@end
