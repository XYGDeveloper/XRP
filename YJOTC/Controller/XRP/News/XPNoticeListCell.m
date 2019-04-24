//
//  XPNoticeListCell.m
//  YJOTC
//
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPNoticeListCell.h"

@implementation XPNoticeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    [_bgView addShadow];
    
    
    _timeLabel.textColor = k999999Color;
    _timeLabel.font = PFRegularFont(10);
    _titleLabel.textColor = k666666Color;
    _titleLabel.font = PFRegularFont(12);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
