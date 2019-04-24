//
//  XPCommunityDetailHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCommunityDetailHeaderTableViewCell.h"
#import "XPDetailModel.h"

@interface XPCommunityDetailHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *rbjIcon;

@property (weak, nonatomic) IBOutlet UIImageView *rbjLogo;

@end

@implementation XPCommunityDetailHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    // Initialization code
    
    [_zengtouButton setTitle:kLocat(@"A_zhentou") forState:UIControlStateNormal];
    [_zengtouButton setTitleColor:kColorFromStr(@"#6189C5") forState:UIControlStateNormal];
    _zengtouButton.titleLabel.font = PFRegularFont(16);

    [_detaiButton setTitle:kLocat(@"W_Detail") forState:UIControlStateNormal];
    [_detaiButton setTitleColor:kColorFromStr(@"#6189C5") forState:UIControlStateNormal];
    _detaiButton.titleLabel.font = PFRegularFont(16);
    
    [_rbjDetailButton setTitle:kLocat(@"W_Detail") forState:UIControlStateNormal];
    [_rbjDetailButton setTitleColor:kColorFromStr(@"#6189C5") forState:UIControlStateNormal];
    _rbjDetailButton.titleLabel.font = PFRegularFont(16);
    
//    _rbjDetailButton.hidden = YES;
//    _rbjIcon.hidden = YES;
//    _rbjLogo.hidden = YES;
//    _rbjLabel.hidden = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithModel:(infoModel *)model{
    self.currentLabel.text = [NSString stringWithFormat:@"%@:  %@%@",kLocat(@"C_community_reward_current_jingxuan"),model.votes,kLocat(@"C_community_search_votes")];
    self.currentCountLabel.text = [NSString stringWithFormat:@"%@：%@",kLocat(@"C_community_reward_manager_piaoshu"),model.num];
    self.currentLevelLabel.text = [NSString stringWithFormat:@"%@:  LV%@",kLocat(@"C_community_reward_manager_communitylevel"),model.level];
    _rbjLabel.text = [NSString stringWithFormat:@"%@：%@",kLocat(@"A_boss_rbj"),model.xrpj_num];
    if (model.xrpj_num.doubleValue > 0) {
        _rbjDetailButton.hidden = NO;
        _rbjIcon.hidden = NO;
        _rbjLogo.hidden = NO;
        _rbjLabel.hidden = NO;
        _rbjLabel.superview.hidden = NO;
    }else{
        _rbjDetailButton.hidden = YES;
        _rbjIcon.hidden = YES;
        _rbjLogo.hidden = YES;
        _rbjLabel.hidden = YES;
        _rbjLabel.superview.hidden = YES;
    }
}

@end
