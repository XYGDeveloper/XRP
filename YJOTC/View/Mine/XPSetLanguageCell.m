
//
//  XPSetLanguageCell.m
//  YJOTC
//
//  Created by Roy on 2018/12/19.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPSetLanguageCell.h"

@implementation XPSetLanguageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = kTableColor;
    self.selectionStyle = 0;
    _currentLabel.textColor = k222222Color;
    _currentLabel.font = PFRegularFont(16);
    
    _descLabel.textColor = k666666Color;
    _descLabel.font = PFRegularFont(12);
    
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
//    _bgView.backgroundColor = kRedColor;
    [_bgView addShadow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
