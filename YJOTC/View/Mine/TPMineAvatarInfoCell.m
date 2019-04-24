

//
//  TPMineAvatarInfoCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPMineAvatarInfoCell.h"

@implementation TPMineAvatarInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    kViewBorderRadius(_avatar, 25, 0, kRedColor);

    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#225686");
    _nickNameLabel.textColor = kColorFromStr(@"#CDD2E3");
    _nickNameLabel.font = PFRegularFont(12);
    _accountLabel.textColor = kColorFromStr(@"#CDD2E3");
    _accountLabel.font = PFRegularFont(16);
    
    _modButton.titleLabel.font = PFRegularFont(12);
    [_modButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_modButton setTitle:kLocat(@"HBMemberViewController_set_nickname") forState:UIControlStateNormal];
    
    self.accountLabel.text = kUserInfo.nickName;
    self.nickNameLabel.text = [NSString stringWithFormat:@"ID：%zd",kUserInfo.uid];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
