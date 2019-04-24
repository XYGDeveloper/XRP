//
//  TPWalletExchangeInputCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletExchangeInputCell.h"

@implementation TPWalletExchangeInputCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#1E1F22");

    _title.font = PFRegularFont(16);
    _title.textColor = kLightGrayColor;
    _tf.font = PFRegularFont(18);
    _tf.textColor = kLightGrayColor;
    
    _line.backgroundColor = kColorFromStr(@"44474F");
    
    _avaLabel.textColor = kLightGrayColor;
    _avaLabel.font = PFRegularFont(12);
    
    
    _tf.placeholder = @"0.000000";
    kTextFieldPlaceHoldColor(_tf, kColorFromStr(@"#707589"));
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
