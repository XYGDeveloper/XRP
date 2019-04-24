//
//  XPMemberListerViewController.m
//  YJOTC
//
//  Created by l on 2019/1/5.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPMemberListerViewController.h"
#import "XPsearchResultTableViewCell.h"
#import "XPGetFridendListApi.h"
#import "XPFridendModel.h"
@interface XPMemberListerViewController ()<ApiRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviHeight;
@property (nonatomic,strong)XPGetFridendListApi *api;
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)XPFridendModel *model;

@end

@implementation XPMemberListerViewController

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviHeight.constant = kNavigationBarHeight;
    [self.tableview registerNib:[UINib nibWithNibName:@"XPsearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPsearchResultTableViewCell class])];
    __weak typeof(self) wself = self;
    self.api  = [[XPGetFridendListApi alloc]initWithKey:kUserInfo.token token_id:[NSString stringWithFormat:@"%ld",(long)kUserInfo.uid]];
    self.api.delegate = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api refresh];
    }];

    self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            __strong typeof(wself) sself = wself;
            [sself.api loadNextPage];
    }];
    [self.tableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.member.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPsearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPsearchResultTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    membersModel *model = [self.model.member objectAtIndex:indexPath.section];
    [cell refreshWithjijuoModel1:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        UIView *contentview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5)];
        contentview.backgroundColor = kColorFromStr(@"#F4F4F4");
        return contentview;
    }else{
        UIView *contentview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5)];
        contentview.backgroundColor = kColorFromStr(@"#F4F4F4");
        return contentview;
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
        return 5;
    }else{
        return 5;
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
    self.title = [NSString stringWithFormat:@"%@(%@%@)",kLocat(@"x_MyFriend"),self.model.count,kLocat(@"Dis_ChooseContacts_membercount")];
    if (self.model.member.count <= 0) {
        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"empty_msg") operationText:kLocat(@"C_community_bouns_empty_try") operationBlock:^{
                [self.tableview.mj_header beginRefreshing];
        }];
    }else{
        NSLog(@"------------%@",responsObject);
        [self.list removeAllObjects];
        [self.list addObjectsFromArray:self.model.member];
        NSLog(@"%@",self.list);
    }
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"empty_msg") operationText:kLocat(@"C_community_bouns_empty_try") operationBlock:^{
                [self.tableview.mj_header beginRefreshing];
    }];
}


- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    [self.tableview.mj_footer endRefreshing];
    [self.list addObjectsFromArray:self.model.member];
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_footer endRefreshing];
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    //    [self.view hideToastActivity];
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
}


@end
