//
//  XPcommunityProgressTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPcommunityProgressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIView *progroessLabel;
@property (weak, nonatomic) IBOutlet UILabel *preLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *preLabelCount;
@property (weak, nonatomic) IBOutlet UILabel *nextLabelCount;
@property (weak, nonatomic) IBOutlet UIView *currentView;

@property(nonatomic,strong)NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proW;

@end

NS_ASSUME_NONNULL_END
