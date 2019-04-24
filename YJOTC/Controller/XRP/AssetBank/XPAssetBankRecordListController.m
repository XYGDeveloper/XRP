
//
//  XPAssetBankRecordListController.m
//  YJOTC
//
//  Created by Roy on 2018/12/21.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAssetBankRecordListController.h"
#import "XPAssetBankRecordCell.h"

@interface XPAssetBankRecordListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)BOOL isRefresh;

@end

@implementation XPAssetBankRecordListController

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
    [_tableView registerNib:[UINib nibWithNibName:@"XPAssetBankRecordCell" bundle:nil] forCellReuseIdentifier:@"XPAssetBankRecordCell"];
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
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Money/getMoneyInterestList"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
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
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"OTC_order_norecord") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
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
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"OTC_order_norecord") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
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
    static NSString *rid = @"XPAssetBankRecordCell";
    XPAssetBankRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    
    cell.dic = self.dataArray[indexPath.row];
//    cell.dic = [NSDictionary new];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120+15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 0.01;
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
