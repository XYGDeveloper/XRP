//
//  XPXRPPlusDetailListCell.m
//  YJOTC
//
//  Created by 周勇 on 2019/1/7.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPXRPPlusDetailListCell.h"

@interface XPXRPPlusDetailListCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *explainLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation XPXRPPlusDetailListCell

-(void)setInnovateDic:(NSDictionary *)innovateDic
{
    _innovateDic = innovateDic;
    _titleLabel.text = innovateDic[@"l_title"];
    _volumeLabel.text = innovateDic[@"l_value"];
    _explainLabel.text = innovateDic[@"l_type_explain"];
    _timeLabel.text = innovateDic[@"l_time"];
    if ([innovateDic[@"l_state"] integerValue] == 1) {//收入
        _volumeLabel.textColor = kRiseColor;
        _icon.image = kImageFromStr(@"eth_icon_jies");
    }else{
        _volumeLabel.textColor = kFallColor;
        _icon.image = kImageFromStr(@"eth_icon_fsong");
    }
}

-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    _titleLabel.text = dic[@"l_title"];
    _volumeLabel.text = dic[@"l_value"];
    _explainLabel.text = dic[@"l_type_explain"];
    _timeLabel.text = dic[@"l_time"];

    
    if ([_dic[@"l_state"] integerValue] == 1) {//收入
        _volumeLabel.textColor = kRiseColor;
        _icon.image = kImageFromStr(@"eth_icon_jies");
    }else{
        _volumeLabel.textColor = kFallColor;
        _icon.image = kImageFromStr(@"eth_icon_fsong");
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
    self.bgView.backgroundColor = kWhiteColor;
    kViewBorderRadius(self.bgView, 8, 0, kRedColor);
    [self.bgView addShadow];
    
    _timeLabel.font = PFRegularFont(10);
    _timeLabel.textColor = k999999Color;
    
    _explainLabel.font = PFRegularFont(12);
    _explainLabel.textColor = k222222Color;
    
    _titleLabel.font = PFRegularFont(14);
    _titleLabel.textColor = k222222Color;
    
    _volumeLabel.font = PFRegularFont(14);
    _volumeLabel.textColor = k999999Color;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
