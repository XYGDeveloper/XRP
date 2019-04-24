//
//  XPBossActivityCancelCell.m
//  YJOTC
//
//  Created by 周勇 on 2019/1/11.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPBossActivityCancelCell.h"

@implementation XPBossActivityCancelCell

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    NSString *avatar = dataDic[@"head"];
    [_avatar setImageWithURL:avatar.ks_URL placeholder:kImageFromStr(kUserAvatarDefault)];
    
    _nameLabel.text = dataDic[@"nick"];
    _accountLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"C_community_search_accounter"),dataDic[@"phone"]];
    _idLabel.text = [NSString stringWithFormat:@"ID: %@",dataDic[@"member_id"]];
    NSString *status = ConvertToString(dataDic[@"status"]);
    if ([status isEqualToString:@"1"]) {
        _statusLabel.text = kLocat(@"C_basic_recorlist_nav02");
    }else if([status isEqualToString:@"2"]){
        _statusLabel.text = kLocat(@"C_basic_recorlist_nav03");
    }else{
        _statusLabel.text = kLocat(@"C_basic_recorlist_nav01");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
    _bgView.backgroundColor = kWhiteColor;
    kViewBorderRadius(self.bgView, 8, 0, kRedColor);
    [self.bgView addShadow];
    
    kViewBorderRadius(_avatar, 25, 0, kRedColor);
    
    _nameLabel.textColor = k222222Color;
    _nameLabel.font = PFRegularFont(16);
    
    _accountLabel.textColor = k666666Color;
    _accountLabel.font = PFRegularFont(12);
    _idLabel.textColor = k666666Color;
    _idLabel.font = PFRegularFont(12);
    
    _statusLabel.backgroundColor = kColorFromStr(@"#A7B2B6");
    _statusLabel.textColor = kWhiteColor;
    _statusLabel.font = PFRegularFont(12);
    kViewBorderRadius(_statusLabel, 5, 0, kRedColor);
//    _statusLabel.text = kLocat(@"C_basic_recorlist_nav03");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
