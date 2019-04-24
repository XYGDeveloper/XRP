//
//  TPDealDetailController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPDealDetailController.h"
#import "TPDealDetailTopCell.h"
#import "UIDealDetailBottomCell.h"

@interface TPDealDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSDictionary *infoDic;

@property(nonatomic,strong)NSArray *listArray;

@property(nonatomic,copy)NSString *market;
@property(nonatomic,copy)NSString *currency_mark;


@end

@implementation TPDealDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)setupUI
{
    self.navigationItem.title = kLocat(@"H_dealDetail");
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPDealDetailTopCell" bundle:nil] forCellReuseIdentifier:@"TPDealDetailTopCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"UIDealDetailBottomCell" bundle:nil] forCellReuseIdentifier:@"UIDealDetailBottomCell"];

    
    _tableView.estimatedRowHeight = 180;
    _tableView.rowHeight = UITableViewAutomaticDimension;
}
-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"orders_id"] = _orderID;
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Entrust/history_info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {

            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            _infoDic = dic[@"info"];
            _listArray = dic[@"list"];
            _market = _infoDic[@"market"];
            _currency_mark = _infoDic[@"currency_name"];
            [self.tableView reloadData];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 4;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_infoDic) {
        return 1 + self.listArray.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *rid = @"TPDealDetailTopCell";
        TPDealDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.type = 1;
        cell.dataDic = _infoDic;
        return cell;
    }else{
        static NSString *rid = @"UIDealDetailBottomCell";
        UIDealDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        
        NSDictionary *dic = self.listArray[indexPath.section - 1];

        if (indexPath.row == 0) {
            cell.itemLabel.text = kLocat(@"k_MyassetDetailViewController_wt_time");
            cell.valueLabel.text = dic[@"add_time"];
        }else if (indexPath.row == 1){
            cell.itemLabel.text = kLocat(@"H_dealprice");
            cell.valueLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"price"],_market];

        }else if (indexPath.row == 2){
            cell.itemLabel.text = kLocat(@"k_MyassetDetailViewController_wt_cjl");
            cell.valueLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"num"],_currency_mark];
        }else{
            cell.itemLabel.text = kLocat(@"OTC_fee");

            cell.valueLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"fee"],_market];
        }
  
        return cell;
        
    }

    return nil;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != 0) {
        UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 15)];
        view.backgroundColor = kTableColor;
        return view;
    }
    return nil;
}


@end
