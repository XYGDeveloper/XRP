//
//  ConfirmInputView.m
//  YJOTC
//
//  Created by l on 2019/1/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "ConfirmInputView.h"

@implementation ConfirmInputView


-(void)awakeFromNib
{
    [super awakeFromNib];
//    "C_community_search_cash_pay_title" = "更改扣款比例";
//    "C_community_search_cash_pay_wailttopay" = "待付款";
//    "C_community_search_cash_pay_wwalletPay" = "我的錢包扣款";
//    "C_community_search_cash_pay_rbzPay" = "瑞波钻扣款";
//    "C_community_search_cash_pay_descontent" = "*本交易至少在我的錢包資產中扣除認購額的50%以上的XRP";
    _titleLabel.text = kLocat(@"C_community_search_cash_pay_title");
    _kkLabel.text = kLocat(@"C_community_search_cash_pay_wwalletPay");
    _rbKKLabel.text = kLocat(@"C_community_search_cash_pay_rbzPay");
    _kkTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    kViewBorderRadius(_sureButton, 8, 0, kRedColor);
    [_sureButton addShadow];
    [_sureButton setTitle:kLocat(@"A_boss_confirm") forState:UIControlStateNormal];
    _sureButton.backgroundColor = kColorFromStr(@"#6189C5");
    [_closeButton addTarget:self action:@selector(hideAction:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton addTarget:self action:@selector(submitAcion:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)hideAction:(UIButton *)button
{
    NSLog(@"%@",button.superview.superview.superview);
    [button.superview.superview removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"returnj" object:nil];
}

-(void)submitAcion:(UIButton *)button
{
    self.callBackBlock(button);
}


@end
