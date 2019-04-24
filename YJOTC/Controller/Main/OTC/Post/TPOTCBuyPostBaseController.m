//
//  TPOTCBuyPostBaseController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyPostBaseController.h"
#import "TPOTCPostViewController.h"


@interface TPOTCBuyPostBaseController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation TPOTCBuyPostBaseController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupUI];
}
-(void)setupUI
{
    self.enablePanGesture = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = NO;
    style.scrollLineColor = kColorFromStr(@"#11B1ED");
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.scrollLineHeight = 2;
    style.titleFont = PFRegularFont(16);
    style.normalTitleColor = k222222Color;
    style.selectedTitleColor = kColorFromStr(@"#066B98");
    style.autoAdjustTitlesWidth = YES;
    style.adjustCoverOrLineWidth = YES;
    style.scrollContentView = NO;
    
    style.segmentHeight = 44;
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.currencyArr.count];
    
    for (TPCurrencyModel *model in self.currencyArr) {
        [titles addObject:model.currencyName];
    }
//
//
//    self.titles = @[@"BTC",@"ETH",@"USDT",@"BCB"];
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - kNavigationBarHeight) segmentStyle:style titles:titles parentViewController:self delegate:self];
    //    _scrollPageView.contentView.collectionView.bounces = NO;
    _scrollPageView.segmentView.backgroundColor = kWhiteColor;
    _scrollPageView.contentView.backgroundColor = kWhiteColor;
    _scrollPageView.contentView.collectionView.backgroundColor = kWhiteColor;
    [self.view addSubview:_scrollPageView];
    
    
}

-(NSInteger)numberOfChildViewControllers
{
    return self.currencyArr.count;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    TPOTCPostViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [TPOTCPostViewController new];
    }
    
    childVc.model = self.currencyArr[index];
    childVc.type = TPOTCPostViewControllerTypeBuy;
    return childVc;
}




@end
