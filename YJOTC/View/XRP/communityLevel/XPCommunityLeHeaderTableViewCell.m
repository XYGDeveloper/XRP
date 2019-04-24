//
//  XPCommunityHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCommunityLeHeaderTableViewCell.h"

@implementation XPCommunityLeHeaderTableViewCell


-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSString *avatar = dataDic[@"head"];
    [_headImg setImageWithURL:avatar.ks_URL placeholder:kImageFromStr(@"user_icon_phto")];
    _nikeLabel.text = dataDic[@"nick"];
    _nikeDesLabel.text = [NSString stringWithFormat:@"ID:%@",dataDic[@"member_id"]];

    _tipsfirLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_reward_manager_communitylevel"),dataDic[@"level1"]];
    _tipSecLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"A_boss_nextLevel"),dataDic[@"level2"]];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
