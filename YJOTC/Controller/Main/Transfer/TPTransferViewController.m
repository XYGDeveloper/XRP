//
//  TPTransferViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPTransferViewController.h"
#import "TPMineCommenCell.h"
#import "TPTransferToPocketController.h"
#import "TPTransferRecordCell.h"
#import "TPTransferRecordController.h"

@interface TPTransferViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *icons;
@property(nonatomic,strong)NSArray *items;




@end

@implementation TPTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [NSMutableArray array];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"kUserDidTransferSuccessKey" object:nil];

    
    [self setupUI];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
-(void)setupUI
{
    self.title = kLocat(@"x_xzhaunzhan");
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    _tableView.backgroundColor = kColorFromStr(@"#111419");
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"TPMineCommenCell" bundle:nil] forCellReuseIdentifier:@"TPMineCommenCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPTransferRecordCell" bundle:nil] forCellReuseIdentifier:@"TPTransferRecordCell"];

    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:kLocat(@"ZZ_zzrecord") forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = PFRegularFont(16);
    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightbBarButton addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
    
    __weak typeof(self)weakSelf = self;

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [weakSelf loadData];
    }];
    
    [_tableView.mj_header beginRefreshing];
    
    
}
-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Transfer/index"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [_tableView.mj_header endRefreshing];
 
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData][@"list"];
            [self.dataArray removeAllObjects];
            for (NSDictionary *dic in datas) {
                [self.dataArray addObject:dic];
            }
            [self.tableView reloadData];
            
            
        }else{
            

            [self showTips:kLocat(@"OTC_order_norecord")];
            
        }
    }];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count + 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *rid = @"TPMineCommenCell";
        TPMineCommenCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.arrow.hidden = YES;
        cell.itemIcon.image = kImageFromStr(self.icons[indexPath.row]);
        cell.itemLabel.text = self.items[indexPath.row];
        kViewBorderRadius(cell.itemIcon, 0, 0, kRedColor);
        return cell;
    }else if(indexPath.section == 1){
        UITableViewCell *cell = [UITableViewCell new];
        cell.backgroundColor = k111419Color;
        cell.selectionStyle = 0;
        UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, 0, 100, 55) text:kLocat(@"W_Latest") font:PFRegularFont(16) textColor:kLightGrayColor textAlignment:0 adjustsFont:YES];
        [cell.contentView addSubview:label];
        
        return cell;
    }else{
        
        static NSString *rid = @"TPTransferRecordCell";
        TPTransferRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.dateDic = self.dataArray[indexPath.section-2];
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            kNavPush([TPTransferToPocketController new]);
        }else{
            [self showTips:kLocat(@"g_jqqd")];
        }

    }else if(indexPath.section == 2){
        
        
    }
    
    
}
-(void)rightAction
{
    kNavPush([TPTransferRecordController new]);
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1) {
        return 55;
    }else{
        return 110;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section >=2) {
        return 5;
    }
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}



-(NSArray *)icons
{
    if (_icons == nil) {
        _icons = @[@"main_zhuan_icon1",@"main_zhuan_icon2",@"zhuan_icon_zfren"];
    }
    return _icons;
}
-(NSArray *)items
{
    if (_items == nil) {
        _items = @[@"轉賬到口袋賬戶",@"轉賬給朋友",@"轉賬到銀行卡"];
    }
    return _items;
}

@end
