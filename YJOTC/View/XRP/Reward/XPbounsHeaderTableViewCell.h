//
//  XPbounsHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPbounsHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TotalRevenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentContwentLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalRevenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalRevenueContent;
@property (weak, nonatomic) IBOutlet UILabel *todayRenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressDes;

@property (weak, nonatomic) IBOutlet UIView *progroessView;
@property (weak, nonatomic) IBOutlet UILabel *onlinedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOnlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;

@end
