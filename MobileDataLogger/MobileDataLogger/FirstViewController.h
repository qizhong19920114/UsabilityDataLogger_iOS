//
//  FirstViewController.h
//  MobileDataLogger
//
//  Created by Zhong Qi on 4/11/15.
//  Copyright (c) 2015 Zhong Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;
@property (weak, nonatomic) IBOutlet UIButton *exportButton;

- (IBAction)buttonPress;

- (IBAction)recordButtonPress;

@end

