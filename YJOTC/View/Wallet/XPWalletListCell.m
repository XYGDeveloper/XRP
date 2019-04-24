//
//  XPWalletListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPWalletListCell.h"


@implementation XPWalletListCell

-(void)setModel:(TPWalletCurrencyModel *)model
{
    _model = model;
    [_icon setImageWithURL:model.currency_logo.ks_URL placeholder:nil];
    _nameLabel.text = model.currency_mark;
    _cnyLabel.text = [NSString stringWithFormat:@"≈%@%@",model.nw_price_unit,model.cny];
    _volumeLabel.text = model.money;
    
    //    _cnyLabel.text = [NSString stringChangeMoneyWithStr:model.cny numberStyle:NSNumberFormatterDecimalStyle];
    //    _cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_cnyLabel.text];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
    
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    [_bgView addShadow];
    
    self.nameLabel.textColor = k222222Color;
    self.volumeLabel.textColor = k666666Color;
    self.cnyLabel.textColor = kColorFromStr(@"#EA6E44");
    
    self.nameLabel.font = PFRegularFont(18);
    self.volumeLabel.font = PFRegularFont(16);
    self.cnyLabel.font = PFRegularFont(12);
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
