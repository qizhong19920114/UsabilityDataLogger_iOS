//
//  ThirdViewController.h
//  MobileDataLogger
//
//  Created by Zhong Qi on 4/11/15.
//  Copyright (c) 2015 Zhong Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *keyboardSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *urlvisitSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *touchlocSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *appruntimeSwitch;
@property (weak, nonatomic) IBOutlet UIButton *clearDataButton;
- (IBAction)clearAllDataPressed;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

