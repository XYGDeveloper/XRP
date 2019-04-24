//
//  XPBossActivityCheckedCell.m
//  YJOTC
//
//  Created by 周勇 on 2019/1/11.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPBossActivityCheckedCell.h"

@interface XPBossActivityCheckedCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalVoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end




@implementation XPBossActivityCheckedCell


-(void)setIsMyMember:(BOOL)isMyMember
{
    _isMyMember = isMyMember;
    if (_isMyMember) {
        _levelLabel.hidden = NO;
        _yesterdayLabel.hidden = NO;
        _timeLabel.hidden = NO;
        _totalVoteLabel.hidden = YES;
        _tagLabel.hidden = NO;
        _bottomMargin.constant = 15;
    }else{
        _levelLabel.hidden = YES;
        _yesterdayLabel.hidden = YES;
        _timeLabel.hidden = YES;
        _totalVoteLabel.hidden = YES;
        _bottomMargin.constant = 24;
        _tagLabel.hidden = YES;
        
    }
}

-(void)setMemberDic:(NSDictionary *)memberDic
{
    _memberDic = memberDic;
    
    NSString *avatar = memberDic[@"head"];
    [_avatar setImageWithURL:avatar.ks_URL placeholder:kImageFromStr(kUserAvatarDefault)];
    
    _nameLabel.text = memberDic[@"nick"];
    _accountLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"C_community_search_accounter"),memberDic[@"phone"]];
    _idLabel.text = [NSString stringWithFormat:@"ID: %@    %@",memberDic[@"member_id"],memberDic[@"level_name"]];
    //審核投票數
    _codeLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"s_votesofcheck"),memberDic[@"active_votes"],kLocat(@"C_community_search_votes")];
    //審核人
    _checkAccoutLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"s_checker"),memberDic[@"pay_phone"]];
    
    //當前投票數-->待定
    _votesLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"S0114_CurrentVotes"),memberDic[@"votes"],kLocat(@"C_community_search_votes")];
    //他的社員
    _checkerLabe.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"S0114_hismembers"),memberDic[@"push_num"]];
    //昨日投票
    _levelLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"s0213_yesterdayvote"),memberDic[@"yestoday_in"],kLocat(@"C_community_search_votes")];
    
    
    _yesterdayLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"C_community_reward_current_sdj"),memberDic[@"level_name"]];
    
    
//    NSString *status = ConvertToString(memberDic[@"status"]);
    _statusLabel.text = kLocat(@"C_basic_recorlist_nav02");


    _timeLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"s0213_activitytime"),memberDic[@"activate_time"]];

    
    NSInteger isSame = [memberDic[@"is_same"] integerValue];
    if (isSame == 0) {
        _tagLabel.hidden = NO;
    }else{
        _tagLabel.hidden = YES;
    }
    //初始
    _codeLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"s0218_initialvote"),memberDic[@"active_votes"],kLocat(@"C_community_search_votes")];
    //當前
    _votesLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"s0218_curreentvote"),memberDic[@"votes"],kLocat(@"C_community_search_votes")];
    //團隊
    _levelLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"s0218_teamvote"),memberDic[@"total_in"],kLocat(@"C_community_search_votes")];
    //審核人
    _checkAccoutLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"s_checker"),memberDic[@"pay_phone"]];
    //她的社員
    _checkerLabe.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"S0114_hismembers"),memberDic[@"push_num"]];
    //昨日投票
    _yesterdayLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"s0213_yesterdayvote"),memberDic[@"yestoday_in"],kLocat(@"C_community_search_votes")];
    
    
    
    
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSString *avatar = dataDic[@"head"];
    [_avatar setImageWithURL:avatar.ks_URL placeholder:kImageFromStr(kUserAvatarDefault)];
    
    if (isNull(dataDic[@"nick"])) {
        _nameLabel.text = @"";
    }else{
        _nameLabel.text = dataDic[@"nick"];
    }
    
    if (isNull(dataDic[@"phone"])) {
        _accountLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"C_community_search_accounter"),@""];
    }else{
        _accountLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"C_community_search_accounter"),dataDic[@"phone"]];
    }
//    _accountLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"C_community_search_accounter"),dataDic[@"phone"]];
    
    
//    _idLabel.text = [NSString stringWithFormat:@"ID: %@",dataDic[@"member_id"]];
    if (isNull(dataDic[@"member_id"])) {
        _idLabel.text = [NSString stringWithFormat:@"ID: %@",@""];
    }else{
        _idLabel.text = [NSString stringWithFormat:@"ID: %@",dataDic[@"member_id"]];
    }
    
    _codeLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"C_basic_recorlist_zhishushequ"),dataDic[@"pid_invit_code"]];
    
    _votesLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"s_votesofcheck"),dataDic[@"votes"],kLocat(@"C_community_search_votes")];
    
    _checkAccoutLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"k_popview_select_paywechat_accounter01"),dataDic[@"pid_phone"]];
    _checkerLabe.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"s_checker"),dataDic[@"pay_phone"]];
    
    NSString *status = ConvertToString(dataDic[@"status"]);
    
    if ([status isEqualToString:@"1"]) {
        _statusLabel.text = kLocat(@"C_basic_recorlist_nav02");
    }else if([status isEqualToString:@"2"]){
        _statusLabel.text = kLocat(@"C_basic_recorlist_nav03");
    }else{
        _statusLabel.text = kLocat(@"C_basic_recorlist_nav01");
    }
    
    /**   "votes":1,
     "status":1,
     "pid_phone":"806****@qq.com",
     "pid_invit_code":"3X4NEP",
     "pay_phone":"145****@qq.com",
     "phone":"807251_test_l_1_4@qq.com",
     "nick":"807****@qq.com",
     "member_id":808272,
     "head":"https://ruibooss.oss-cn-hongkong.aliyuncs.com/images/district/2018-12-13/20190105.png"
     */
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
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
    
    _codeLabel.textColor = k666666Color;
    _codeLabel.font = PFRegularFont(12);
    _votesLabel.textColor = k666666Color;
    _votesLabel.font = PFRegularFont(12);
    _checkerLabe.textColor = k666666Color;
    _checkerLabe.font = PFRegularFont(12);
    _checkAccoutLabel.textColor = k666666Color;
    _checkAccoutLabel.font = PFRegularFont(12);
    _levelLabel.textColor = k666666Color;
    _levelLabel.font = PFRegularFont(12);
    _levelLabel.hidden = YES;
//    _statusLabel.text = kLocat(@"C_basic_recorlist_nav02");
    
    
    _timeLabel.textColor = _codeLabel.textColor;
    _timeLabel.font = PFRegularFont(10);
    _totalVoteLabel.textColor = _codeLabel.textColor;
    _totalVoteLabel.font = PFRegularFont(12);
    _yesterdayLabel.textColor = _codeLabel.textColor;
    _yesterdayLabel.font = PFRegularFont(12);
    _yesterdayLabel.hidden = YES;
    _totalVoteLabel.hidden = YES;
    _timeLabel.hidden = YES;

    _tagLabel.textColor = kWhiteColor;
    _tagLabel.font = PFRegularFont(9);
    _tagLabel.backgroundColor = kColorFromStr(@"#DF0A47");
    kViewBorderRadius(_tagLabel, 3, 0, kRedColor);
    _tagLabel.text = kLocat(@"s0218_zhongdianpeiyang");
    _tagLabel.adjustsFontSizeToFitWidth = YES;
    _tagLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
