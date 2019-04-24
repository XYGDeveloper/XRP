//
//  XPCashTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCashTableViewCell.h"

@implementation XPCashTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgView, 8, 0, kRedColor);
    [self.bgView addShadow];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
