//
//  XPJHRecorderListViewController.m
//  YJOTC
//
//  Created by l on 2019/1/3.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPJHRecorderListViewController.h"
#import "SegmentContainer.h"
#import "XPJHChildListViewController.h"
@interface XPJHRecorderListViewController ()<SegmentContainerDelegate>
@property (nonatomic,strong)SegmentContainer *container;
@property (nonatomic,strong)NSArray *titleArray;

@end

@implementation XPJHRecorderListViewController

- (SegmentContainer *)container {
    if (!_container) {
        _container = [[SegmentContainer alloc] initWithFrame:CGRectMake(0,kNavigationBarHeight, kScreenW,kScreenHeight- kNavigationBarHeight)];
        _container.parentVC = self;
        _container.delegate = self;
        _container.averageSegmentation = NO;
        _container.titleFont = [PFRegularFont(16) fontWithBold];
        _container.titleNormalColor = kColorFromStr(@"#54CDC0");
        _container.titleSelectedColor = kColorFromStr(@"#FFFFFF");
        _container.indicatorColor = kColorFromStr(@"#FFD401");
        _container.indicatorColor = kClearColor;
        _container.indicatorOffset = 20;
        _container.containerBackgroundColor = kColorFromStr(@"#F4F4F4");
        _container.containerBackgroundColor = kWhiteColor;
        _container.topBar.backgroundColor = kColorFromStr(@"#225686");
//        _container.containerView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _container;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"C_basic_bouns_juorecor");
    self.titleArray = @[kLocat(@"C_basic_recorlist_nav01"),kLocat(@"C_basic_recorlist_nav02"),kLocat(@"C_basic_recorlist_nav03")].mutableCopy;
    [self.view addSubview:self.container];
    // Do any additional setup after loading the view.
}

- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.titleArray.count;
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    
    NSString *type = ConvertToString(@(index));
    XPJHChildListViewController *list = [[XPJHChildListViewController alloc]initWithType:type];
    return list;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    return [self.titleArray objectAtIndex:index];
}

@end
