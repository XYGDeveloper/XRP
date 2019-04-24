//
//  XPReveInfoTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPReveInfoTableViewCell.h"
#import "XPApplyModel.h"
@implementation XPReveInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
 
    // Initialization code
}

- (void)refreshWithModel:(auditModel *)model{
    self.firImg.image = [UIImage imageNamed:@"community_detail_current"];
    self.sedImg.image = [UIImage imageNamed:@"community_detail_count"];
    self.flagImg.image = [UIImage imageNamed:@"community_detail_icon"];
    self.firLabel.text = [NSString stringWithFormat:@"%@:   %@",kLocat(@"C_community_reward_current_jingxuan"),model.votes];
    self.sedLabel.text = [NSString stringWithFormat:@"%@:   %@",kLocat(@"C_community_reward_current_piaoshuranshao"),model.total];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
