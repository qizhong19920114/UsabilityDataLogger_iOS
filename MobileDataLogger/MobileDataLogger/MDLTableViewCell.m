//
//  MDLTableViewCell.m
//  MobileDataLogger
//
//  Created by Zhong Qi on 5/2/15.
//  Copyright (c) 2015 Zhong Qi. All rights reserved.
//

#import "MDLTableViewCell.h"

@implementation MDLTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
