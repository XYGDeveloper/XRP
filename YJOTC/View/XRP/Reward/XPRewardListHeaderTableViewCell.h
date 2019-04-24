//
//  XPRewardListHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPBoundHeadModel;

@interface XPRewardListHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TotalRevenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *increseLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalRevenueContentLael;
@property (weak, nonatomic) IBOutlet UILabel *increContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;

- (void)refreshWithModel:(XPBoundHeadModel *)model type:(NSString *)type;
@end
