//
//  XPCommunityDetailHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

@class infoModel;
@interface XPCommunityDetailHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLevelLabel;
@property (weak, nonatomic) IBOutlet UIButton *zengtouButton;
@property (weak, nonatomic) IBOutlet UIButton *detaiButton;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *rbjLabel;
@property (weak, nonatomic) IBOutlet UIButton *rbjDetailButton;

- (void)refreshWithModel:(infoModel *)model;

@end

