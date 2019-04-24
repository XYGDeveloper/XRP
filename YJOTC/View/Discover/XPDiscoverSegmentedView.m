//
//  XPDiscoverSegmentedView.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPDiscoverSegmentedView.h"

@interface XPDiscoverSegmentedView ()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) NSArray<UIButton *> *buttons;

@property (nonatomic, strong) CAShapeLayer *indicatorLayer;

@end

static CGFloat const kButtonWidth = 80.;
static CGFloat const kButtonHeight = 30.;
static CGFloat const kButtonPad = 12.;

@implementation XPDiscoverSegmentedView

#pragma mark - Lifecycle

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        [self _commonInit];
//    }
//    return self;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _commonInit];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self _commonInit];
//    }
//    return self;
//}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kButtonWidth * 2 + kButtonPad, kButtonHeight);
}

#pragma mark - Private

- (void)_commonInit {
    
    _selectedIndex = 0;
    
    self.frame = CGRectMake(0, 0, kButtonWidth * 2 + kButtonPad, kButtonHeight);
    
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight) title:@"Mood" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:18.] titleAlignment:UIControlContentHorizontalAlignmentCenter];
    [_leftButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kButtonWidth + kButtonPad, 0, kButtonWidth, kButtonHeight) title:@"News" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:18.] titleAlignment:UIControlContentHorizontalAlignmentCenter];
    [_rightButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _buttons = @[_leftButton, _rightButton];
    
    _indicatorLayer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_leftButton.frame cornerRadius:4.];
    _indicatorLayer.path = path.CGPath;
    _indicatorLayer.fillColor = kColorFromStr(@"#3284CA").CGColor;
    
    [self.layer addSublayer:_indicatorLayer];
    [self addSubview:_leftButton];
    [self addSubview:_rightButton];
}

- (UIButton *)buttonAdIndex:(NSInteger)index {
    if (index < self.buttons.count) {
        return self.buttons[index];
    }
    return nil;
}

- (NSInteger)indexForButton:(UIButton *)button {
    return [self.buttons indexOfObject:button];
}

#pragma mark - Actions

- (void)tapAction:(UIButton *)sender {
    self.selectedIndex = [self indexForButton:sender];
}

#pragma mark - Public

- (void)animatieWithProgress:(CGFloat)progress {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGPoint point = self.indicatorLayer.position;
    CGFloat positionX = progress * (kButtonWidth + kButtonPad);
    point.x = positionX;
    
    self.indicatorLayer.position = point;
    [CATransaction commit];
}

#pragma mark - Setters

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (self.indexChangedBlock) {
        self.indexChangedBlock(selectedIndex);
    }
}


@end
