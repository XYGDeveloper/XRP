//
//  TPCurrencyPanKouCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/18.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPCurrencyPanKouCell.h"

@interface TPCurrencyPanKouCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation TPCurrencyPanKouCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = kWhiteColor;
    self.selectionStyle = 0;
    
    _buyLabel.font = PFRegularFont(12);
    _sellLabel.font = PFRegularFont(12);
    _priceLabel.font = PFRegularFont(12);
    _buyVolumeLabel.font = PFRegularFont(12);
    _sellVolumeLabel.font = PFRegularFont(12);

    _sellPriceLabel.font = PFRegularFont(12);
    _buyPriceLabel.font = PFRegularFont(12);
    _buyPriceLabel.textColor = kColorFromStr(@"#03C086");
    _sellPriceLabel.textColor = kColorFromStr(@"#EA6E44");

    _leftMargin.constant = kScreenW/2.0+5;
    _rightMargin.constant = kScreenW/2.0+5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
