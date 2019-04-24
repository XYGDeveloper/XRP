//
//  TPOTCPayWayAddTFCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPayWayAddTFCell.h"

@implementation TPOTCPayWayAddTFCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
    
    _lineView.backgroundColor = kCCCCCCColor;
    
    _tf.placeholder = @"00";
    kTextFieldPlaceHoldColor(_tf, k999999Color);
    
    _tf.font = PFRegularFont(16);
    _tf.textColor = k222222Color;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
