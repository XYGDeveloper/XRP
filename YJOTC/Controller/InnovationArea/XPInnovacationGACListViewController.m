//
//  XPInnovacationGACListViewController.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPInnovacationGACListViewController.h"
#import "XPGACTableViewCell.h"
#import "XPGACAlertView.h"
#import "XPGETGetGACListApi.h"
#import "XPGACModel.h"
#import "XPGetGACModel.h"
@interface XPInnovacationGACListViewController ()<ApiRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)XPGETGetGACListApi *api;
@property (nonatomic,strong)NSMutableArray *list;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *knavi;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)NSInteger page;

@end

@implementation XPInnovacationGACListViewController

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isInner == YES) {
        self.title = kLocat(@"XPInternalPurchaseViewController_innerrecorder");
    }else{
        self.title = kLocat(@"XPFreezeListViewController_exchangefreezed");
    }
    self.knavi.constant = kNavigationBarHeight;
    [self.tableview registerNib:[UINib nibWithNibName:@"XPGACTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPGACTableViewCell class])];
    __weak typeof(self)weakSelf = self;
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        _isRefresh = YES;
        [weakSelf loadDataWith:_page];
    }];
    
    [_tableview.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)loadDataWith:(NSInteger)page
{
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"page"] = @(page);
    NSString *url;
    if (self.isInner == YES) {
        url = @"/InternalBuy/buy_log";
    }else{
        url = @"/Exchange/exchange_log";
    }
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:url] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
        
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            if (page == 1) {
                [_list removeAllObjects];
            }
            
//            if (self.isInner == YES) {
//                NSDictionary *dic = [responseObj ksObjectForKey:kData];
//                NSArray *datas = [dic ksObjectForKey:@"list"];
//                for (NSDictionary *dic in datas) {
//                     XPGetGACModel *model  = [XPGetGACModel mj_objectWithKeyValues:dic];
//                    [self.list addObject:model];
//                }
//            }else{
                for (NSDictionary *dic in datas) {
                    XPGACModel *model  = [XPGACModel mj_objectWithKeyValues:dic];
                    [self.list addObject:model];
                }
//            }
            
          
            
            [weakSelf.tableview reloadData];
            
            if (datas.count == 0 && _list.count == 0) {
                //                [self showTips:kLocat(@"OTC_order_norecord")];
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"OTC_order_norecord") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
                    [weakSelf.tableview.mj_header beginRefreshing];
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



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPGACTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPGACTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (self.isInner == YES) {
//        XPGetGACModel *model = [self.list objectAtIndex:indexPath.row];
//        [cell  refreshWithModel1:model];
//    }else{
        XPGACModel *model = [self.list objectAtIndex:indexPath.row];
        [cell refreshWithModel:model];
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XPGACModel *model = [self.list objectAtIndex:indexPath.row];
    [XPGACAlertView alertControllerAppearIn:self accounterName:model.phone statusText:model.status_txt publishTime:[NSString stringWithFormat:@"%@%@",kLocat(@"XPInnovacationExchangeViewController_addtime"),model.add_time] finishTime:[NSString stringWithFormat:@"%@",model.add_time] xrp:[NSString stringWithFormat:@"-%@%@",model.from_num,model.from_currency] shouxu:[NSString stringWithFormat:@"%@%@%@",kLocat(@"XPInnovacationExchangeViewController_shouxu"),model.fee,model.to_currency] shiji:[NSString stringWithFormat:@"%@+%@%@",kLocat(@"XPInnovacationExchangeViewController_shiji"),model.actual,model.to_currency] guzhi:[NSString stringWithFormat:@"%@%@CNY",kLocat(@"XPInnovacationExchangeViewController_guzhi"),model.total_cny] note:kLocat(@"XPInnovacationExchangeViewController_notes") leftTtopText:[NSString stringWithFormat:@"%@/CNY",model.from_currency] leftTbomText:model.from_cny rightTopText:[NSString stringWithFormat:@"%@/CNY",model.to_currency] rightBomText:model.to_cny];
    
}

//- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
//    //    [self showTips:command.response.msg];
//    [self.tableview.mj_footer resetNoMoreData];
//    [self.tableview.mj_header endRefreshing];
//    self.tableview.tableFooterView = nil;
//    NSArray *arr = responsObject;
//    if (arr.count <= 0) {
//        self.tableview.tableFooterView =[[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"empty_msg") operationText:kLocat(@"") operationBlock:^{
//            //                    [self.tableview.mj_header beginRefreshing];
//        }];
//    } else {
//        [self.list removeAllObjects];
//        [self.list addObjectsFromArray:arr];
//        [self.tableview reloadData];
//    }
//}
//
//- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
//    [self.tableview.mj_header endRefreshing];
//    //    [self showTips:command.response.msg];
//    self.tableview.tableFooterView = nil;
//    if (self.list.count <= 0) {
//
//    }
//}
//
//
//
//- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
//    [self showTips:command.response.msg];
//    [self.tableview.mj_footer endRefreshing];
//    [self.list addObjectsFromArray:responsObject];
//    [self.tableview reloadData];
//}
//
//- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
//    [self.tableview.mj_footer endRefreshing];
//    [self showTips:command.response.msg];
//}
//
//- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
//    //    [self.tableview.mj_footer endRefreshingWithNoMoreData];
//}


@end
