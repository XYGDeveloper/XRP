//
//  XPMoodNineImageCell.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMoodBasicCell.h"

@class XPMoodNineImageCell;
@protocol XPMoodImageCellDelegate <NSObject>

- (void)moodImageCell:(XPMoodNineImageCell *)cell index:(NSInteger)index image:(UIImage *)image attachments:(NSArray<NSString *> *)attachments;

@end


NS_ASSUME_NONNULL_BEGIN

@interface XPMoodNineImageCell : XPMoodBasicCell

@property (nonatomic, weak) id<XPMoodImageCellDelegate> imageCellDelegate;

@end

NS_ASSUME_NONNULL_END
