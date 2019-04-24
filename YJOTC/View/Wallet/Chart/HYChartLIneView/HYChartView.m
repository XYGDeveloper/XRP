//
//  HYChartView.m
//  ChartView
//
//  Created by DengHengYu on 16/10/8.
//  Copyright © 2016年 YunJing. All rights reserved.
//
/**
 *   Y轴刻度标签 与 Y坐标轴的间距
 */
#define YMARKLABEL_YAXISSPACING 10.F
/**
 *   X轴刻度标签 与 X坐标轴的间距
 */
#define XMARKLABEL_XAXISSPACING 10.F
/**
 *   Y轴刻度标签的宽度
 */
#define YMARKLABEL_WIDTH 25.F
/**
 *   Y轴刻度标签的高度
 */
#define YMARKLABEL_HEIGTH 16.F
/**
 *   X轴刻度标签的宽度
 */
#define XMARKLABEL_WIDTH 40.F
/**
 *   X轴刻度标签的高度
 */
#define XMARKLABEL_HEIGHT 16.F
/**
 *   X轴刻度标签距视图 底部 的间距
 */
#define XMARKLABEL_TO_BOTTOM 20.F
/**
 *   Y轴刻度标签距视图 左边 的间距
 */
#define YMARKLABEL_TO_RIGHT 0.F
/**
 *   与 Y轴 平行的刻度线条数
 */
#define YLINE_NUMBER 7
/**
 *   与 X轴 平行的刻度线条数
 */
#define XLINE_NUMBER 5

/**
 *   视图上圆环的基础tag值
 */
#define CIRCLEVIEW_BASE_TAG 200

/**
 *   显示y刻度值得按钮的基础tag值
 */
#define POPBTN_BASE_TAG 300

#import "HYChartView.h"
#import "HYCircleView.h"

@interface HYChartView () {
    
    /**
     *   视图宽度
     */
    CGFloat _viewWidth;
    
    /**
     *   视图高度
     */
    CGFloat _viewHeigt;
    
    /**
     *   记录上次点击的圆环的下标
     */
    NSInteger _lastSelectedIndex;
}

/**
 *   Y轴 单位长度(与坐标系视图的高度和y轴刻度标签的个数相关)
 */
@property (nonatomic, assign) CGFloat yUnitLength;
@property (nonatomic ,strong) NSArray *yValuesArr;
@property (nonatomic, assign) CGFloat maxYValue;
@property (nonatomic ,strong) NSMutableArray *pointArrM;
@end


@implementation HYChartView

- (instancetype)initWithFrame:(CGRect)frame xValues:(NSArray *)xValues yValues:(NSArray *)yValues shadowEnabled:(BOOL)shadowEnabled{
    self  = [super initWithFrame:frame];
    if (self) {
        self.shadowEnabled = shadowEnabled;
        _lastSelectedIndex = -1;
        _viewWidth = frame.size.width;
        _viewHeigt = frame.size.height;
        self.yValuesArr = yValues;
        [self setupYMarkTitlesWithYValues:yValues ];
        [self setupXmarkTitlesWithXValues:xValues];
       
        CGFloat origin_x = YMARKLABEL_TO_RIGHT + YMARKLABEL_WIDTH + YMARKLABEL_YAXISSPACING;
        CGFloat origin_y = _viewHeigt - ( XMARKLABEL_TO_BOTTOM + XMARKLABEL_HEIGHT + XMARKLABEL_XAXISSPACING);
        
        self.originPoint = CGPointMake(origin_x, origin_y);
       
    }
    return self;
}



- (void)setShowYMarkTitles:(BOOL)showYMarkTitles {
    _showYMarkTitles = showYMarkTitles;
    if (_showYMarkTitles) {
        [self setupYMarkLabs];
    }
}

- (void)getMaxYValueWithYValues:(NSArray *)yValues {
    CGFloat max = 0;
    for (int i = 0; i < yValues.count; i++) {
        
        max = MAX(max, [yValues[i] floatValue]);
    }
    self.maxYValue = max;
}

- (void)setupPointArr {
    
    self.pointArrM = [NSMutableArray array];
    for (int i = 0; i < self.yValuesArr.count; i++ ) {
        CGFloat value = [self.yValuesArr[i] floatValue];
        CGFloat percent = value/self.maxYValue;
        
        
        CGFloat y = _viewHeigt - XMARKLABEL_TO_BOTTOM - XMARKLABEL_HEIGHT - XMARKLABEL_XAXISSPACING - self.yUnitLength * 4 *percent;
        if (isnan(y)) {
            y = 20;
        }
        
        
        CGFloat x = self.originPoint.x + i * self.xUnitLength;
        
        CGPoint point = CGPointMake(x, y);
        [self.pointArrM addObject:[NSValue valueWithCGPoint:point]];
    }
    
    
}

- (void)drawChart {
    
    self.yUnitLength = (_viewHeigt - XMARKLABEL_TO_BOTTOM - XMARKLABEL_HEIGHT - XMARKLABEL_XAXISSPACING - 20) / 4.f;
   
    if (self.xUnitLength == 0) {
        self.xUnitLength = (_viewWidth - (YMARKLABEL_TO_RIGHT + YMARKLABEL_WIDTH + YMARKLABEL_YAXISSPACING) * 2  )/(YLINE_NUMBER - 1);
    }
    
   
    [self setupXMarkLabs];
    
//    [self drawYAxisLine];
    [self drawXAxisLine];
    
    [self drawChartLine];
    if (self.shadowEnabled) {
         [self drawGradient];
    }
    [self setupCircleViews];
}

- (void)reloadDatas {
    [self clearView];
    [self drawChart];
}

- (void)setupYMarkLabs {
    
    for (int i = 0; i < self.yMarkTitles.count; i ++) {
        
        UILabel *yMarkLab = [[UILabel alloc] initWithFrame:CGRectMake(YMARKLABEL_TO_RIGHT, self.originPoint.y - YMARKLABEL_HEIGTH/2 - i * self.yUnitLength, YMARKLABEL_WIDTH, YMARKLABEL_HEIGTH)];
        yMarkLab.textAlignment = NSTextAlignmentRight;
        yMarkLab.font = [UIFont systemFontOfSize:10.0];
        yMarkLab.textColor = DEF_HEXColor(0x7D7D7D);
        yMarkLab.text = [NSString stringWithFormat:@"%@", self.yMarkTitles[i]];
        [self addSubview:yMarkLab];
    }
}

- (void)setupXMarkLabs {
   
    for (int i = 0; i < self.xMarkTitles.count; i ++) {
        
        UILabel *xMarkLab = [[UILabel alloc] initWithFrame:CGRectMake(self.originPoint.x - XMARKLABEL_WIDTH / 2 + i * self.xUnitLength, _viewHeigt - XMARKLABEL_TO_BOTTOM - XMARKLABEL_HEIGHT, XMARKLABEL_WIDTH, XMARKLABEL_HEIGHT)];
        xMarkLab.textAlignment = NSTextAlignmentCenter;
        xMarkLab.font = [UIFont systemFontOfSize:10.0];
        xMarkLab.textColor = DEF_HEXColor(0x7D7D7D);
        xMarkLab.text = [NSString stringWithFormat:@"%@", self.xMarkTitles[i]];
        [self addSubview:xMarkLab];
    }
}


- (void)drawYAxisLine {
  
    CAShapeLayer *yAxisLayer = [CAShapeLayer layer];
   // [yAxisLayer setLineDashPattern:@[@1,@1.5]];
    yAxisLayer.lineWidth = 0.5;
    yAxisLayer.strokeColor =[UIColor colorWithRed:222/255.0f green:222/255.0f blue:222/255.0f alpha:1.0f].CGColor;
    yAxisLayer.strokeColor =kDarkGrayColor.CGColor;

    UIBezierPath *yAxisPath = [[UIBezierPath alloc] init];
    for (int i = 0; i < YLINE_NUMBER; i++) {
        
        [yAxisPath moveToPoint:CGPointMake(self.originPoint.x + i*self.xUnitLength, self.originPoint.y )];
        [yAxisPath addLineToPoint:CGPointMake(self.originPoint.x + i*self.xUnitLength, self.originPoint.y - (XLINE_NUMBER - 1) * self.yUnitLength - 10)];
        yAxisLayer.path = yAxisPath.CGPath;
        
    }
    [self.layer addSublayer:yAxisLayer];
    
}

- (void)drawXAxisLine {
    
    CAShapeLayer *xAxisLayer = [CAShapeLayer layer];
    //[xAxisLayer setLineDashPattern:@[@1,@1.5]];
    xAxisLayer.lineWidth = 0.5;
    xAxisLayer.strokeColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1.00].CGColor;
//    xAxisLayer.strokeColor = kDarkGrayColor.CGColor;

    UIBezierPath *xAxisPath = [UIBezierPath bezierPath];
    for (int i = 0; i < XLINE_NUMBER; i ++) {
        [xAxisPath moveToPoint:CGPointMake(self.originPoint.x, self.originPoint.y - i*self.yUnitLength)];
        [xAxisPath addLineToPoint:CGPointMake(self.originPoint.x  + (YLINE_NUMBER - 1)* _xUnitLength + 10, self.originPoint.y - i*self.yUnitLength)];
        xAxisLayer.path = xAxisPath.CGPath;
    }
    
    [self.layer addSublayer:xAxisLayer];
}

- (void)drawChartLine {
    UIBezierPath *pAxisPath = [UIBezierPath bezierPath];
    self.pointArrM = [NSMutableArray array];
    for (int i = 0; i < self.yValuesArr.count; i++ ) {
        CGFloat value = [self.yValuesArr[i] floatValue];
        CGFloat percent = value/self.maxYValue;
      
        
        CGFloat y = _viewHeigt - XMARKLABEL_TO_BOTTOM - XMARKLABEL_HEIGHT - XMARKLABEL_XAXISSPACING - self.yUnitLength * 4 *percent;
        
        CGFloat x = self.originPoint.x + i * self.xUnitLength;

        CGPoint point = CGPointMake(x, y);
        [self.pointArrM addObject:[NSValue valueWithCGPoint:point]];
        
        if (i == 0) {
            [pAxisPath moveToPoint:point];
        } else {
            [pAxisPath addLineToPoint:point];
        }
    }
   
    CAShapeLayer *pAxisLayer = [CAShapeLayer layer];
    pAxisLayer.lineWidth = 2.f;
    pAxisLayer.strokeColor = [kYellowColor CGColor];
    pAxisLayer.fillColor = [UIColor clearColor].CGColor;
    pAxisLayer.path = pAxisPath.CGPath;
    [self.layer addSublayer:pAxisLayer];
}

-(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

- (void)drawGradient {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0.89 green:0.76 blue:0.65 alpha:1.00].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor];
    gradientLayer.locations = @[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    UIBezierPath *gradientPath = [UIBezierPath bezierPath];
    [gradientPath moveToPoint:CGPointMake(self.originPoint.x, self.originPoint.y)];
    for (int i = 0; i < self.pointArrM.count; i++) {
        
        [gradientPath addLineToPoint:[self.pointArrM[i] CGPointValue]];
    }
    CGPoint endPoint = [[self.pointArrM lastObject] CGPointValue];
    endPoint = CGPointMake(endPoint.x , self.originPoint.y);
    [gradientPath addLineToPoint:endPoint];
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = gradientPath.CGPath;
    gradientLayer.mask = arc;
    [self.layer addSublayer:gradientLayer];
}

- (void)setupCircleViews {
    for (int i = 0; i < self.pointArrM.count; i++) {
        
        
        HYCircleView *circleView = [[HYCircleView alloc] initWitnCenter:[self.pointArrM[i] CGPointValue] radius:5];
        circleView.tag = i + CIRCLEVIEW_BASE_TAG;
        circleView.borderColor = [UIColor colorWithRed:0.88 green:0.44 blue:0.22 alpha:1.00];
        circleView.borderWidth = 0.5;
        [self addSubview:circleView];
        UITapGestureRecognizer *gesutre = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesutreAction:)];
        [circleView addGestureRecognizer:gesutre];
    }
}

- (void)gesutreAction:(UITapGestureRecognizer *)regcognizer {
    
    NSInteger index = regcognizer.view.tag - CIRCLEVIEW_BASE_TAG;
    if (index != -1) {
    
        HYCircleView *lastCircleView = (HYCircleView *)[self viewWithTag:_lastSelectedIndex + CIRCLEVIEW_BASE_TAG];
        lastCircleView.borderWidth = 1;
        
        UIButton *lastPopBtn = (UIButton *)[self viewWithTag:_lastSelectedIndex + POPBTN_BASE_TAG];
        [lastPopBtn removeFromSuperview];
    }
    
    HYCircleView *circleView = (HYCircleView *)[self viewWithTag:index + CIRCLEVIEW_BASE_TAG];
    circleView.borderWidth = 2;
    
    CGPoint point = [self.pointArrM[index] CGPointValue];
    
    if (isnan(point.y)) {
        point.y = 20;
    }
    
    UIButton *popBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    popBtn.tag = index + POPBTN_BASE_TAG;
    NSString *titleStr = self.yValuesArr[index];
    CGFloat width = [self caculateButtonWidthWith:titleStr];
    popBtn.frame = CGRectMake(point.x - 0.5 * (width + 10), point.y - 22, width + 10, 17);
    [popBtn setTitleColor:k666666Color forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"icon_shouyi_tishi.png"];
    
 
    UIImage *stretchImage = [self stretchLeftAndRightWithContainerSize:CGSizeMake(popBtn.frame.size.width,popBtn.frame.size.height ) image:image];
    
    [popBtn setBackgroundImage:stretchImage forState:UIControlStateNormal];
    
    [popBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    popBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [popBtn setTitle:[NSString stringWithFormat:@"%@",titleStr] forState:(UIControlStateNormal)];
    [self addSubview:popBtn];
    
    _lastSelectedIndex = index;
}

- (void)clearView {
    [self removeAllSubLabs];
    [self removeAllSubLayers];
}

- (void)removeAllSubLabs {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:UILabel.class]) {
            [(UILabel *)view removeFromSuperview];
        }
    }
}

- (void)removeAllSubLayers {
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}

- (void)setupYMarkTitlesWithYValues:(NSArray *)yValues {
    CGFloat max = 0;
    for (int i = 0; i < yValues.count; i++) {
        
        max = MAX(max, [yValues[i] floatValue]);
    }
    
    NSMutableArray *tempArrM = [NSMutableArray array];
    [tempArrM addObject:@"0.0"];
    [tempArrM addObject:[NSString stringWithFormat:@"%.1f",max*(1/4.0)]];
    [tempArrM addObject:[NSString stringWithFormat:@"%.1f",max*(2/4.0)]];
    [tempArrM addObject:[NSString stringWithFormat:@"%.1f",max*(3/4.0)]];
    [tempArrM addObject:[NSString stringWithFormat:@"%.1f",max*(4/4.0)]];
    self.maxYValue = max;
    self.yMarkTitles = tempArrM;
}

- (void)setupXmarkTitlesWithXValues:(NSArray *)xValues {
    
    self.xMarkTitles = xValues;
}

- (CGFloat)caculateButtonWidthWith:(NSString *)title {
    return [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.f]} context:nil].size.width;
}


#pragma mark - 图片拉伸方法 (之拉伸图片的两边中间不拉伸)

- (UIImage *)stretchLeftAndRightWithContainerSize:(CGSize)size image:(UIImage *)theImage
{
    CGSize imageSize = theImage.size;
    CGSize bgSize = size;
    
    //1.第一次拉伸右边 保护左边
    UIImage *image = [theImage stretchableImageWithLeftCapWidth:imageSize.width *0.8 topCapHeight:imageSize.height * 0.5];
    
    //第一次拉伸的距离之后图片总宽度
    CGFloat tempWidth = (bgSize.width)/2 + imageSize.width/2;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tempWidth, imageSize.height), NO, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, tempWidth, bgSize.height)];
    
    //拿到拉伸过的图片
    UIImage *firstStrechImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //2.第二次拉伸左边 保护右边
    UIImage *secondStrechImage = [firstStrechImage stretchableImageWithLeftCapWidth:firstStrechImage.size.width *0.1 topCapHeight:firstStrechImage.size.height*0.5];
    
    return secondStrechImage;
}

@end
