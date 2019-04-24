//
//  XPInnovationTableViewCell.h
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XPInnovationModel;

@interface XPInnovationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIImageView *img;

- (void)refreshWithModel:(XPInnovationModel *)model;
- (void)refreshWithModel1:(XPInnovationModel *)model1;
- (void)refreshWithModel2:(XPInnovationModel *)model1;
@end

NS_ASSUME_NONNULL_END
