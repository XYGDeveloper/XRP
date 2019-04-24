
//
//  XPNoticeViewController.m
//  YJOTC
//
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPNoticeViewController.h"
#import "XPNoticeListCell.h"

@interface XPNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)BOOL isRefresh;

@end

@implementation XPNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];

    [self setupUI];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)setupUI
{
    self.title = kLocat(@"s0115_noticeTitle");
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    
    _tableView.backgroundColor = kTableColor;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    __weak typeof(self)weakSelf = self;

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        _isRefresh = YES;
        [weakSelf loadDataWith:_page];
    }];
    
    [_tableView.mj_header beginRefreshing];
}

-(void)loadDataWith:(NSInteger)page
{
    __weak typeof(self)weakSelf = self;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"type"] = @(_type);
    param[@"page"] = @(page);
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/news/ad_list"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
        
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            
            
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                
                [self.dataArray addObject:dic];
            }
            
            [weakSelf.tableView reloadData];
            
            if (datas.count == 0 && _dataArray.count == 0) {
                //                [self showTips:kLocat(@"OTC_order_norecord")];
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"empty_msg") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                    [[EmptyManager sharedManager] removeEmptyFromView:weakSelf.view];
                }];
                return ;
            }
            
            _isRefresh = NO;
            if (datas.count >= 10) {
                MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    if (!_isRefresh) {
                        _page ++;
                        [weakSelf loadDataWith:_page];
                    }
                    _isRefresh = YES;
                }];
                [footer setTitle:kLocat(@"R_Loading") forState:MJRefreshStateRefreshing];
                _tableView.mj_footer = footer;
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                //                _tableView.mj_footer = nil;
            }

        }else{
            //            [self showTips:[responseObj ksObjectForKey:kMessage]];
            if ([[responseObj ksObjectForKey:kCode]intValue] == 10001 ) {
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"empty_msg") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                    [[EmptyManager sharedManager] removeEmptyFromView:weakSelf.view];
                }];
            }
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"XPNoticeListCell";
    XPNoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    NSDictionary *dic = self.dataArray[indexPath.row];

    cell.titleLabel.text = dic[@"title"];
    cell.timeLabel.text = dic[@"add_time"];
//    cell.titleLabel.text = @"U3的已经调试好了，已";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    BaseWebViewController *vc = [BaseWebViewController webViewControllerWithURIString:[NSString stringWithFormat:@"/mobile/news/detail/id/%@", dic[@"article_id"]] title:nil];
        kNavPush(vc);
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}



@end
