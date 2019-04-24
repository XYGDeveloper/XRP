//
//  XPcommunityProgressTopCell.m
//  YJOTC
//
//  Created by 周勇 on 2019/1/10.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPcommunityProgressTopCell.h"

@interface XPcommunityProgressTopCell ()

@property (weak, nonatomic) IBOutlet UILabel *avaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *topBGView;
@property (weak, nonatomic) IBOutlet UIView *topCurrentView;

@property (weak, nonatomic) IBOutlet UILabel *topBeginLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *topEndLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *topBeginVolumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *topEndVolumeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomCurrentView;

@property (weak, nonatomic) IBOutlet UIView *bottomBGView;

@property (weak, nonatomic) IBOutlet UILabel *bottomBeginLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomEndLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomBeginVolLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomEndVolLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomW;

@end

@implementation XPcommunityProgressTopCell

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _avaTitleLabel.text = dataDic[@"title_level"];
    _currentTitleLabel.text = dataDic[@"title_ticket_level"];
    
    _topBeginLevelLabel.text = dataDic[@"stat_level"];
    _topEndLevelLabel.text = dataDic[@"end_level"];
    
    _bottomBeginLevelLabel.text = _topBeginLevelLabel.text;
    _bottomEndLevelLabel.text = _topEndLevelLabel.text;
    
    _topW.constant = [dataDic[@"stat_recommend"] doubleValue]/[dataDic[@"end_recommend"] doubleValue] * (kScreenW - 24 - 20);
    
    _bottomW.constant = [dataDic[@"stat_money"] doubleValue]/[dataDic[@"end_money"] doubleValue] * (kScreenW - 24 - 20);
    
    _topBeginVolumeLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"stat_recommend"],kLocat(@"Dis_ChooseContacts_membercount")];
    _topEndVolumeLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"end_recommend"],kLocat(@"Dis_ChooseContacts_membercount")];

    _bottomBeginVolLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"stat_money"],kLocat(@"C_community_search_votes")];
    _bottomEndVolLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"end_money"],kLocat(@"C_community_search_votes")];

    
    
    
    /**
     "stat_level":"LV0",
     "end_level":"LV1",
     "end_recommend":"3",
     "stat_recommend":0,
     "stat_money":"0",
     "end_money":"200",
     "title_level":"有效社區圓數",
     "title_ticket_level":"當前社區投票數"*/
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.bgView.backgroundColor = kWhiteColor;
    self.contentView.backgroundColor = kTableColor;
    kViewBorderRadius(self.bgView, 8, 0, kRedColor);
    [self.bgView addShadow];
    
    kViewBorderRadius(_topBGView, 10, 0, kRedColor);
    kViewBorderRadius(_bottomBGView, 10, 0, kRedColor);
    kViewBorderRadius(_topCurrentView, 10, 0, kRedColor);
    kViewBorderRadius(_bottomCurrentView, 10, 0, kRedColor);

    _topBGView.backgroundColor = kColorFromStr(@"#3284CA");
    _bottomBGView.backgroundColor = kColorFromStr(@"#3284CA");
    _topCurrentView.backgroundColor = kColorFromStr(@"#066B98");
    _bottomCurrentView.backgroundColor = kColorFromStr(@"#066B98");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
