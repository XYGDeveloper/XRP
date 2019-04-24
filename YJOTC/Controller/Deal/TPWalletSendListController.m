

//
//  TPWalletSendListController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletSendListController.h"
#import "TPWalletListCell.h"
#import "TPWalletSendController.h"
#import "TPWalletSendToBCBController.h"
#import "TPWalletSendController.h"
#import "XPAssetBankListController.h"

@interface TPWalletSendListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray<TPWalletCurrencyModel *> *dataArray;

@end

@implementation TPWalletSendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [self loadData];
    
    [self setupUI];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)loadData
{
    if (_isAssetBank) {
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Money/getCurrencyList"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [self.dataArray removeAllObjects];
                NSArray *datas = [responseObj ksObjectForKey:kData];
                for (NSDictionary*dic in datas) {
                    TPWalletCurrencyModel *model = [TPWalletCurrencyModel modelWithJSON:dic];
                    model.money = model.num;
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            }else{
                NSInteger code = [[responseObj ksObjectForKey:kCode]integerValue];
                if (code == 10100) {
                    //                [self gotoLoginVC];
                }
            }
        }];

    }else{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/asset_list"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [self.dataArray removeAllObjects];
                NSArray *datas = [responseObj ksObjectForKey:kData];
                for (NSDictionary*dic in datas) {
                    [self.dataArray addObject:[TPWalletCurrencyModel modelWithJSON:dic]];
                }
                [self.tableView reloadData];
            }else{
                NSInteger code = [[responseObj ksObjectForKey:kCode]integerValue];
                if (code == 10100) {
                    //                [self gotoLoginVC];
                }
            }
        }];
    }

}

-(void)setupUI
{
    self.title = kLocat(@"W_ChooseCurrencyToSend");
    
    if (_isAssetBank) {
        self.title = kLocat(@"ZB_choosecurrency");
    }
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight ) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletListCell" bundle:nil] forCellReuseIdentifier:@"TPWalletListCell"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPWalletListCell";
    TPWalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.model = self.dataArray[indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isAssetBank) {
        if (_model) {
            if ([_model.currency_id isEqualToString:self.dataArray[indexPath.section].currency_id]) {
                kNavPop;
            }else{//检查新的币种是否有当前的管理周期
                [self getBankListWith:self.dataArray[indexPath.section].currency_id];
            }
        }else{//第一次进列表选择币种
            
            XPAssetBankListController *vc = [XPAssetBankListController new];
            vc.currencyID = self.dataArray[indexPath.section].currency_id;
            kNavPush(vc);
        }
        
    }else{
        
        if (_toScan) {
            __weak typeof(self)weakSelf = self;
            KSScanningViewController *vc = [[KSScanningViewController alloc] init];
            vc.callBackBlock = ^(NSString *scannedStr) {
                
                TPWalletSendController *vc = [TPWalletSendController new];
                vc.model = weakSelf.dataArray[indexPath.section];
                vc.addressStr = scannedStr;
                kNavPushSafe(vc);
            };
            [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc]  animated:YES completion:nil];
        }else{
            TPWalletSendController *vc = [TPWalletSendController new];
            vc.model = self.dataArray[indexPath.section];
            kNavPush(vc);
        }
    }
    
}


-(void)getBankListWith:(NSString *)cuurencyID
{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"currency_id"] = cuurencyID;
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
                
                BOOL hasTheSamePeriod = NO;
                XPAssetBankModel *newModel;
                for (XPAssetBankModel *model in arr) {
                    if ([model.months isEqualToString:_model.months]) {
                        hasTheSamePeriod = YES;
                        newModel = model;
                        break;
                    }
                }
                if (hasTheSamePeriod) {
                    self.callBackBlcok(newModel);
                    kNavPop;
                }else{
                    XPAssetBankListController *vc = [XPAssetBankListController new];
                    vc.currencyID = cuurencyID;
                    kNavPush(vc);
                }
            }
        }];

}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section != self.dataArray.count - 1) {
        return 0.01;
    }
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.dataArray.count - 1 != section) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 25)];
    view.backgroundColor = kTableColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(0, 0, 60, 25) text:kLocat(@"W_NoMoreData") font:PFRegularFont(12) textColor:kColorFromStr(@"#999999") textAlignment:1 adjustsFont:YES];
    [view addSubview:label];
    [label alignHorizontal];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)];
    lineView.backgroundColor = kColorFromStr(@"#999999");
    [view addSubview:lineView];
    [lineView alignVertical];
    lineView.right = label.left - 10;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)];
    lineView1.backgroundColor = kColorFromStr(@"#999999");
    [view addSubview:lineView1];
    [lineView1 alignVertical];
    lineView1.left = label.right + 10;
    return view;
    
}



@end
