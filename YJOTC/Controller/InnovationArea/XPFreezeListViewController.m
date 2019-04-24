//
//  XPFreezeListViewController.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPFreezeListViewController.h"
#import "XPFreeExchangeHeaderTableViewCell.h"
#import "XPFreeExchangeTableViewCell.h"
#import "XPGetGACFreezeListApi.h"
#import "XPGetGACModel.h"
@interface XPFreezeListViewController ()<ApiRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)XPFreeExchangeHeaderTableViewCell *header;
@property (nonatomic,strong)XPGetGACFreezeListApi *api;
@property (nonatomic,strong)XPGetGACModel *model;
@property (nonatomic,strong)NSMutableArray *list;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *knavi;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)NSInteger page;

@end

@implementation XPFreezeListViewController

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.knavi.constant = kNavigationBarHeight;
     self.header =  [[[NSBundle mainBundle] loadNibNamed:@"XPFreeExchangeHeaderTableViewCell" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = self.header;
    [self.tableview registerNib:[UINib nibWithNibName:@"XPFreeExchangeTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPFreeExchangeTableViewCell class])];
    if (self.isinner == YES) {
        self.title = kLocat(@"XPInternalPurchaseViewController_title");
    }else{
        self.title = self.subject;
    }
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
    if (self.isfree == YES) {
        url = @"/Exchange/gac_reward_forzen";
    }else if (self.isinner == YES){
        url = @"/InternalBuy/log";
    }else{
        url = @"/Exchange/gac_forzen";
    }
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:url] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
        XPGetGACModel *model = [XPGetGACModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
        [self.header refreshWithModel:model];
        self.model = model;
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData][@"list"];
            if (page == 1) {
                [_list removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                InnerModel *model = [InnerModel mj_objectWithKeyValues:dic];
                [self.list addObject:model];
            }
            [weakSelf.tableview reloadData];
            
            self.tableview.tableFooterView = nil;
            if (datas.count == 0 && _list.count == 0) {
                //                [self showTips:kLocat(@"OTC_order_norecord")];
                self.tableview.tableFooterView =  [[EmptyManager sharedManager]showEmptyOnView:nil withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"OTC_order_norecord") operationText:@"" operationBlock:nil];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPFreeExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPFreeExchangeTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    InnerModel *model = [self.list objectAtIndex:indexPath.row];
    [cell refreshWithModel:model];
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

//- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
//    //    [self showTips:command.response.msg];
////    [self.tableview.mj_footer resetNoMoreData];
//    [self.tableview.mj_header endRefreshing];
//    [self.tableview.mj_footer endRefreshing];
////    self.tableview.tableFooterView = nil;
//    XPGetGACModel *model = (XPGetGACModel *)responsObject;
//    [self.header refreshWithModel:model];
//    self.model = model;
//    if (model.list.count <= 0) {
////        self.tableview.tableFooterView =[[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"empty_msg") operationText:kLocat(@"") operationBlock:^{
////            //                    [self.tableview.mj_header beginRefreshing];
////        }];
//    } else {
//        [self.list removeAllObjects];
//        [self.list addObjectsFromArray:self.model.list];
//        [self.tableview reloadData];
//    }
//}
//
//- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
//    [self.tableview.mj_header endRefreshing];
//    [self.tableview.mj_footer endRefreshing];
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
//    XPGetGACModel *model = (XPGetGACModel *)responsObject;
//    [self.list addObjectsFromArray:model.list];
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
//    [self.tableview.mj_footer endRefreshing];
//
//}


@end
