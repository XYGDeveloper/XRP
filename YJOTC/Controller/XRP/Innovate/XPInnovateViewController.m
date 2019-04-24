//
//  XPInnovateViewController.m
//  YJOTC
//
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPInnovateViewController.h"
#import "XPXRPPlusDetailListCell.h"
#import "XPZhuanZhangController.h"
#import "XPInnovateHeadView.h"


@interface XPInnovateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)UILabel *volumeLabel;

@property(nonatomic,strong)XPInnovateHeadView *headView;

@end

@implementation XPInnovateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"kRefreshXPXRPAssetViewControllerKey" object:nil];


    [self setupUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)setupUI
{
    if (_isInnovate) {
        self.title = kLocat(@"s_Innovate");
    }else{
        self.title = kLocat(@"A_boss_rbj");
    }
    
    XPInnovateHeadView *headView = [[XPInnovateHeadView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight, kScreenW, 130)];
    [self.view addSubview:headView];
    _headView = headView;
    _volumeLabel = headView.volumeLabel;
    if (self.isList == YES) {
        _headView.hidden = YES;
        _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
    }else{
        _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,headView.bottom, kScreenW, kScreenH-headView.height - kNavigationBarHeight) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
    }
   
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
    [_tableView registerNib:[UINib nibWithNibName:@"XPAssetBankRecordCell" bundle:nil] forCellReuseIdentifier:@"XPAssetBankRecordCell"];
    
    __weak typeof(self)weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        _isRefresh = YES;
        [weakSelf loadDataWith:_page];
    }];
    
    [_tableView.mj_header beginRefreshing];
    
    if (!_isInnovate) {
        [headView.sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view bringSubviewToFront:headView];
    }
    headView.sendButton.hidden = _isInnovate;
    
    
}

-(void)loadDataWith:(NSInteger)page
{
    __weak typeof(self)weakSelf = self;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"page"] = @(page);
    NSString *url;
    if (_isInnovate) {
        url = @"/transfer_xrp/new_detail";
    }else{
        url = @"/transfer_xrp/xrpj_detail";
    }
    
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:url] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [[EmptyManager sharedManager] removeEmptyFromView:self.tableView];
        
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData][@"log"];
            
            
            if (_isInnovate) {
                _volumeLabel.text = ConvertToString([responseObj ksObjectForKey:kData][@"new_num"]);
            }else{
                _volumeLabel.text = ConvertToString([responseObj ksObjectForKey:kData][@"xrpj_num"]);
            }
            
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                
                [self.dataArray addObject:dic];
            }
            
            [weakSelf.tableView reloadData];
            
            if (datas.count == 0 && _dataArray.count == 0) {
                //                [self showTips:kLocat(@"OTC_order_norecord")];
                [[EmptyManager sharedManager]showEmptyOnView:self.tableView withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"OTC_order_norecord") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                    [[EmptyManager sharedManager] removeEmptyFromView:weakSelf.tableView];
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
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"XPXRPPlusDetailListCell";
    XPXRPPlusDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    
    cell.innovateDic = self.dataArray[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60 + 10;
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
-(void)sendAction
{
    XPZhuanZhangController *vc = [XPZhuanZhangController new];
    vc.isXRPG = YES;
    kNavPush(vc);
}

-(void)loadData
{
    _page = 1;
    [self loadDataWith:_page];
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
