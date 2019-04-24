//
//  XPAssetBankListCell.m
//  YJOTC
//
//  Created by Roy on 2018/12/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAssetBankListCell.h"

@implementation XPAssetBankListCell



-(void)setModel:(XPAssetBankModel *)model
{
    _model = model;
    
    _title.text = model.title;
    
    _timaLabel.text = [NSString stringWithFormat:@"%d %@",30*model.months.intValue,kLocat(@"z_day")];
    
    _volumeLabel.text = [NSString stringWithFormat:@"%@%%",model.rate];
    
    _descLabel.text = [NSString stringWithFormat:@"%@ :≈",kLocat(@"z_predictRate")];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
    
    
    _title.textColor = k222222Color;
    _title.font = PFRegularFont(16);
    
    _descLabel.textColor = k999999Color;
    _descLabel.font = PFRegularFont(12);
    
    _volumeLabel.textColor = kColorFromStr(@"#E4A646");
    _volumeLabel.font = PFRegularFont(12);
    
    _time.textColor = k999999Color;
    _time.font = PFRegularFont(12);
    
    
    _timaLabel.textColor = kColorFromStr(@"#E4A646");
    _timaLabel.font = PFRegularFont(12);
    
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    [_bgView addShadow];
    
    _descLabel.text = [NSString stringWithFormat:@"%@%@ : ",kLocat(@"z_predictRate"),@""];
    _time.text = [NSString stringWithFormat:@"%@ :",kLocat(@"z_managetime")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
