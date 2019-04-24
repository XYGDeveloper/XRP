//
//  XPZhuanZhangConfirmView.m
//  YJOTC
//
//  Created by Roy on 2018/12/19.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPZhuanZhangConfirmView.h"

@implementation XPZhuanZhangConfirmView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _title.textColor = k222222Color;
    _title.font = PFRegularFont(16);
    
    _volumeLabel.textColor = k222222Color;
    _volumeLabel.font = PFRegularFont(22);
    
    _account.textColor = k666666Color;
    _account.font = PFRegularFont(14);
    
    _accountLabel.textColor = k222222Color;
    _accountLabel.font = PFRegularFont(14);
    
    _payway.textColor = k666666Color;
    _payway.font = PFRegularFont(14);
    
    _paywayLabel.textColor = k222222Color;
    _paywayLabel.font = PFRegularFont(14);
    
    [_actionButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _actionButton.titleLabel.font = PFRegularFont(16);
        
    kViewBorderRadius(_actionButton, 8, 0, kRedColor);
    [_actionButton addShadow];
    _actionButton.backgroundColor = kColorFromStr(@"#6189C5");

    _title.text = kLocat(@"Z_confirmzz");
    _account.text = kLocat(@"Z_duifangzhanghao");
 
    _payway.text = kLocat(@"Z_payway");
    _paywayLabel.text = kLocat(@"Z_myasset");
    [_actionButton setTitle:kLocat(@"Z_directpay") forState:UIControlStateNormal];

    kViewBorderRadius(self.scaleButton, 8, 1, kColorFromStr(@"#6189C5"));
    [self.scaleButton addShadow];
    [self.scaleButton setTitle:kLocat(@"C_community_search_cash_pay_mingxi_scale") forState:UIControlStateNormal];
    
    [_closeButton addTarget:self action:@selector(hideAction:) forControlEvents:UIControlEventTouchUpInside];
    [_actionButton addTarget:self action:@selector(submitAcion:) forControlEvents:UIControlEventTouchUpInside];
    [_scaleButton addTarget:self action:@selector(scaleAcion:) forControlEvents:UIControlEventTouchUpInside];
    _scaleButton.hidden = YES;
}
-(void)hideAction:(UIButton *)button
{
    [button.superview.superview.superview removeFromSuperview];
}
-(void)submitAcion:(UIButton *)button
{
    self.callBackBlock(button);
}

-(void)scaleAcion:(UIButton *)button
{
    self.scaleBlocks(button);
}

@end
