//
//  XPJHChildListViewController.m
//  YJOTC
//
//  Created by l on 2019/1/3.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPJHChildListViewController.h"
#import "XPReviewTableViewCell.h"
#import "XPsearchResultTableViewCell.h"
#import "XPBossActivityCancelCell.h"
#import "XPBossActivityCheckedCell.h"

@interface XPJHChildListViewController ()
@property (nonatomic,strong)NSString *type;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isRefresh;

@end

@implementation XPJHChildListViewController

- (instancetype)initWithType:(NSString *)type{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}
//
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.naviHeight.constant = 0;
    [self.tableview registerNib:[UINib nibWithNibName:@"XPReviewTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPReviewTableViewCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:@"XPsearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPsearchResultTableViewCell class])];

    [_tableview registerNib:[UINib nibWithNibName:@"XPBossActivityCancelCell" bundle:nil] forCellReuseIdentifier:@"XPBossActivityCancelCell"];
    [_tableview registerNib:[UINib nibWithNibName:@"XPBossActivityCheckedCell" bundle:nil] forCellReuseIdentifier:@"XPBossActivityCheckedCell"];
    _tableview.tableFooterView = [UIView new];

    
    
    
    __weak typeof(self)weakSelf = self;
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        _isRefresh = YES;
        [weakSelf loadDataWith:_page];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}

-(void)loadDataWith:(NSInteger)page
{
    __weak typeof(self)weakSelf = self;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    if (_type.intValue > 0) {
        param[@"status"] = _type;
    }
    param[@"page"] = @(page);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/BossPlan/active_list"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
        
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            
            if (datas.count == 0 && _dataArray.count == 0) {
                //                [self showTips:kLocat(@"OTC_order_norecord")];
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"OTC_order_norecord") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
                    [weakSelf.tableview.mj_header beginRefreshing];
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
            
            [weakSelf.tableview reloadData];
            
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
                _tableview.mj_footer = footer;
            }else{
                [_tableview.mj_footer endRefreshingWithNoMoreData];
                //                _tableView.mj_footer = nil;
            }
            
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
        
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 10;
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *rid = @"XPBossActivityCheckedCell";
    XPBossActivityCheckedCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    static NSString *rid1 = @"XPBossActivityCancelCell";
    XPBossActivityCancelCell *cancelCell = [tableView dequeueReusableCellWithIdentifier:rid1];
    if (cancelCell == nil) {
        cancelCell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    if ([dic[@"status"] integerValue] == 1) {

        cell.dataDic = dic;
        return cell;
    }else{
        cancelCell.dataDic = dic;
        return cancelCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    if ([dic[@"status"] integerValue] == 1) {
//    if (indexPath.row == 1) {
        return 140 + 15;
    }else{
        return 84 + 15;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.1;
    }else{
        return 0.1;
    }
}


@end
