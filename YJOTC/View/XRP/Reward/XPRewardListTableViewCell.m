//
//  XPRewardListTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPRewardListTableViewCell.h"
#import "XPGetLogModel.h"
#import "XPZSModel.h"
@implementation XPRewardListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    self.typeLabel.layer.cornerRadius = 32/2;
    self.typeLabel.layer.borderColor = kColorFromStr(@"#999999").CGColor;
    self.typeLabel.layer.borderWidth = 1.0f;
    // Initialization code
}

- (void)refreshWithModel:(XPGetLogModel *)model{
//    if ([model.type isEqualToString:@"1"]) {
//        self.recommendTypeLabel.text = kLocat(@"C_community_bouns_basic_incre");
//        self.increaseLabel.text = [NSString stringWithFormat:@"%@:%@‰",kLocat(@"C_basic_bouns_dayprofiet"),model.profit];
//        self.piaoShuLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_reward_current_piaoshu"),model.limit_num];
//        self.currencyType.text = [NSString stringWithFormat:@"+%@XRP",model.num];
//        self.timeLabel.text = model.receive_time;
//    }else if ([model.type isEqualToString:@"2"]){
//        self.recommendTypeLabel.text = kLocat(@"C_community_bouns_incre");
//        self.increaseLabel.text = [NSString stringWithFormat:@"%@:%@‰",kLocat(@"C_basic_bouns_dayprofiet"),model.profit];
//        self.piaoShuLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_reward_current_piaoshu"),model.limit_num];
//        self.currencyType.text = [NSString stringWithFormat:@"+%@XRP",model.num];
//
//        self.timeLabel.text = model.receive_time;
//    }else if ([model.type isEqualToString:@"3"]){
//        self.recommendTypeLabel.text = kLocat(@"C_community_bouns_one");
//        self.increaseLabel.text = [NSString stringWithFormat:@"%@:%@‰",kLocat(@"C_community_bouns_yestedayshouyi"),model.profit];
//        self.piaoShuLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_reward_current_piaoshu"),model.limit_num];
//        self.currencyType.text = [NSString stringWithFormat:@"+%@XRP",model.num];
//        self.timeLabel.text = model.receive_time;
//    }
    _typeLabel.text = model.icon;
    _recommendTypeLabel.text = model.title;
    _increaseLabel.text = model.profit;
    _piaoShuLabel.text = model.in_num;
    _currencyType.text = model.num;
    _timeLabel.text = model.receive_time;
}

- (void)refreshWithModel1:(lanModel *)model{
    
    self.recommendTypeLabel.text = kLocat(@"C_community_bouns_static_sum_shifang");
    self.increaseLabel.text = [NSString stringWithFormat:@"%@:%@‰",kLocat(@"C_community_bouns_static_sum_dayjichu"),model.rate];
    self.piaoShuLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"C_community_bouns_static_sum_yue"),model.total];
    self.currencyType.text = [NSString stringWithFormat:@"%@XRP",model.money];
    self.timeLabel.text = model.time;
    self.typeLabel.text = kLocat(@"C_basic_bouns_collection");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
