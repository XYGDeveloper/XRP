//
//  TPResetPWDCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/6.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPResetPWDCell.h"

@implementation TPResetPWDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#1E1F22");
    
    _tf.textColor = kColorFromStr(@"#CDD2E3");
    _tf.font = PFRegularFont(14);
    
    _codeButton.titleLabel.font = PFRegularFont(14);
    [_codeButton setTitleColor:kColorFromStr(@"#1DA3C5") forState:UIControlStateNormal];
    
    _codeButton.hidden = YES;
    
    [_codeButton setTitle:@"獲取驗證碼" forState:UIControlStateNormal];
    _line1.backgroundColor = kColorFromStr(@"#111419");
    _line2.backgroundColor = kColorFromStr(@"#3B3B3B");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
