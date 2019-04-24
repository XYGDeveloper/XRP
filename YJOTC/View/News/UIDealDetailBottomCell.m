//
//  UIDealDetailBottomCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UIDealDetailBottomCell.h"

@implementation UIDealDetailBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
    _itemLabel.textColor = k222222Color;
    _itemLabel.font = PFRegularFont(14);
    _valueLabel.textColor = k666666Color;
    _valueLabel.font = PFRegularFont(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
