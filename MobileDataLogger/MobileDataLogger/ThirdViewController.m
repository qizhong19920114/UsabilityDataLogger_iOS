//
//  SecondViewController.m
//  MobileDataLogger
//
//  Created by Zhong Qi on 4/11/15.
//  Copyright (c) 2015 Zhong Qi. All rights reserved.


// /var/mobile/Containers/Data/Application/2BB5F100-AD87-4639-97DD-384675CEAA53/Documents/slide_key.txt
//

#import "ThirdViewController.h"

static int key_selected;

static int url_selected;

static int touch_selected;

static int runtime_selected;

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)slide_key:(id)sender {
    
    if([sender isOn]){
        NSLog(@"slide_key is ON");
        key_selected = 1;
        
    } else{
        NSLog(@"slide_key is OFF");
        key_selected = 0; 
        
    }
}

- (IBAction)slide_url:(id)sender {
    
    if([sender isOn]){
        NSLog(@"slide_url is ON");
        url_selected = 1;
       
    } else{
        NSLog(@"slide_url is OFF");
        url_selected = 0;
        
    }
}

- (IBAction)slide_touch:(id)sender {
  
    if([sender isOn]){
        NSLog(@"slide_touch is ON");
        touch_selected = 1;
        
    } else{
        NSLog(@"slide_touch is OFF");
        touch_selected = 0;
        
    }
}


- (IBAction)slide_run:(id)sender {
    
    if([sender isOn]){
        NSLog(@"slide_run is ON");
        runtime_selected = 1;
        
    } else{
        NSLog(@"slide_run is OFF");
        runtime_selected = 0;
        
    }
}


- (IBAction)saveSettings:(id)sender {
    
    NSError * error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if (!key_selected)
    {
        //make a file name to write the data to using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/slide_key.txt", documentsDirectory];
        
        NSLog(@"%@", fileName);
        
        //create content - four lines of text
        NSString *content = @"slide_key";
        //save content to the documents directory
        
        BOOL success = [content writeToFile:fileName
                                 atomically:NO
                                   encoding:NSUTF8StringEncoding
                                      error:&error];
        
        NSLog(@"Success = %d, error = %@", success, error);
    }
    else
    {
        NSString *fileName = [NSString stringWithFormat:@"%@/slide_key.txt",
                              documentsDirectory];
        NSLog(@"%@", fileName);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
        
        if (fileExists)
        {
        
            BOOL success = [fileManager removeItemAtPath:fileName error:&error];
        
            NSLog(@"remove Success = %d, error = %@", success, error);
        }
    }
    
    if (!url_selected)
    {
        //make a file name to write the data to using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/slide_url.txt",
                              documentsDirectory];
        NSLog(@"%@", fileName);
        
        //create content - four lines of text
        NSString *content = @"slide_url";
        //save content to the documents directory
        
        BOOL success = [content writeToFile:fileName
                                 atomically:NO
                                   encoding:NSUTF8StringEncoding
                                      error:&error];
        
        NSLog(@"Success = %d, error = %@", success, error);
    }
    else
    {
        NSString *fileName = [NSString stringWithFormat:@"%@/slide_url.txt",
                              documentsDirectory];
        NSLog(@"%@", fileName);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
        
        if (fileExists)
        {
            BOOL success = [fileManager removeItemAtPath:fileName error:&error];
        
            NSLog(@"remove Success = %d, error = %@", success, error);
        }
    }
    
    if (!touch_selected)
    {
        //make a file name to write the data to using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/slide_touch.txt",
                              documentsDirectory];
        NSLog(@"%@", fileName);
        
        //create content - four lines of text
        NSString *content = @"slide_touch";
        //save content to the documents directory
        
        BOOL success = [content writeToFile:fileName
                                 atomically:NO
                                   encoding:NSUTF8StringEncoding
                                      error:&error];
        
        NSLog(@"Success = %d, error = %@", success, error);
    }
    else
    {
        NSString *fileName = [NSString stringWithFormat:@"%@/slide_touch.txt",
                              documentsDirectory];
        NSLog(@"%@", fileName);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
        
        if (fileExists)
        {
            BOOL success = [fileManager removeItemAtPath:fileName error:&error];
        
            NSLog(@"remove Success = %d, error = %@", success, error);
        }
    }
    
    if (!runtime_selected)
    {
        //make a file name to write the data to using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/slide_run.txt",
                              documentsDirectory];
        NSLog(@"%@", fileName);
        
        //create content - four lines of text
        NSString *content = @"slide_run";
        //save content to the documents directory
        
        BOOL success = [content writeToFile:fileName
                                 atomically:NO
                                   encoding:NSUTF8StringEncoding
                                      error:&error];
        
        NSLog(@"Success = %d, error = %@", success, error);
    }
    else
    {
        NSString *fileName = [NSString stringWithFormat:@"%@/slide_run.txt",
                              documentsDirectory];
        NSLog(@"%@", fileName);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
        
        if (fileExists)
        {
            BOOL success = [fileManager removeItemAtPath:fileName error:&error];
        
            NSLog(@"remove Success = %d, error = %@", success, error);
        }
    }
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
}
@end












