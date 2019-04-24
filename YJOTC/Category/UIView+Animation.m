//
//  UIView+Animation.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/13.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)resetAnimated {
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)shrinkAnimated {
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }];
}

@end
