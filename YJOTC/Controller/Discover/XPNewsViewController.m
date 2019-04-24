//
//  XPNewsViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPNewsViewController.h"
#import "HBBaseTableViewDataSource.h"
#import "XPNewsCell.h"
#import "YWEmptyDataSetDataSource.h"
#import "XPNewsModel+Request.h"
#import "NSObject+SVProgressHUD.h"
#import "UIViewController+HBLoadingView.h"

@interface XPNewsViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HBBaseTableViewDataSource *tableViewDataSource;

@property (nonatomic, assign) BOOL isFetchInProgress;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSArray<XPNewsModel *> *models;

@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;

@end

@implementation XPNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = kLocat(@"news");
    
    self.tableViewDataSource = [[HBBaseTableViewDataSource alloc] initWithItems:self.models cellIdentifier:@"XPNewsCell" cellConfigureBlock:^(XPNewsCell  *_Nonnull cell, XPNewsModel  *_Nonnull model) {
        cell.model = model;
    }];
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    self.tableView.mj_footer.hidden = YES;
    
    self.emptyDataSetDataSource = [[YWEmptyDataSetDataSource alloc] initWithScrollView:self.tableView];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.emptyDataSetDelegate = self.emptyDataSetDataSource;
    [self _firstRequestData];
    [self addLeftBarButtonWithImage:kImageFromStr(@"lay_icon_user") action:@selector(avatarAction)];

}
-(void)avatarAction
{
    if (isInvalid) {
        [self gotoLoginVC];
        return;
    }
    XPMineManager *v =  [[XPMineManager alloc]initWithFrame:kRectMake(0, kScreenH, kScreenW, kScreenH - kStatusBarHeight)];
    [UIView animateWithDuration:0.25 animations:^{
        v.frame = kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight);
    }];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.view addSubview:v];
    
}
#pragma mark - Public

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Discover" bundle:nil] instantiateViewControllerWithIdentifier:@"XPNewsViewController"];
}

#pragma mark - Private

- (void)_firstRequestData {
    [self showLoadingView];
    [self _refreshData];
}

- (void)_refreshData {
    [self _requestRecordsWithIsRefresh:YES];
}

- (void)_loadData {
    [self _requestRecordsWithIsRefresh:NO];
}

static NSInteger const kPageSize = 10;
- (void)_requestRecordsWithIsRefresh:(BOOL)isRefresh {
    if ([Utilities netWorkUnAvalible]) {
        [self showInfoWithMessage:kLocat(@"U_checktourNetwork")];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (self.isFetchInProgress) {
        return;
    }
    
    self.isFetchInProgress = YES;
    
    if (isRefresh) {
        self.currentPage = 1;
    }
   
    
    [XPNewsModel requestNewsModelsWithPage:self.currentPage pageSize:kPageSize success:^(NSArray<XPNewsModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj) {
        self.currentPage++;
        self.noMoreData = array.count < kPageSize;
        self.isFetchInProgress = NO;
        if (isRefresh) {
            self.models = array;
        } else {
            if (array.count > 0) {
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:self.models];
                [tmp addObjectsFromArray:array];
                self.models = tmp.copy;
            }
        }
        [self hideLoadingView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.emptyDataSetDataSource.title = kLocat(@"empty_msg");
    } failure:^(NSError * _Nonnull error) {
        self.emptyDataSetDataSource.title = kLocat(error.localizedDescription);
        [self hideLoadingView];
        self.isFetchInProgress = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showInfoWithMessage:error.localizedDescription];
    }];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XPNewsModel *model = [self.tableViewDataSource itemAtIndexPath:indexPath];
    BaseWebViewController *vc = [BaseWebViewController webViewControllerWithURIString:[NSString stringWithFormat:@"/mobile/news/detail/id/%@", model.article_id] title:model.title];
    vc.showNaviBar = NO;
    kNavPush(vc);
}

#pragma mark - Setters

- (void)setModels:(NSArray<XPNewsModel *> *)models {
    _models = models;
    self.tableViewDataSource.items = models;
    self.tableView.mj_footer.hidden = models.count < 1;
    [self.tableView reloadData];
}

- (void)setNoMoreData:(BOOL)noMoreData {
    _noMoreData = noMoreData;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_noMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self.tableView.mj_footer setNeedsDisplay];
    });
    
}

@end
