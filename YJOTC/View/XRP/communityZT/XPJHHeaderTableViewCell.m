//
//  XPJHHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPJHHeaderTableViewCell.h"
#import "XPGetValiModel.h"
@implementation XPJHHeaderTableViewCell

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

- (void)refreshWithModel:(XPGetValiModel *)model{
    self.hLabel.text = kLocat(@"C_community_search_myinfo");
    self.fLabel.text = kLocat(@"C_community_search_myvotecount");
    self.firImg.image = [UIImage imageNamed:@"community_detail_current"];
    self.sedImg.image = [UIImage imageNamed:@"community_detail_count"];
    self.thirdImg.image = [UIImage imageNamed:@"community_detail_level"];
    self.flagIMg.image = [UIImage imageNamed:@"community_detail_icon"];
    self.firLabel.text = [NSString stringWithFormat:@"%@ :  %@%@",kLocat(@"C_community_search_current_jx"),model.current.votes,kLocat(@"C_community_search_votes")];
    self.sedLabel.text = [NSString stringWithFormat:@"%@ :  %@",kLocat(@"C_community_reward_manager_piaoshu"),model.current.number];
    self.thirdLabel.text = [NSString stringWithFormat:@"%@ :  %@%@",kLocat(@"C_community_search_alert_sure_min"),model.current.min,kLocat(@"C_community_search_votes")];
    
}

@end
