//
//  MDLTableViewCell.h
//  MobileDataLogger
//
//  Created by Zhong Qi on 5/2/15.
//  Copyright (c) 2015 Zhong Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDLTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *MDL_icon;
@property (weak, nonatomic) IBOutlet UILabel *MDL_name;

@property (weak, nonatomic) IBOutlet UILabel *MDL_touch;

@property (weak, nonatomic) IBOutlet UILabel *MDL_key;

@property (weak, nonatomic) IBOutlet UILabel *MDL_url;

@property (weak, nonatomic) IBOutlet UILabel *MDL_time;

@end
