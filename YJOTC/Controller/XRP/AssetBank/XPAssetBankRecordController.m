
//
//  XPAssetBankRecordController.m
//  YJOTC
//
//  Created by Roy on 2018/12/21.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAssetBankRecordController.h"
#import "XPAssetBankRecordListController.h"

@interface XPAssetBankRecordController ()<ZJScrollPageViewDelegate>
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property(nonatomic,strong)NSArray *titles;

@end

@implementation XPAssetBankRecordController

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
    self.title = kLocat(@"z_record");
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = NO;
    style.scrollLineColor = kNaviColor;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.scrollLineHeight = 2;
    style.titleFont = PFRegularFont(16);
    style.normalTitleColor = kColorFromStr(@"#54CDC0");
    style.selectedTitleColor = kWhiteColor;
    style.autoAdjustTitlesWidth = YES;
    style.adjustCoverOrLineWidth = YES;
    style.gradualChangeTitleColor = YES;
    style.segmentHeight = 44;
    //    self.titles = @[@"标签",@"用户",@"文章",@"资讯"];
    style.scrollTitle = YES;
    style.contentViewBounces = NO;

//    self.titles = @[kLocat(@"R_All"),kLocat(@"z_Shoulizhong"),kLocat(@"z_shengxizhong"),kLocat(@"z_yishengxi"),kLocat(@"z_yishixiao")];
    self.titles = @[kLocat(@"R_All"),kLocat(@"z_shengxizhong"),kLocat(@"z_yishengxi"),kLocat(@"z_yishixiao")];

    
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-kNavigationBarHeight) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    //    _scrollPageView.contentView.collectionView.bounces = NO;
    _scrollPageView.segmentView.backgroundColor =  kColorFromStr(@"#225686");
    
    _scrollPageView.contentView.backgroundColor = kTableColor;
    _scrollPageView.contentView.collectionView.backgroundColor = kTableColor;
    [self.view addSubview:_scrollPageView];
    
}
-(NSInteger)numberOfChildViewControllers
{
    return self.titles.count;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    XPAssetBankRecordListController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [XPAssetBankRecordListController new];
    }
    
    childVc.type = index;
    
    return childVc;
}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}


@end
