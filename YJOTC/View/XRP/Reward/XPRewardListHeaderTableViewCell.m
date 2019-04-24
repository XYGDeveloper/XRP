//
//  XPRewardListHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPRewardListHeaderTableViewCell.h"
#import "XPBoundHeadModel.h"
#import "MQGradientProgressView.h"
@interface XPRewardListHeaderTableViewCell()
@end

@implementation XPRewardListHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.optionButton.layer.cornerRadius = 8;
    self.optionButton.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)refreshWithModel:(XPBoundHeadModel *)model  type:(NSString *)type{
    self.totalRevenueContentLael.text  = model.count_profit;
    if ([type isEqualToString:@"0"]) {
        self.increContentLabel.text = model.child_num;
    }else{
        self.increContentLabel.text = model.level;
    }
    self.todayContentLabel.text = model.today_profit;
    self.optionButton.hidden = YES;
//    if ([model.color_type isEqualToString:@"1"]) {
//        [self.optionButton setTitle:model.button forState:UIControlStateNormal];
//        self.optionButton.backgroundColor  = kColorFromStr(@"#E4A646");
//        self.optionButton.userInteractionEnabled = YES;
//    }else{
//        [self.optionButton setTitle:model.button forState:UIControlStateNormal];
//        self.optionButton.backgroundColor  = kColorFromStr(@"#AFBBBF");
//        self.optionButton.userInteractionEnabled = NO;
//    }
}


@end
