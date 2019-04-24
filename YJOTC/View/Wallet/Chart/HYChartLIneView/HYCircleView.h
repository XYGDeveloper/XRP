//
//  LKCircleView.h
//  ChartView
//
//  Created by DengHengYu on 16/10/9.
//  Copyright © 2016年 YunJing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCircleView : UIView
/**
 *   边框宽度
 */
@property (nonatomic, assign) CGFloat borderWidth;
/**
 *   边框宽度
 */
@property (nonatomic ,strong) UIColor *borderColor;
/**
 *   创建圆环
 * 
 *   @prama center 圆环的中心点坐标
 *   @prama radius 圆环的半径
 */
- (instancetype)initWitnCenter:(CGPoint)center radius:(CGFloat)radius;
@end
