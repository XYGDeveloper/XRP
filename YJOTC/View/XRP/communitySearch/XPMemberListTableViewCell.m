//
//  XPMemberListTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/1/5.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPMemberListTableViewCell.h"
#import "XPFridendModel.h"
@implementation XPMemberListTableViewCell

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


- (void)refreshWithModel:(membersModel *)model{
    [self.headImg setImageWithURL:[NSURL URLWithString:model.head] placeholder:[UIImage imageNamed:@"user_icon_phto"]];
    self.nikeLabel.text = model.nick;
    self.idLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_accounter"),model.member_id];
    self.accounterLabel.text = [NSString stringWithFormat:@"ID:%@",model.phone];
    self.timeLabel.text  = [NSString stringWithFormat:@"%@:%@",kLocat(@"z_addtime"),model.add_time];
}

@end
