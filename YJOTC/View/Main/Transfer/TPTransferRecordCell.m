
//
//  TPTransferRecordCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPTransferRecordCell.h"

@implementation TPTransferRecordCell

-(void)setDateDic:(NSDictionary *)dateDic
{
    _dateDic = dateDic;
    
    if (kUserInfo.uid == [dateDic[@"send_id"]integerValue]) {
        _volumeLabel.text = [NSString stringWithFormat:@"-%@ BCB",dateDic[@"num"]];
    }else{
        _volumeLabel.text = [NSString stringWithFormat:@"+%@ BCB",dateDic[@"num"]];

    }
    
    _receiveAccountLabel.text = [NSString stringWithFormat:@"接收方賬戶：%@",dateDic[@"get_email"]];
    

//    _beforeVolumeLabel.text = [NSString stringWithFormat:@"轉賬前可用數量：%@ BCB",dateDic[@"send_before_num"]];
    _beforeVolumeLabel.text = [NSString stringWithFormat:@"時間：%@",dateDic[@"add_time"]];
    
 
    
    _sendIDLabel.text = [NSString stringWithFormat:@"發送方ID：%@",dateDic[@"send_id"]];
    _receiveIDLabel.text = [NSString stringWithFormat:@"接收方ID：%@",dateDic[@"get_id"]];

    if ([dateDic[@"send_id"] integerValue] != kUserInfo.uid) {
        _volumeLabel.textColor = kColorFromStr(@"#03C086");
    }else{
        _volumeLabel.textColor = kColorFromStr(@"EA6E44");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#1E1F22");
    
    _volumeLabel.textColor = kColorFromStr(@"#EA6E44");
    _volumeLabel.font = PFRegularFont(18);
    
    _receiveAccountLabel.textColor = kLightGrayColor;
    _receiveAccountLabel.font = PFRegularFont(12);
    
    _beforeVolumeLabel.textColor = kDarkGrayColor;
    _beforeVolumeLabel.font = PFRegularFont(12);
    
    _timeLabel.textColor = kDarkGrayColor;
    _timeLabel.font = PFRegularFont(12);
    
    _receiveIDLabel.textColor = kLightGrayColor;
    _receiveIDLabel.font = PFRegularFont(12);
    _sendIDLabel.textColor = kLightGrayColor;
    _sendIDLabel.font = PFRegularFont(12);
    _timeLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
