//
//  XPVotesViewController.m
//  YJOTC
//
//  Created by l on 2019/1/5.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPVotesViewController.h"
#import "XPVotesTableViewCell.h"
#import "XPJHHeaderTableViewCell.h"
#import "XPPayMethodTableViewCell.h"
#import "XPGetValiList.h"
#import "EmptyManager.h"
#import "XPGetValiModel.h"
#import "XPMemberListerViewController.h"
@interface XPVotesViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property  (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)XPJHHeaderTableViewCell *header;
@property (nonatomic,strong)XPPayMethodTableViewCell *footer;
@property (nonatomic,strong)XPGetValiList *api;
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)XPGetValiModel *model;
@end

@implementation XPVotesViewController

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = kColorFromStr(@"#F4F4F4");
        _tableview.separatorColor = kColorFromStr(@"#F4F4F4");
    }
    return _tableview;
}

- (void)layOutSubview{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    self.title = kLocat(@"C_community_jh_search_title");
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"XPJHHeaderTableViewCell" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = self.header;
    self.footer =  [[[NSBundle mainBundle] loadNibNamed:@"XPPayMethodTableViewCell" owner:self options:nil] lastObject];
    self.tableview.tableFooterView = self.footer;
    [self.footer.payButton setTitle:kLocat(@"C_community_search_bind_sure") forState:UIControlStateNormal];
    [self.footer.payButton addTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableview registerClass:[XPVotesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XPVotesTableViewCell class])];
    [self layOutSubview];
    __weak typeof(self) wself = self;
    self.api  = [[XPGetValiList alloc]initWithKey:kUserInfo.token token_id:[NSString stringWithFormat:@"%ld",(long)kUserInfo.uid]];
    self.api.delegate = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api refresh];
    }];
    //    self.collectionview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
    //        __strong typeof(wself) sself = wself;
    //        [sself.api loadNextPage];
    //    }];
    [self.tableview.mj_header beginRefreshing];
}


- (void)toDetail:(UIButton *)sender{
    kNavPush([XPMemberListerViewController new]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPVotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPVotesTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
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

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    //    [self showTips:command.response.msg];
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    self.model = responsObject;
    [self.header refreshWithModel:self.model];
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    
}


- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    [self.tableview.mj_footer endRefreshing];
    //    MineModel *model = responsObject;
    //    NSArray *arr = [mlistModel mj_objectArrayWithKeyValuesArray:model.list];
    //    [self.list addObjectsFromArray:arr];
    //    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_footer endRefreshing];
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    //    [self.view hideToastActivity];
    //    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}






@end
