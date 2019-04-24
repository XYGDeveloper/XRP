//
//  TPOTCADDoneTopCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCADDoneTopCell.h"

@implementation TPOTCADDoneTopCell

-(void)setModel:(TPOTCMyADModel *)model
{
    _model = model;
    
    if ([_model.type isEqualToString:@"buy"]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"s_buy_uppper"),model.currencyName];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"s_sell_lower"),model.currencyName];
    }
    
    _adNumLabel.text = [NSString stringWithFormat:@"%@：%@",kLocat(@"OTC_view_adnumber"),model.orders_id];
    //这个改了 0是挂单，1是部分成交, 2成交 3撤销
    if (model.status.intValue == 3) {
        _typeLabel.text = kLocat(@"OTC_view_selfcancel");
    }else if (model.status.intValue == 2){
        _typeLabel.text = kLocat(@"OTC_view_sellover");
    }
    if (model.status.intValue == 3 || model.status.intValue == 2) {
        _statusLabel.text = kLocat(@"OTC_order_done");
    }
    _timeLabel.text = model.add_time;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
    
    self.nameLabel.textColor = k222222Color;
    self.nameLabel.font= PFRegularFont(14);
    
    self.timeLabel.textColor = k999999Color;
    self.timeLabel.font= PFRegularFont(12);
    
    self.adNumLabel.textColor = k222222Color;
    self.adNumLabel.font= PFRegularFont(13);
    
    self.typeLabel.textColor = kColorFromStr(@"#6189C5");
    self.typeLabel.font= PFRegularFont(12);
    
    self.statusLabel.textColor = kColorFromStr(@"#F5860E");
    self.statusLabel.font= PFRegularFont(13);
    
    self.lineView.backgroundColor = kCCCCCCColor;
    
    self.leftMargin.constant = 210 * kScreenWidthRatio;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
