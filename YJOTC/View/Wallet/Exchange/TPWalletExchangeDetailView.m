
//
//  TPWalletExchangeDetailView.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletExchangeDetailView.h"

@implementation TPWalletExchangeDetailView



-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    //status -1已撤销 0审核中 1已完成
    int status = [dataDic[@"status"] intValue];
    
    _accountLAbel.text = kUserInfo.nickName;
    
    if (status == -1) {
        _leftPriceLabel.text = @"--";
        _rightPriceLabel.text = @"--";
        _startTimeLabel.text = [NSString stringWithFormat:@"發起時間: %@",dataDic[@"add_time"]];
        _endLabel.text = @"完成時間:";
        _statusLabel.text = @"已撤銷";
        _statusLabel.textColor = kColorFromStr(@"747B8F");
        _volumeLabel.text = [NSString stringWithFormat:@"--%@",dataDic[@"currency_name"]];
        _feeLabel.text = [NSString stringWithFormat:@"手續費：--%@",dataDic[@"to_name"]];
        _cnyLabel.text = [NSString stringWithFormat:@"估值：約--CNY"];
        _tips.text = @"預計兌換：";
        _realLabel.text = [NSString stringWithFormat:@"--%@",dataDic[@"to_name"]];
    }else if (status == 0){
        _statusLabel.text = @"審核中";
        _statusLabel.textColor = kColorFromStr(@"E06921");
        //价格调用接口
        
        //手续费
        
        //预计到账
        
        //估值
//        _cnyLabel.text = [NSString stringWithFormat:@"估值：約%@CNY",dataDic[@"from_total_cny"]];

        _startTimeLabel.text = [NSString stringWithFormat:@"發起時間: %@",dataDic[@"add_time"]];
        _endLabel.text = @"完成時間:";
        _volumeLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"from_num"],dataDic[@"currency_name"]];
        _tips.text = [NSString stringWithFormat:@"預計兌換："];

        

        
        
    }else{
        _leftPriceLabel.text = dataDic[@"from_cny"];
        _rightPriceLabel.text = dataDic[@"to_cny"];
        _statusLabel.text = @"已完成";
        _statusLabel.textColor = kColorFromStr(@"4C9EE4");
        
        _startTimeLabel.text = [NSString stringWithFormat:@"發起時間: %@",dataDic[@"add_time"]];
        _endLabel.text = [NSString stringWithFormat:@"完成時間: %@",dataDic[@"update_time"]];;

        _volumeLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"from_num"],dataDic[@"currency_name"]];
        _feeLabel.text = [NSString stringWithFormat:@"手續費：%@%@",dataDic[@"fee"],dataDic[@"to_name"]];
        _cnyLabel.text = [NSString stringWithFormat:@"估值：約%@CNY",dataDic[@"from_total_cny"]];
        _tips.text = [NSString stringWithFormat:@"實際兌換："];
        _realLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"actual"],dataDic[@"to_name"]];
    }
    
    
    _leftCuLabel.text = [NSString stringWithFormat:@"%@/CNY",dataDic[@"currency_name"]];
    _rightCuLabel.text = [NSString stringWithFormat:@"%@/CNY",dataDic[@"to_name"]];

    //發起時間完成時間  估值：約240000CNY 預計兌換： 實際兌換：
    

    
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _tipsLabel.text = @"註：實際兌換數量以審核時幣值為準";
    _leftPriceLabel.text = @"--";
    _rightPriceLabel.text = @"--";

    self.backgroundColor = kWhiteColor;
    
    _accountLAbel.textColor = k323232Color;
    _accountLAbel.font = PFRegularFont(14);
    
    _statusLabel.textColor = kColorFromStr(@"#4C9EE4");
    _statusLabel.font = PFRegularFont(14);
    
    _endLabel.textColor = kColorFromStr(@"666666");
    _endLabel.font = PFRegularFont(10);
    
    _startTimeLabel.textColor = kColorFromStr(@"666666");
    _startTimeLabel.font = PFRegularFont(10);
    
    _volumeLabel.textColor = k323232Color;
    _volumeLabel.font = PFRegularFont(14);
    
    _feeLabel.textColor = k323232Color;
    _feeLabel.font = PFRegularFont(12);
    
    _cnyLabel.textColor = k323232Color;
    _cnyLabel.font = PFRegularFont(12);

    _realLabel.textColor = k323232Color;
    _realLabel.font = PFRegularFont(16);
    
    _tips.textColor = k323232Color;
    _tips.font = PFRegularFont(12);
    
    _tipsLabel.textColor = k323232Color;
    _tipsLabel.font = PFRegularFont(12);
    
    _leftPriceLabel.textColor = kWhiteColor;
    _leftPriceLabel.font = PFRegularFont(12);
    
    _leftCuLabel.textColor = kWhiteColor;
    _leftCuLabel.font = PFRegularFont(16);
    
    _rightPriceLabel.textColor = kWhiteColor;
    _rightPriceLabel.font = PFRegularFont(12);
    
    _rightCuLabel.textColor = kWhiteColor;
    _rightCuLabel.font = PFRegularFont(16);
    
    _leftMargin.constant = kScreenW/2.0 +10;
    _leftMArgin1.constant = kScreenW/2 - 10;
    
    _tipsLabel.adjustsFontSizeToFitWidth = YES;
    _endLabel.adjustsFontSizeToFitWidth = YES;
    _startTimeLabel.adjustsFontSizeToFitWidth = YES;
    _tips.adjustsFontSizeToFitWidth = YES;
    
    
}

@end
