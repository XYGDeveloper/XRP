//
//  TPOTCBuyDetaiHeadView.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyDetaiHeadView.h"





@implementation TPOTCBuyDetaiHeadView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = kTableColor;
    
    _currencyNameLabel.textColor = k222222Color;
    _currencyNameLabel.font = PFRegularFont(18);
    
    _statusLabel.textColor = kColorFromStr(@"#EA6E44");
    _statusLabel.font = PFRegularFont(14);
    
    _tipsLabel.textColor = k666666Color;
    _tipsLabel.font = PFRegularFont(12);
    
    _leftTimeLabel.textColor = k999999Color;
    _leftTimeLabel.font = PFRegularFont(12);
    
    
    _tipsLabel.text = kLocat(@"OTC_view_havecashdeposit");
    _statusLabel.text = kLocat(@"OTC_notPay");
    
    
}

@end
