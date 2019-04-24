
//
//  XPAssetBankListController.m
//  YJOTC
//
//  Created by Roy on 2018/12/19.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAssetBankListController.h"
#import "XPAssetBankListCell.h"
#import "XPAssetBangManageController.h"
#import "XPAssetBankRecordController.h"
#import "XPAssetBankModel.h"

@interface XPAssetBankListController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray<XPAssetBankModel *> *dataArray;


@end

@implementation XPAssetBankListController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupUI];
    
    [self loadData];
}
-(void)setupUI
{
    self.title = kLocat(@"z_assettitle");
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight ) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"XPAssetBankListCell" bundle:nil] forCellReuseIdentifier:@"XPAssetBankListCell"];
    
//    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
//    [rightbBarButton setTitle:kLocat(@"ZZ_zzrecord") forState:(UIControlStateNormal)];
//    [rightbBarButton setTitleColor:kColorFromStr(@"#E4A646") forState:(UIControlStateNormal)];
//    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [rightbBarButton addTarget:self action:@selector(recordAction) forControlEvents:(UIControlEventTouchUpInside)];
//    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
}

-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"currency_id"] = _currencyID;
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Money/getConfigByCurrenciId"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[[responseObj ksObjectForKey:kData]count]];
            for (NSDictionary *dic in [responseObj ksObjectForKey:kData]) {
                [arr addObject:[XPAssetBankModel modelWithJSON:dic]];
            }
            
            self.dataArray = arr.mutableCopy;
            [self.tableView reloadData];
        }
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"XPAssetBankListCell";
    XPAssetBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80+15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_reChooseDate) {
        self.callBackBlcok(self.dataArray[indexPath.row]);
        
        kNavPop;
    }else{
        
        XPAssetBangManageController *vc =[ XPAssetBangManageController new];
        vc.model = self.dataArray[indexPath.row];
        kNavPush(vc);
    }
    
}

-(void)recordAction
{
    kNavPush([XPAssetBankRecordController new]);
}


@end
