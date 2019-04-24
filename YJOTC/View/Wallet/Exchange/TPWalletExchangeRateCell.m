//
//  TPWalletExchangeRateCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletExchangeRateCell.h"

@implementation TPWalletExchangeRateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    
    _title.textColor = kLightGrayColor;
    _title.font = PFRegularFont(16);
    
    _exchangeInfoLabel.textColor = kLightGrayColor;
    _exchangeInfoLabel.font = PFRegularFont(12);
    
    _leftNameLabel.font = PFRegularFont(16);
    _leftPriceLabel.font = PFRegularFont(12);
    _rightNameLabel.font = PFRegularFont(16);
    _rightPriceLabel.font = PFRegularFont(12);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
