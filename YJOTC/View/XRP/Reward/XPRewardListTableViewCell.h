//
//  XPRewardListTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XPGetLogModel;
@class lanModel;

@interface XPRewardListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *increaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *piaoShuLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyType;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgview;


- (void)refreshWithModel:(XPGetLogModel *)model;

- (void)refreshWithModel1:(lanModel *)model;

@end
