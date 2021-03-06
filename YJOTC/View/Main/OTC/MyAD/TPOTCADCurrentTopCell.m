
//
//  TPOTCADCurrentTopCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCADCurrentTopCell.h"

@implementation TPOTCADCurrentTopCell


-(void)setModel:(TPOTCMyADModel *)model
{
    _model = model;
    _statusLabel.text = kLocat(@"OTC_view_dealing");
    if ([_model.type isEqualToString:@"buy"]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"s_buy_uppper"),model.currencyName];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"s_sell_lower"),model.currencyName];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lftMargin.constant = 245 * kScreenWidthRatio;
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
    
    self.lienView.backgroundColor = kCCCCCCColor;

    self.nameLabel.textColor = k222222Color;
    self.nameLabel.font= PFRegularFont(14);
    
    self.statusLabel.textColor = kColorFromStr(@"#03C086");
    self.statusLabel.font = PFRegularFont(14);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
