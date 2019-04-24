//
//  XPBasicBounsHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^toOptionReward)(void);

@class XPBoundHeadModel;

@interface XPBasicBounsHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalRenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentRenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayRenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalRenueContent;
@property (weak, nonatomic) IBOutlet UILabel *currentRenueContent;
@property (weak, nonatomic) IBOutlet UILabel *todayRenueContent;
@property (weak, nonatomic) IBOutlet UILabel *progroessDesLabel;
@property (weak, nonatomic) IBOutlet UIView *progroess01;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UIButton *optionButton;
@property (weak, nonatomic) IBOutlet UIButton *zengtouButton;
@property (weak, nonatomic) IBOutlet UILabel *deaLabel;

@property (weak, nonatomic) IBOutlet UIView *label05;
@property (nonatomic,strong)toOptionReward Ward;


- (void)refreshWithModel:(XPBoundHeadModel *)model type:(NSString *)type;

@end
