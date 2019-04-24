//
//  XPReleaseViewController.m
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPReleaseViewController.h"
#import "XPRewardListTableViewCell.h"
#import "XPGeZSApi.h"
#import "XPZSModel.h"
#import "XPReleaseHeaderTableViewCell.h"
#import "XPAboutXRPViewController.h"
@interface XPReleaseViewController ()<ApiRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)XPGeZSApi *api;
@property (nonatomic,strong)XPReleaseHeaderTableViewCell *header;
@property (nonatomic,strong)XPZSModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviHeight;

@end

@implementation XPReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = kLocat(@"s0219_redpacket");
    self.naviHeight.constant = kNavigationBarHeight;
    self.tableview.frame = CGRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
    [self.tableview registerNib:[UINib nibWithNibName:@"XPRewardListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPRewardListTableViewCell class])];
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"XPReleaseHeaderTableViewCell" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = self.header;
//    [self.header.optionButton addTarget:self action:@selector(toReward:) forControlEvents:UIControlEventTouchUpInside];
//    __weak typeof(self) wself = self;
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"about_icon"] action:@selector(about)];
    self.api  = [[XPGeZSApi alloc]initWithKey:kUserInfo.token token_id:[NSString stringWithFormat:@"%ld",(long)kUserInfo.uid]];
    self.api.delegate = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.api refresh];
    }];
    
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.api loadNextPage];
    }];
    [self.tableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)about{
    kNavPush([XPAboutXRPViewController new]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPRewardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPRewardListTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lanModel *model = [self.list objectAtIndex:indexPath.row];
    [cell refreshWithModel1:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
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
    self.list = [NSMutableArray array];
    self.tableview.tableFooterView = nil;
    self.model = responsObject;
    self.header.labelle01.text = kLocat(@"C_community_bouns_static_sum_count");
    self.header.labelle02.text = self.model.user_num.sum_award;
    self.header.labelri01.text = kLocat(@"C_community_bouns_static_sum_leveel");
    self.header.labelri02.text = self.model.user_num.num_award;
    self.header.releLabel.text = kLocat(@"C_community_bouns_static_sum_jilu");
    NSArray *array = self.model.list;
    if (array.count <= 0) {
        self.tableview.tableFooterView =[[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"empty_msg") operationText:kLocat(@"") operationBlock:^{
//                    [self.tableview.mj_header beginRefreshing];
                }];
    } else {
        [self.list removeAllObjects];
        [self.list addObjectsFromArray:array];
        [self.tableview reloadData];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableview.mj_header endRefreshing];
    //    [self showTips:command.response.msg];
    self.tableview.tableFooterView = nil;
    [self.tableview.mj_header endRefreshing];
    if (self.list.count <= 0) {
        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"empty_msg") operationText:kLocat(@"") operationBlock:^{
//            [self.tableview.mj_header beginRefreshing];
        }];
    }
}



- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    [self.tableview.mj_footer endRefreshing];
    XPZSModel *model  = responsObject;
    [self.list addObjectsFromArray:model.list];
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_footer endRefreshing];
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    //    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}


@end
