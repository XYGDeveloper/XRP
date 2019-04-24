//
//  XPCommunityFooterTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/24.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCommunityFooterTableViewCell.h"

@implementation XPCommunityFooterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.communityButton, 8, 0, kRedColor);
    [self.communityButton addShadow];
    [self.communityButton setTitle:kLocat(@"C_community_button_option") forState:UIControlStateNormal];
    self.communityButton.titleLabel.font = PFRegularFont(16);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
