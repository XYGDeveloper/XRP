//
//  XPBasicBoundsViewController.m
//  YJOTC
//
//  Created by l on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPBasicBoundsViewController.h"
#import "XPRewardListTableViewCell.h"
#import "XPBasicBounsHeaderTableViewCell.h"
#import "XPBoundHeadModel.h"
#import "XPGetLogListApi.h"
#import "XPCommunityZTViewController.h"
@interface XPBasicBoundsViewController ()<ApiRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)XPBasicBounsHeaderTableViewCell *header;
@property (nonatomic,strong)XPBoundHeadModel *model;
@property (nonatomic,strong)XPGetLogListApi *api;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviHeight;
@property (nonatomic,strong)NSMutableArray *list;
@end

@implementation XPBasicBoundsViewController

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.boundsType isEqualToString:@"1"]) {
        self.title  = kLocat(@"C_community_bouns_basic_incre");
    }else if ([self.boundsType isEqualToString:@"2"]){
        self.title  = kLocat(@"C_community_bouns_incre");
    }else if ([self.boundsType isEqualToString:@"3"]){
        self.title  = kLocat(@"C_community_bouns_one");
    }else if ([self.boundsType isEqualToString:@"4"]){
        self.title  = kLocat(@"C_community_bouns_help");
    }
    self.naviHeight.constant = kNavigationBarHeight;
    self.tableview.frame = CGRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
    [self.tableview registerNib:[UINib nibWithNibName:@"XPRewardListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPRewardListTableViewCell class])];
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"XPBasicBounsHeaderTableViewCell" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = self.header;
    
    [self.header.optionButton addTarget:self action:@selector(toReward:) forControlEvents:UIControlEventTouchUpInside];
     [self.header.zengtouButton addTarget:self action:@selector(tozt:) forControlEvents:UIControlEventTouchUpInside];
    [self loadData];
    
    __weak typeof(self) wself = self;

        self.api  = [[XPGetLogListApi alloc]initWithKey:kUserInfo.token token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid] type:self.boundsType];
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


- (void)toReward:(UIButton *)sender{
    NSLog(@"ssssssssss");
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"type"] = self.boundsType;
        NSLog(@"%@",param);
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/boss/bouns_receive"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            NSLog(@"%@",responseObj);
            
            if (success) {
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
                [self loadData];
                [self.tableview.mj_header beginRefreshing];
            }else{
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            }
        }];
}

- (void)tozt:(UIButton *)sender{
    kNavPush([XPCommunityZTViewController new]);
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"type"] = self.boundsType;
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/boss/bouns_detail"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        
        if (success) {
            NSLog(@"%@",responseObj);
            self.model = [XPBoundHeadModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            [self.header refreshWithModel:self.model type:self.boundsType];
            [self.tableview reloadData];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
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
    XPRewardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPRewardListTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XPGetLogModel *model = [self.list objectAtIndex:indexPath.row];
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
        return 0.1;
    }else{
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.1;
    }else{
        return 0.1;
    }
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    //    [self showTips:command.response.msg];
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    self.tableview.tableFooterView = nil;
    NSArray *array = responsObject;
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
    [self.tableview.mj_header endRefreshing];
    self.tableview.tableFooterView = nil;
    if (self.list.count <= 0) {
       
    }
}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    [self.tableview.mj_footer endRefreshing];
    [self.list addObjectsFromArray:responsObject];
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
