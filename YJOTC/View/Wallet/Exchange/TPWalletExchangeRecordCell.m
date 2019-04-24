//
//  TPWalletExchangeRecordCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletExchangeRecordCell.h"

@implementation TPWalletExchangeRecordCell


-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _typeLabel.text = [NSString stringWithFormat:@"类型：%@  to  %@",dataDic[@"currency_name"],dataDic[@"to_name"]];
    
    
    //status -1已撤销 0审核中 1已完成
    int status = [dataDic[@"status"] intValue];
    if (status == -1) {
        _statusLabel.text = @"已撤銷";
        _statusLabel.textColor = kColorFromStr(@"747B8F");
        self.contentView.backgroundColor = kColorFromStr(@"#494B56");
        _volumeLabel.text = @"**********";
        _desCurrencyLabel.text = @"";
        _timeLabel.text = [NSString stringWithFormat:@"撤销时间：%@",dataDic[@"update_time"]];
    }else if (status == 0){
        _statusLabel.text = @"審核中";
        _statusLabel.textColor = kColorFromStr(@"E06921");
        self.contentView.backgroundColor = kColorFromStr(@"#1E1F22");
        _volumeLabel.text = [NSString stringWithFormat:@"-%@",dataDic[@"from_num"]];
        _desCurrencyLabel.text = dataDic[@"currency_name"];
        _timeLabel.text = [NSString stringWithFormat:@"發起時間：%@",dataDic[@"add_time"]];
    }else{
        _statusLabel.text = @"已完成";
        _statusLabel.textColor = kColorFromStr(@"4C9EE4");
        self.contentView.backgroundColor = kColorFromStr(@"#1E1F22");
        _volumeLabel.text = [NSString stringWithFormat:@"+%@",dataDic[@"actual"]];
        _desCurrencyLabel.text = dataDic[@"to_name"];
        _timeLabel.text = [NSString stringWithFormat:@"發起時間：%@",dataDic[@"add_time"]];
    }
    _tipsLabel.hidden =  status != 0;
    
    
}




- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#1E1F22");
//    self.contentView.backgroundColor = kColorFromStr(@"#494B56");

    /**
     
     #4C9EE4  已完成
     #E06921 审核中
     #747B8F 已撤销
     */
    
    _typeLabel.textColor  =kLightGrayColor;
    _typeLabel.font = PFRegularFont(14);
    
    _statusLabel.textColor  =kLightGrayColor;
    _statusLabel.font = PFRegularFont(14);
    
    _desCurrencyLabel.textColor  =kLightGrayColor;
    _desCurrencyLabel.font = PFRegularFont(14);
    
    _volumeLabel.textColor  =kLightGrayColor;
    _volumeLabel.font = PFRegularFont(16);
    
    
    _timeLabel.textColor  = kColorFromStr(@"#707589");
    _timeLabel.font = PFRegularFont(10);
    
    _tipsLabel.textColor  = kColorFromStr(@"#7F8590");
    _tipsLabel.font = PFRegularFont(10);
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
