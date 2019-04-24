//
//  TPOTCBuyListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyListCell.h"

@implementation TPOTCBuyListCell


-(void)setModel:(TPOTCOrderModel *)model
{
    _model = model;
    
    if (_isProfile) {
        _name.text = @"";
        if (model.name.length > 1) {
            _name.text = [model.name substringWithRange:NSMakeRange(0, 1)];
        } else {
            _name.text = @"";
        }
        _nameLabel.text = model.name;
        _infoLabel.text = @"";
        
    }else{
      
        if (model.name.length == 0) {
            _name.text = @"";
        }else{
            _name.text = [model.name substringWithRange:NSMakeRange(0, 1)];
        }
        _nameLabel.text = model.name;
        
        _infoLabel.text = [NSString stringWithFormat:@"%@ %@丨%@ %@%%",kLocat(@"Deal"),model.trade_allnum,kLocat(@"OTC_view_dealrate"),model.evaluate_num];
    }

    
    
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ CNY",model.price];
    
    _limitLabel.text = [NSString stringWithFormat:@"%@ %@-%@ CNY",kLocat(@"OTC_view_limtesum"),model.min_money,model.max_money];
    _volumeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",kLocat(@"k_HBTradeJLViewController_count"),model.avail,model.currencyName];
    
    if (model.money_type.count == 3) {
        _way1.hidden = NO;
        _way2.hidden = NO;
        _way3.hidden = NO;
        _way1.image = kImageFromStr(@"gmxq_icon_yhk");
        _way2.image = kImageFromStr(@"gmxq_icon_zfb");
        _way3.image = kImageFromStr(@"gmxq_icon_wx");
    }else if (model.money_type.count == 2){
        _way1.hidden = YES;
        _way2.hidden = NO;
        _way3.hidden = NO;
        if (![model.money_type containsObject:kZFB]) {
            _way2.image = kImageFromStr(@"gmxq_icon_yhk");
            _way3.image = kImageFromStr(@"gmxq_icon_wx");
        }else if (![model.money_type containsObject:kWechat]){
            _way2.image = kImageFromStr(@"gmxq_icon_yhk");
            _way3.image = kImageFromStr(@"gmxq_icon_zfb");
        }else{
            _way2.image = kImageFromStr(@"gmxq_icon_zfb");
            _way3.image = kImageFromStr(@"gmxq_icon_wx");
        }
    }else{
        _way1.hidden = YES;
        _way2.hidden = YES;
        _way3.hidden = NO;
        if ([model.money_type containsObject:kZFB]) {
            _way3.image = kImageFromStr(@"gmxq_icon_zfb");
        }else if ([model.money_type containsObject:kWechat]){
            _way3.image = kImageFromStr(@"gmxq_icon_wx");
        }else{
            _way3.image = kImageFromStr(@"gmxq_icon_yhk");
        }
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
//    kViewBorderRadius(_bgView, 8, 0, kRedColor);
//    [_bgView addShadow];
    
    _name.textColor = kWhiteColor;
    _nameLabel.textColor = k222222Color;
    _infoLabel.textColor = k666666Color;
    _priceLabel.textColor = _nameLabel.textColor;
    _limitLabel.textColor = _infoLabel.textColor;
    _volumeLabel.textColor = _infoLabel.textColor;
    
    _name.font = PFRegularFont(14);
    _nameLabel.font = PFRegularFont(16);
    _infoLabel.font = PFRegularFont(12);
    _priceLabel.font = PFRegularFont(18);
    _limitLabel.font = PFRegularFont(12);
    _volumeLabel.font = PFRegularFont(12);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
