//
//  YTTradeViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeViewController.h"
#import "YTBuyAndSellDetailTableViewController.h"

#import "TPNewsDrawerController.h"

@interface YTTradeViewController ()


@property (nonatomic, strong) YTBuyAndSellDetailTableViewController *buyDetailTableViewController;

@end

@implementation YTTradeViewController

#pragma mark - Lifecycle

- (instancetype)initWithModel:(ListModel *)model isTypeOfBuy:(BOOL)isTypeOfBuy {
    self = [super init];
    if (self) {
        self.currentListModel = model;
        self.isTypeOfBuy = isTypeOfBuy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.currentListModel comcurrencyName];

    self.buyDetailTableViewController = [YTBuyAndSellDetailTableViewController fromStoryboard];
    [self _addChildVC:self.buyDetailTableViewController];
    self.buyDetailTableViewController.model = self.currentListModel;
    self.buyDetailTableViewController.isTypeOfBuy = self.isTypeOfBuy;
    self.enablePanGesture = NO;

     [self addRightTwoBarButtonsWithFirstImage:kImageFromStr(@"hq_icon_listno") firstAction:@selector(showDrawer) secondImage:kImageFromStr(@"hq_icon_hqt") secondAction:@selector(showKline)];
}

-(void)showKline
{
    [self hideKeyBoard];
    kNavPop;
}
-(void)showDrawer
{
    [self hideKeyBoard];
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:kCWSCREENWIDTH * 0.86 maskAlpha:0.4 scaleY:1.0 direction:CWDrawerTransitionFromRight backImage:nil];
    TPNewsDrawerController *vc = [[TPNewsDrawerController alloc] init];
    YJBaseNavController *baseVC = [[YJBaseNavController alloc] initWithRootViewController:vc];
    [self cw_showDrawerViewController:baseVC animationType:CWDrawerAnimationTypeDefault configuration:conf];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.buyDetailTableViewController.view.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
}

#pragma mark - Private
- (void)_addChildVC:(UIViewController *)vc {
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}


@end
