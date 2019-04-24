//
//  XPShrinkAnimatedView.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/13.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPShrinkAnimatedView.h"
#import "UIView+Animation.h"

@implementation XPShrinkAnimatedView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self shrinkAnimated];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resetAnimated];
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resetAnimated];
    [super touchesEnded:touches withEvent:event];
}

@end
