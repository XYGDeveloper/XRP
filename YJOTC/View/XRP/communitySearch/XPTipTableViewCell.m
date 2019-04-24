//
//  XPTipTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/29.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPTipTableViewCell.h"

@implementation XPTipTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
