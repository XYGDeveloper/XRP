//
//  XPResultTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/1/3.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPResultTableViewCell.h"
#import "XPSearchResultModel.h"

@implementation XPResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    self.reviewButton.layer.cornerRadius = 5;
    self.reviewButton.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 25;
    self.headerImg.layer.masksToBounds = YES;
// Initialization code
}

- (void)refreshWithjijuoModel:(XPSearchResultModel *)model{
    [self.headerImg setImageWithURL:[NSURL URLWithString:model.head] options:0];
    self.nikeNameLabel.text = model.nick;
    self.accounterLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_search_accounter"),model.phone];
    self.idLabel.text = [NSString stringWithFormat:@"%@:%@",@"ID",model.member_id];
    //    self.invitecode.hidden = YES;
    self.inviteCodeLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_basic_recorlist_zhishushequ"),model.invit_code];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"k_popview_select_paywechat_accounter01"),model.phone];
    [self.reviewButton setTitle:kLocat(@"C_community_jh_search_community_bind_member") forState:UIControlStateNormal];
}


- (IBAction)tosign:(id)sender {
    if (self.bind) {
        self.bind();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
