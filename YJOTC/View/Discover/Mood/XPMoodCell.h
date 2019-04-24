//
//  XPMoodCell.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWDynamicModel, XPMoodCellLayout;
@interface XPMoodCell : UITableViewCell

- (void)configureCellWith:(YWDynamicModel *)model layout:(XPMoodCellLayout *)layout;

+ (CGFloat)heightOfModel:(YWDynamicModel *)model;

@end
