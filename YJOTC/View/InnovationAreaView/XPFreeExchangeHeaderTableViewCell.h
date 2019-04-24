//
//  XPFreeExchangeHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XPGetGACModel;
@interface XPFreeExchangeHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *freezeLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *freezeContentlabel;
@property (weak, nonatomic) IBOutlet UILabel *middleContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightContentLabel;

- (void)refreshWithModel:(XPGetGACModel *)model;


@end

NS_ASSUME_NONNULL_END
