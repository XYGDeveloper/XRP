//
//  TPWalletAccountBookController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletAccountBookController.h"
#import "TPWalletAccountListController.h"

@interface TPWalletAccountBookController ()<ZJScrollPageViewDelegate>
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property(nonatomic,strong)NSArray *titles;

@end

@implementation TPWalletAccountBookController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

-(void)setupUI
{
    self.title = kLocat(@"x_xzhangben");
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    style.scrollLineColor = kNaviColor;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.scrollLineHeight = 2;
    style.titleFont = PFRegularFont(16);
    style.normalTitleColor = k222222Color;
    style.selectedTitleColor = kNaviColor;
    style.autoAdjustTitlesWidth = YES;
    style.adjustCoverOrLineWidth = YES;
    style.gradualChangeTitleColor = YES;
    style.segmentHeight = 44;
    //    self.titles = @[@"标签",@"用户",@"文章",@"资讯"];
    style.scrollTitle = NO;
    
    self.titles = @[kLocat(@"R_All"),kLocat(@"W_income"),kLocat(@"W_expend")];
    
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-kNavigationBarHeight) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    //    _scrollPageView.contentView.collectionView.bounces = NO;
    _scrollPageView.segmentView.backgroundColor =  kTableColor;
    
    _scrollPageView.contentView.backgroundColor = kTableColor;
    _scrollPageView.contentView.collectionView.backgroundColor = kTableColor;
    [self.view addSubview:_scrollPageView];
    
}


-(NSInteger)numberOfChildViewControllers
{
    return self.titles.count;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    TPWalletAccountListController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [TPWalletAccountListController new];
    }
    
    childVc.type = index;
    
    return childVc;
}


@end
