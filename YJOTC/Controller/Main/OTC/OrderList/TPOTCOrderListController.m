//
//  TPOTCOrderListController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCOrderListController.h"
#import "TPOTCOrderListCell.h"
#import "TPOTCOrderDetailController.h"

@interface TPOTCOrderListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray<TPOTCTradeListModel *> *dataArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,assign)BOOL isFirstLoad;



@end

@implementation TPOTCOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _isFirstLoad = YES;
    //self.view.backgroundColor = kColorFromStr(@"#171F34");
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if (_isFirstLoad == NO) {
        _page = 1;
        [self loadDataWith:_page];
    }
    
}


-(void)setupUI
{
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH-kNavigationBarHeight - 44) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCOrderListCell" bundle:nil] forCellReuseIdentifier:@"TPOTCOrderListCell"];
    
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
    param[@"page"] = @(page);
    //0未付款 1待放行 2申诉中 3已完成 4已取消
    if (_type == TPOTCOrderListControllerTypeNotPay) {
        param[@"status"] = @(0);
    }else if (_type == TPOTCOrderListControllerTypePaid){
        param[@"status"] = @(1);
    }else if (_type == TPOTCOrderListControllerTypeAppeal){
        param[@"status"] = @(2);
    }else if (_type == TPOTCOrderListControllerTypeDone){
        param[@"status"] = @(3);
    }else if (_type == TPOTCOrderListControllerTypeCancel){
        param[@"status"] = @(4);
    }
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"TradeOtc/trade_list"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];

        _isFirstLoad = NO;
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            
            if (datas.count == 0 && _dataArray.count == 0) {
//                [self showTips:kLocat(@"OTC_order_norecord")];
                
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"OTC_buylist_noorder") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                    [[EmptyManager sharedManager] removeEmptyFromView:weakSelf.view];
                }];

                return ;
            }
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                TPOTCTradeListModel *model = [TPOTCTradeListModel modelWithJSON:dic];
//                model.trade_id = @"141";
//                model.type = @"buy";
                [self.dataArray addObject:model];
            }
            
            [weakSelf.tableView reloadData];
            
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
            NSInteger code = [[responseObj ksObjectForKey:kCode] integerValue];
            if (code == 10100) {//token失效
//                [kUserInfo clearUserInfo];
//                UIViewController *vc = [HBLoginTableViewController fromStoryboard];
//                [self presentViewController:vc animated:YES completion:nil];
            }
        }
        
    }];
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPOTCOrderListCell";
    TPOTCOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    
    cell.model = self.dataArray[indexPath.section];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPOTCTradeListModel *model = self.dataArray[indexPath.section];
    //status 0未付款 1已付款 2申诉中 3已完成 4已取消
    
    TPOTCOrderDetailController *vc = [TPOTCOrderDetailController new];
    if (model.status.intValue == 0) {
        vc.type = TPOTCOrderDetailControllerTypeNotPay;
    }else if (model.status.intValue == 1){
        vc.type = TPOTCOrderDetailControllerTypePaid;
    }else if (model.status.integerValue == 2){
        vc.type = TPOTCOrderDetailControllerTypeAppleal;
    }else if (model.status.integerValue == 3){
        vc.type = TPOTCOrderDetailControllerTypeDone;
    }else if (model.status.integerValue == 4){
        vc.type = TPOTCOrderDetailControllerTypeCancel;
    }
    vc.model = model;
    kNavPush(vc);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0002;
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
