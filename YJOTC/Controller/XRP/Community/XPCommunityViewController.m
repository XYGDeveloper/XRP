//
//  XPCommunityViewController.m
//  YJOTC
//
//  Created by l on 2018/12/24.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCommunityViewController.h"
#import "XPCommunityTableViewCell.h"
#import "XPCommunityHeaderTableViewCell.h"
#import "XPCommunityFooterTableViewCell.h"
#import "XPCommunityDetailViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XPCommunityIndexModel.h"
#import "XPCommunitySearchViewController.h"
#import "XPBindViewController.h"
#import "XPVotesViewController.h"
#import "XPCommunityLeaderViewController.h"
@interface XPCommunityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)XPCommunityHeaderTableViewCell *header;
@property (nonatomic,strong)XPCommunityFooterTableViewCell *footer;
@property (nonatomic,strong)XPCommunityIndexModel *model;

@end

@implementation XPCommunityViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview.mj_header beginRefreshing];
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
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNavigationBarHeight);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)loadData{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/BossPlan/index"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        [self.tableview.mj_header endRefreshing];
        if (success) {
            [[EmptyManager sharedManager] removeEmptyFromView:self.view];
            self.model = [XPCommunityIndexModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            [self.header.bannerImg setImageWithURL:[NSURL URLWithString:self.model.img1] options:0];
//            status -1:申请 3:进入 其他:审核中
            if ([self.model.status isEqualToString:@"-1"]) {
                [self.footer.communityButton setTitle:kLocat(@"C_community_apply") forState:UIControlStateNormal];
            }else if ([self.model.status isEqualToString:@"2"]){
                [self.footer.communityButton setTitle:kLocat(@"C_community_search_current_wait_tosure") forState:UIControlStateNormal];
            }
            else if ([self.model.status isEqualToString:@"3"]){
                [self.footer.communityButton setTitle:kLocat(@"C_community_enter") forState:UIControlStateNormal];
                self.footer.communityButton.backgroundColor = kColorFromStr(@"6189C5");
            }else{
                [self.footer.communityButton setTitle:kLocat(@"C_community_wailtReve") forState:UIControlStateNormal];
                self.footer.communityButton.backgroundColor = kColorFromStr(@"93A3B6");
            }
            [self.tableview reloadData];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"empty_msg") operationText:kLocat(@"C_community_bouns_empty_try") operationBlock:^{
                [self.tableview.mj_header beginRefreshing];
            }];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"C_community_mainPage");
    self.view.backgroundColor = kColorFromStr(@"#F4F4F4");
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[XPCommunityTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XPCommunityTableViewCell class])];
    [self layOutSubview];
    self.header =  [[[NSBundle mainBundle] loadNibNamed:@"XPCommunityHeaderTableViewCell" owner:self options:nil] lastObject];
    self.footer =  [[[NSBundle mainBundle] loadNibNamed:@"XPCommunityFooterTableViewCell" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = self.header;
    self.tableview.tableFooterView = self.footer;
    [self.footer.communityButton addTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tableview.mj_header beginRefreshing];
}

- (void)toDetail:(UIButton *)sender{
    
    if ([self.model.lock_status isEqualToString:@"2"]) {
        [self showTips:kLocat(@"C_community_jh_search_community_bind_xrp_plan_lock")];
    }else{
        if ([self.model.status isEqualToString:@"-1"]) {
            XPCommunitySearchViewController *vc = [XPCommunitySearchViewController new];
            vc.model = self.model;
            kNavPush(vc);
        }else if ([self.model.status isEqualToString:@"2"]){
            XPBindViewController *reveel =  [XPBindViewController new];
            reveel.isreve = YES;
            kNavPush(reveel);
        }else if ([self.model.status isEqualToString:@"3"]){
            kNavPush([XPCommunityDetailViewController new]);
        }else{
            XPBindViewController *reveel =  [XPBindViewController new];
            reveel.isreve = YES;
            kNavPush(reveel);
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPCommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPCommunityTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell refreshWithModel:self.model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([XPCommunityTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(XPCommunityTableViewCell *cell) {
        [cell refreshWithModel:self.model];
    }];
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


@end
