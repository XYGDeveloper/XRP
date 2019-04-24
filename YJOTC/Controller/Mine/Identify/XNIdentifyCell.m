//
//  XNIdentifyCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/6/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "XNIdentifyCell.h"

@implementation XNIdentifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _tf.textColor = k222222Color;
    _tf.font = PFRegularFont(12);
    
    _tf.backgroundColor = kColorFromStr(@"f4f7fe");
    kViewBorderRadius(_tf, 2, 0.5, kColorFromStr(@"e6eaf3"));

    _tf.placeholder = @"中国";
    
    _tf.leftView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 8, 20)];
    _tf.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
