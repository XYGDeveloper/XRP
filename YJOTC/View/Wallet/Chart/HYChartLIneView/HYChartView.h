//
//  HYChartView.h
//  ChartView
//
//  Created by DengHengYu on 16/10/8.
//  Copyright © 2016年 YunJing. All rights reserved.
//
#define DEF_HEXColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DEF_NAVIGATIONBAR_COLOR [UIColor colorWithRed:190.0 / 255.0 green:48.0 / 255.0 blue:48.0 / 255.0 alpha:1.0]

//#define DEF_NAVIGATIONBAR_COLOR [UIColor colorWithRed:0.89 green:0.76 blue:0.65 alpha:1.00]

#import <UIKit/UIKit.h>

@interface HYChartView : UIView
/**
 *   Y轴 刻度标签
 */
@property (nonatomic ,strong) NSArray *yMarkTitles;
/**
 *   X轴 刻度标签
 */
@property (nonatomic ,strong) NSArray *xMarkTitles;
/**
 *   X轴 单位长度
 */
@property (nonatomic, assign) CGFloat xUnitLength;
/**
 *   坐标原点
 */
@property (nonatomic, assign) CGPoint originPoint;
/**
 *   Y轴长度
 */
@property (nonatomic, assign) CGFloat yAxisLength;
/**
 *   X轴长度
 */
@property (nonatomic, assign) CGFloat xAxisLength;

@property (nonatomic, assign) BOOL shadowEnabled;

@property (nonatomic, assign) BOOL showYMarkTitles;

/**
 *   @prama frame 视图坐标
 *   @prama xValues 横坐标标题数组
 *   @prame yValues 纵坐标标题数组
 */
- (instancetype)initWithFrame:(CGRect)frame xValues:(NSArray *)xValues yValues:(NSArray *)yValues shadowEnabled:(BOOL)shadowEnabled;
/**
 *   绘制视图
 */

- (void)drawChart;
/**
 *   重置视图
 */
- (void)reloadDatas;

@end
