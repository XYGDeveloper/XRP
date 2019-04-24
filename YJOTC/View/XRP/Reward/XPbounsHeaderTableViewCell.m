//
//  XPbounsHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPbounsHeaderTableViewCell.h"

@implementation XPbounsHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.optionButton.layer.cornerRadius = 8;
    self.optionButton.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
