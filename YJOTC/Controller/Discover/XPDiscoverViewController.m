//
//  XPDiscoverViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPDiscoverViewController.h"
#import "XPNewsViewController.h"
#import "XPMoodViewController.h"
#import "XPDiscoverSegmentedView.h"

@interface XPDiscoverViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XPNewsViewController *newsVC;
@property (nonatomic, strong) XPMoodViewController *moodVC;
@property (nonatomic, strong) XPDiscoverSegmentedView *discoverSegmentedView;

@end

@implementation XPDiscoverViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupUI];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    self.scrollView.contentSize = CGSizeMake(self.childViewControllers.count * width, 0);
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = idx * width;
        obj.view.frame = frame;
    }];
}

#pragma mark - Private

- (void)_setupUI {
    self.view.backgroundColor = kColorFromStr(@"F4F4F4");
    [self.view addSubview:self.scrollView];
    [self _addChildeVC:self.moodVC];
    [self _addChildeVC:self.newsVC];
    self.navigationItem.titleView = self.discoverSegmentedView;
}

- (void)_addChildeVC:(UIViewController *)vc {
    [self addChildViewController:vc];
//    vc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat progress = offsetX / kScreenW;
    [self.discoverSegmentedView animatieWithProgress:progress];
}

#pragma mark - Getters && Setters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (XPNewsViewController *)newsVC {
    if (!_newsVC) {
        _newsVC = [XPNewsViewController fromStoryboard];
    }
    return _newsVC;
}

- (XPMoodViewController *)moodVC {
    if (!_moodVC) {
        _moodVC = [XPMoodViewController fromStoryboard];
    }
    return _moodVC;
}

- (XPDiscoverSegmentedView *)discoverSegmentedView {
    if (!_discoverSegmentedView) {
        _discoverSegmentedView = [XPDiscoverSegmentedView new];
        __weak typeof(self) weakSelf = self;
        _discoverSegmentedView.indexChangedBlock = ^(NSInteger selectedIndex) {
            [weakSelf.scrollView setContentOffset:CGPointMake(selectedIndex * kScreenW, 0) animated:YES];
        };
    }
    return _discoverSegmentedView;
}

@end
