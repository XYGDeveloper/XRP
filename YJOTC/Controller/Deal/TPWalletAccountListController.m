//
//  TPWalletAccountListController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletAccountListController.h"
#import "TPWalletCurrencyDetailListCell.h"
#import "TPWalletAccountDetailController.h"

@interface TPWalletAccountListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)BOOL isRefresh;
@end

@implementation TPWalletAccountListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];

    
    [self setupUI];
    
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletCurrencyDetailListCell" bundle:nil] forCellReuseIdentifier:@"TPWalletCurrencyDetailListCell"];
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
    if (_type > 0) {
        param[@"type"] = @(_type);
    }
    param[@"page"] = @(page);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"AccountBook/index"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
        NSLog(@"%@",[responseObj ksObjectForKey:kData]);
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            
            if (datas.count == 0 && _dataArray.count == 0) {
//                [self showTips:kLocat(@"OTC_order_norecord")];
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"OTC_order_norecord") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                    [[EmptyManager sharedManager] removeEmptyFromView:weakSelf.view];
                }];
                return ;

            }
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                
                [self.dataArray addObject:dic];
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
    static NSString *rid = @"TPWalletCurrencyDetailListCell";
    TPWalletCurrencyDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.selectionStyle = 0;
    cell.accountDic = self.dataArray[indexPath.section];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.dataArray[indexPath.section];
    if ([dic[@"type"] integerValue] == 5 ||[dic[@"type"] integerValue] == 6 ) {
        TPWalletAccountDetailController *vc = [TPWalletAccountDetailController new];
        vc.dic = dic;
        kNavPush(vc);
    }
    
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else{
        return 5;
    }
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
