//
//  XPBoundRewardViewController.m
//  YJOTC
//
//  Created by l on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPBoundRewardViewController.h"
#import "XPRewardListTableViewCell.h"
#import "XPbounsHeaderTableViewCell.h"
@interface XPBoundRewardViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)XPbounsHeaderTableViewCell *header;


@end

@implementation XPBoundRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview registerNib:[UINib nibWithNibName:@"XPRewardListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPRewardListTableViewCell class])];
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"XPbounsHeaderTableViewCell" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = self.header;

    if (self.type == 1) {
        self.title = kLocat(@"C_community_bouns_incre");
        self.header.TotalRevenueLabel.text  =kLocat(@"C_community_reward_manager_totalrenun");
        self.header.currentLabel.text = kLocat(@"C_community_bouns_currentshouyi");
        self.header.todayRenueLabel.text = kLocat(@"C_community_reward_manager_todayrenun");
        self.header.progressDes.text = kLocat(@"C_community_bouns_basics_static_houyi");
        self.header.onlinedLabel.text = kLocat(@"C_community_bouns_static_optioned");
        self.header.totalOnlineLabel.text = kLocat(@"C_community_bouns_static_sumoptioned");
    }else if (self.type == 2){
        self.title = kLocat(@"C_community_bouns_one");
        self.header.TotalRevenueLabel.text  =kLocat(@"C_community_reward_manager_totalrenun");
        self.header.currentLabel.text = kLocat(@"C_community_bouns_yestedayshouyi");
        self.header.todayRenueLabel.text = kLocat(@"C_community_reward_manager_todayrenun");
        self.header.progressDes.text = kLocat(@"C_community_bouns_basics_static_houyi");
        self.header.onlinedLabel.text = kLocat(@"C_community_bouns_static_optioned");
        self.header.totalOnlineLabel.text = kLocat(@"C_community_bouns_static_sumoptioned");
    }else{
        self.title = kLocat(@"C_community_bouns_help");
        self.header.TotalRevenueLabel.text  =kLocat(@"C_community_reward_manager_totalrenun");
        self.header.currentLabel.text = kLocat(@"C_community_bouns_currentshouyi");
        self.header.todayRenueLabel.text = kLocat(@"C_community_reward_manager_todayrenun");
        self.header.progressDes.text = kLocat(@"C_community_bouns_basics_static_houyi");
        self.header.onlinedLabel.text = kLocat(@"C_community_bouns_static_optioned");
        self.header.totalOnlineLabel.text = kLocat(@"C_community_bouns_static_sumoptioned");
    }
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPRewardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPRewardListTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

@end
