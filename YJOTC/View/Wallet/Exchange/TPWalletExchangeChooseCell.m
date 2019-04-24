

//
//  TPWalletExchangeChooseCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletExchangeChooseCell.h"

@implementation TPWalletExchangeChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#1E1F22");
    
    _title.font = PFRegularFont(16);
    _title.textColor = kLightGrayColor;
    
    _tf.font = PFRegularFont(24);
    _tf.textColor = kLightGrayColor;
    
    _lineView.backgroundColor = kColorFromStr(@"#44474F");
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
