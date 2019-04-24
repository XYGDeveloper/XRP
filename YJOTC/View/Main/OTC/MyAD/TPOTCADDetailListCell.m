
//
//  TPOTCADDetailListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCADDetailListCell.h"

@implementation TPOTCADDetailListCell


-(void)setModel:(TPOTCSingleOrderModel *)model
{
    _model = model;
    
    if (model.name.length > 1) {
        _name.text = [model.name substringWithRange:NSMakeRange(0, 1)];
    } else {
        _name.text = @"";
    }
    _nameLabel.text = model.name;
    
    _timeLabel.text = model.add_time;
    
    if ([_model.type isEqualToString:@"buy"]) {
        _currencyName.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"s_buy_uppper"),model.currency_name];
    }else{
        _currencyName.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"s_sell_lower"),model.currency_name];
    }
    
    _statusLabel.text = model.status_txt;
    
    _cnyLabel.text = [NSString stringWithFormat:@"%@ CNY",model.money];
    
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
    self.lineView.backgroundColor = kCCCCCCColor;

    
    self.name.textColor = kWhiteColor;
    self.name.font = PFRegularFont(16);
    
    self.nameLabel.textColor = k222222Color;
    self.nameLabel.font = PFRegularFont(16);
    
    self.timeLabel.textColor = k999999Color;
    self.timeLabel.font = PFRegularFont(12);
    
    self.currencyName.textColor = k666666Color;
    self.currencyName.font = PFRegularFont(12);
    
    self.cnyLabel.textColor = k222222Color;
    self.cnyLabel.font = PFRegularFont(18);
    
    self.statusLabel.textColor = k666666Color;
    self.statusLabel.textColor = kRiseColor;

    self.statusLabel.font = PFRegularFont(15);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
