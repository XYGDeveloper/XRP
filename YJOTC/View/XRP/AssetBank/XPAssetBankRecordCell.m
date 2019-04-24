
//
//  XPAssetBankRecordCell.m
//  YJOTC
//
//  Created by Roy on 2018/12/21.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAssetBankRecordCell.h"

@implementation XPAssetBankRecordCell


-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    _addTimeLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"z_addtime"),dic[@"add_time"]];
    
    _earningsLabel.text = [NSString stringWithFormat:@"%@: %@ %@",kLocat(@"z_yujishouyi"),dic[@"estimate_money"],dic[@"currency_mark"]];
    
    _endTimeLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"z_yujidaozhangshijian"),dic[@"end_time"]];
    
    _rateLabel.text = [NSString stringWithFormat:@"%@ %@%%",kLocat(@"z_yearearningrate"),dic[@"rate"]];
    _timeLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"z_managetime"),dic[@"days"],kLocat(@"z_day")];
    
    //狀態 生息中#33DE60   受理中#F09E10  已生息#F75523  已失效#3284CA
    
    if ([_dic[@"status"] intValue] == 0) {
        _statusLabel.text = kLocat(@"z_shengxiing");
        _statusLabel.textColor = kColorFromStr(@"33DE60");
    }else if([_dic[@"status"] intValue] == 1){
        _statusLabel.text = kLocat(@"z_shengxied");
        _statusLabel.textColor = kColorFromStr(@"F75523");
    }else{
        _statusLabel.text = kLocat(@"z_yishixiao");
        _statusLabel.textColor = kColorFromStr(@"3284ca");
    }
    
    
    
    //數量
    
    NSString *vol = [NSString stringWithFormat:@"%@: %@ %@",kLocat(@"z_zhuanruvol"),dic[@"num"],dic[@"currency_mark"]];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:vol];

    NSRange range1 = [vol rangeOfString:ConvertToString(dic[@"num"])];
    [attr addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#F09E10") range:range1];
    
//    [attr addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#F52657") range:range2];
//    [attr addAttribute:NSFontAttributeName value:PFRegularFont(19) range:range2];
    
    _volumeLabel.attributedText = attr;
    
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
    _bgView.backgroundColor = kWhiteColor;
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    [_bgView addShadow];
    
    
    _addTimeLabel.textColor = k999999Color;
    _addTimeLabel.font = PFRegularFont(10);
    
    _volumeLabel.textColor = k222222Color;
    _volumeLabel.font = PFRegularFont(12);
    
    _earningsLabel.textColor = k222222Color;
    _earningsLabel.font = PFRegularFont(12);
    
    
    _endTimeLabel.textColor = k999999Color;
    _endTimeLabel.font = PFRegularFont(10);
    
    
    _statusLabel.textColor = k999999Color;
    _statusLabel.font = PFRegularFont(12);
    
    
    
    _rateLabel.textColor = k222222Color;
    _rateLabel.font = PFRegularFont(12);
    
    _timeLabel.textColor = k222222Color;
    _timeLabel.font = PFRegularFont(12);

    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
