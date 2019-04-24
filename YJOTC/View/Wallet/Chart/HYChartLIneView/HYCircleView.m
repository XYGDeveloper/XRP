//
//  LKCircleView.m
//  ChartView
//
//  Created by DengHengYu on 16/10/9.
//  Copyright © 2016年 YunJing. All rights reserved.
//

#import "HYCircleView.h"

@implementation HYCircleView


- (instancetype)initWitnCenter:(CGPoint)center radius:(CGFloat)radius {
    self = [super init];
    if (self) {
        
        if (isnan(center.y)) {
            self.center = CGPointMake(center.x, 20);
        }else{
            self.center = center;
        }

        self.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
      //  self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(44.0, bounds.size.width);
    CGFloat heightDelta = MAX(44.0, bounds.size.height);
    bounds = CGRectInset(bounds, -0.5 *widthDelta, -0.5*heightDelta);
    return CGRectContainsPoint(bounds, point);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
