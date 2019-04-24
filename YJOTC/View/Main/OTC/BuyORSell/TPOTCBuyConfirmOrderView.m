//
//  TPOTCBuyConfirmOrderView.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyConfirmOrderView.h"

@implementation TPOTCBuyConfirmOrderView

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    

    NSDictionary *dic = dataDic[@"bank"];
    
    NSString *payWay = dic[@"bankname"];
    
    if ([payWay isEqualToString:@"bank"]) {
        
        _icon.image = kImageFromStr(@"gmxq_icon_yhk");
        _payWay.text = dic[@"bname"];
        
        _account.text = kLocat(@"k_popview_input_branchbank_carnumber");
        _qrCode.text = kLocat(@"k_popview_input_branchbank");

        _qrCodeLabel.text = dic[@"inname"];
        _qrButton.hidden = YES;
    }else{
       
        if ([payWay isEqualToString:kZFB]) {
            _icon.image = kImageFromStr(@"gmxq_icon_zfb");
            _payWay.text = kLocat(@"k_popview_select_payalipay");
            _account.text = kLocat(@"k_popview_list_aliycounter");
            _qrCode.text = kLocat(@"k_popview_select_paywechat_rececode");
            
        }else{
            _icon.image = kImageFromStr(@"gmxq_icon_wx");
            _payWay.text = kLocat(@"k_popview_select_paywechat");
            
            _account.text = kLocat(@"k_popview_select_paywechat_accounter");
            _qrCode.text = kLocat(@"k_popview_select_paywechat_rececode");
        }
    }
    _referenceLabel.text = dataDic[@"pay_number"];
    _accountLabel.text = dic[@"cardnum"];

    _nameLabel.text = dic[@"truename"];
//        _nameLabel.text = dataDic[@"username"];

}









-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = kWhiteColor;
    
    _name.text = kLocat(@"OTC_buy_skr");
    _reference.text = kLocat(@"OTC_payreference");
    
    _tipsLabel.font = PFRegularFont(12);
    _payWay.textColor = k666666Color;
    _payWay.font = PFRegularFont(14);
    
}
@end
