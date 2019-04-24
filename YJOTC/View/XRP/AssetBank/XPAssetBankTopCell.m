
//
//  XPAssetBankTopCell.m
//  YJOTC
//
//  Created by Roy on 2018/12/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAssetBankTopCell.h"

@implementation XPAssetBankTopCell

-(void)setModel:(XPAssetBankModel *)model
{
    _model = model;
    
    _volumeLabel1.text = [NSString stringWithFormat:@"+%@",model.rate];
    
    _timeLabel.text = [NSString stringWithFormat:@"%d",_model.months.intValue * 30];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:_timeLabel.text];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    
    _timeLabel.attributedText = content;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    
    _descLabel1.textColor = k999999Color;
    _descLabel1.font = PFRegularFont(12);
    
    _descLabel2.textColor = k999999Color;
    _descLabel2.font = PFRegularFont(12);
    
    
    _volumeLabel1.textColor = kColorFromStr(@"#DB1414");
    _volumeLabel1.font = PFRegularFont(26);

    _signLabel.textColor = kColorFromStr(@"#DB1414");
    _signLabel.font = PFRegularFont(12);
    
    
    _manLabel.textColor = kColorFromStr(@"#066B98");
    _manLabel.font = PFRegularFont(14);
    
    
    _timeLabel.textColor = kColorFromStr(@"DB1414");
    _timeLabel.font = PFRegularFont(20);
    
    
    _day.textColor = kColorFromStr(@"#DB1414");
    _day.font = PFRegularFont(12);
    
    _manLabel.text = kLocat(@"z_manageqixian");
    _descLabel1.text = kLocat(@"z_predictRate");
    _descLabel2.text = kLocat(@"z_lowrisk");
    _day.text = kLocat(@"z_day");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
