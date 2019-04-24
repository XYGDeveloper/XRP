//
//  XPsearchResultTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPsearchResultTableViewCell.h"
#import "XPSearchResultModel.h"
#import "XPApplyModel.h"
#import "XPFridendModel.h"
#import "XPCommunityLeaderModel.h"
@implementation XPsearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    self.jhuoButton.layer.cornerRadius = 5;
    self.jhuoButton.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithModel:(XPSearchResultModel *)model{

    [self.headimg setImageWithURL:[NSURL URLWithString:model.head] options:0];
    self.nikeLabel.text = model.nick;
    self.accounterLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_accounter"),model.phone];
    self.idLabel.text = [NSString stringWithFormat:@"%@:%@",@"ID",model.member_id];
    self.invitecode.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_invitecode_"),model.invit_code];
    [self.jhuoButton setTitle:kLocat(@"C_community_jh_search_community_bind_member") forState:UIControlStateNormal];
}

- (void)refreshWithapplyModel:(parentModel *)model{
    [self.headimg setImageWithURL:[NSURL URLWithString:model.head] options:0];
    self.nikeLabel.text = model.nick;
    self.accounterLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_accounter"),model.phone];
    self.idLabel.text = [NSString stringWithFormat:@"%@:%@",@"ID",model.member_id];
//    self.invitecode.hidden = YES;
    self.invitecode.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_invitecode_"),model.invit_code];
    self.jhuoButton.hidden = YES;
    [self.jhuoButton setTitle:kLocat(@"C_community_search_jhaction") forState:UIControlStateNormal];
}

- (void)refreshWithjijuoModel:(XPSearchResultModel *)model{
    [self.headimg setImageWithURL:[NSURL URLWithString:model.head] options:0];
    self.nikeLabel.text = model.nick;
    self.accounterLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_accounter"),model.phone];
    self.idLabel.text = [NSString stringWithFormat:@"%@:%@",@"ID",model.member_id];
    //    self.invitecode.hidden = YES;
    self.invitecode.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_invitecode_"),model.invit_code];
    self.jhuoButton.hidden = YES;
    [self.jhuoButton setTitle:kLocat(@"C_community_search_jhaction") forState:UIControlStateNormal];
    
}

- (void)refreshWithjijuoModel1:(membersModel *)model{
    [self.headimg setImageWithURL:[NSURL URLWithString:model.head] placeholder:[UIImage imageNamed:@"user_icon_phto"]];
    
    self.nikeLabel.text = model.nick;
    self.invitecode.hidden = YES;
    self.jhuoButton.hidden = YES;
    self.idLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_accounter"),model.member_id];
    self.accounterLabel.text = [NSString stringWithFormat:@"ID:%@",model.phone];
    self.timeLabel.text  = [NSString stringWithFormat:@"%@:%@",kLocat(@"z_addtime"),model.add_time];
//    self.headimg.image = kImageFromStr(@"user_icon_phto");

}


- (void)refreshWithjijuoModel2:(XPCommunityPrentModel *)model{
    [self.headimg setImageWithURL:[NSURL URLWithString:model.head] options:0];
    self.nikeLabel.text = model.nick;
    self.accounterLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_accounter"),model.phone];
    self.idLabel.text = [NSString stringWithFormat:@"%@:%@",@"ID",model.member_id];
    //    self.invitecode.hidden = YES;
    self.invitecode.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_invitecode_"),model.invit_code];
    self.jhuoButton.hidden = NO;
    [self.jhuoButton setTitle:kLocat(@"C_community_jh_search_community_bind_member") forState:UIControlStateNormal];
}

- (void)refreshWithjijuoModel3:(XPCommunityUserModel *)model{
    [self.headimg setImageWithURL:[NSURL URLWithString:model.head] options:0];
    self.nikeLabel.text = model.nick;
    self.accounterLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_accounter"),model.phone];
    self.idLabel.text = [NSString stringWithFormat:@"%@:%@",@"ID",model.member_id];
    //    self.invitecode.hidden = YES;
    self.invitecode.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_invitecode_"),model.invit_code];
    self.jhuoButton.hidden = NO;
    [self.jhuoButton setTitle:kLocat(@"C_community_jh_search_community_bind_member") forState:UIControlStateNormal];
}


- (void)refreshWithjijuoModel4:(XPSearchResultModel *)model{
    [self.headimg setImageWithURL:[NSURL URLWithString:model.head] options:0];
    self.nikeLabel.text = model.nick;
    self.accounterLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_accounter"),model.phone];
    self.idLabel.text = [NSString stringWithFormat:@"%@:%@",@"ID",model.member_id];
    //    self.invitecode.hidden = YES;
    self.invitecode.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_invitecode_"),model.invit_code];
    self.jhuoButton.hidden = NO;
    [self.jhuoButton setTitle:kLocat(@"C_community_jh_search_community_activit_jh") forState:UIControlStateNormal];
}



- (IBAction)bindAction:(id)sender {
    if (self.bind) {
        self.bind();
    }
}



@end
