//
//  XPDiscoverSegmentedView.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XPDiscoverSegmentedViewIndexChangedBlock)(NSInteger selectedIndex);

@interface XPDiscoverSegmentedView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) XPDiscoverSegmentedViewIndexChangedBlock indexChangedBlock;

- (void)animatieWithProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
