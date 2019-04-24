

//
//  TPWalletLockController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletLockController.h"
#import "TPWalletLockTypeCell.h"

@interface TPWalletLockController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,assign)NSInteger sectionCount;

@property(nonatomic,assign)BOOL money_interes;
@property(nonatomic,assign)BOOL hasRelaese;
@property(nonatomic,assign)BOOL hasLock;



@end

@implementation TPWalletLockController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupUI];

    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)setupUI
{
    self.title = [NSString stringWithFormat:@"%@概覽",_model.currency_name];
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight ) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletLockTypeCell" bundle:nil] forCellReuseIdentifier:@"TPWalletLockTypeCell"];
}

-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = _model.currency_id;
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/bcb_user"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            _dataDic = [responseObj ksObjectForKey:kData];
            
            kLOG(@"%@",_dataDic);
            [self.tableView reloadData];
            
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataDic) {
        NSInteger section = 3;
    
        if ([_dataDic[@"forzen_num_year"] doubleValue] + [_dataDic[@"forzen_num_half"] doubleValue] > 0) {
            _hasLock = YES;
            section += 2;
        }
        if ([_dataDic[@"user_release"] doubleValue] > 0) {
            _hasRelaese = YES;
            section ++;
        }
        if ([_dataDic[@"money_interes"] doubleValue] > 0) {
            _money_interes = YES;
            section ++;
        }
        
        _sectionCount = section;
        return section;
    }else{
        return 0;
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPWalletLockTypeCell";
    TPWalletLockTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.typeLabel.hidden = indexPath.section;
    if (indexPath.section == 0) {
        cell.title.text = [NSString stringWithFormat:@"%@总量",_model.currency_name];
        cell.volumeLabel.text = ConvertToString(_dataDic[@"total"]);
        cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"total_cny"]];
        if ([_dataDic[@"is_ab"] integerValue] == 1) {
            cell.typeLabel.text = @"类型: A";
        }else{
            cell.typeLabel.text = @"类型: B";
        }
    }else if (indexPath.section == 1){
        cell.title.text = [NSString stringWithFormat:@"%@可用",_model.currency_name];
        cell.volumeLabel.text = ConvertToString(_dataDic[@"num"]);
        cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"num_cny"]];
        
    }else if (indexPath.section == 2){
        cell.title.text = [NSString stringWithFormat:@"%@凍結",_model.currency_name];
        cell.volumeLabel.text = ConvertToString(_dataDic[@"forzen_num"]);
        cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"forzen_num_cny"]];
        
    }else{
        if (_hasLock) {
            if (indexPath.section == 3){
                cell.title.text = [NSString stringWithFormat:@"%@半年鎖倉",_model.currency_name];
                cell.volumeLabel.text = ConvertToString(_dataDic[@"forzen_num_half"]);
                cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"forzen_num_half_cny"]];
            }else if (indexPath.section == 4){
                cell.title.text = [NSString stringWithFormat:@"%@一年鎖倉",_model.currency_name];
                cell.volumeLabel.text = ConvertToString(_dataDic[@"forzen_num_year"]);
                cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"forzen_num_year_cny"]];
            }
            if (_hasRelaese) {
                if (indexPath.section == 5) {
                    cell.title.text = [NSString stringWithFormat:@"%@釋放",_model.currency_name];
                    cell.volumeLabel.text = ConvertToString(_dataDic[@"user_release"]);
                    cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"user_release_cny"]];
                }
                if (_money_interes) {
                    if (indexPath.section == 6) {
                        cell.title.text = [NSString stringWithFormat:@"%@持幣生息",_model.currency_name];
                        cell.volumeLabel.text = ConvertToString(_dataDic[@"money_interes"]);
                        cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"money_interes_cny"]];
                    }
                }else{
                    
                }
            }else{
                if (_money_interes) {
                    if (indexPath.section == 5) {
                        cell.title.text = [NSString stringWithFormat:@"%@持幣生息",_model.currency_name];
                        cell.volumeLabel.text = ConvertToString(_dataDic[@"money_interes"]);
                        cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"money_interes_cny"]];
                    }
                }else{
                    
                }
            }
        }else{
            if (_hasRelaese) {
                if (indexPath.section == 3) {
                    cell.title.text = [NSString stringWithFormat:@"%@釋放",_model.currency_name];
                    cell.volumeLabel.text = ConvertToString(_dataDic[@"user_release"]);
                    cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"user_release_cny"]];
                }
                if (_money_interes) {
                    if (indexPath.section == 4) {
                        cell.title.text = [NSString stringWithFormat:@"%@持幣生息",_model.currency_name];
                        cell.volumeLabel.text = ConvertToString(_dataDic[@"money_interes"]);
                        cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"money_interes_cny"]];
                    }
                }else{
                    
                }
            }else{
                if (_money_interes) {
                    if (indexPath.section == 3) {
                        cell.title.text = [NSString stringWithFormat:@"%@持幣生息",_model.currency_name];
                        cell.volumeLabel.text = ConvertToString(_dataDic[@"money_interes"]);
                        cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"money_interes_cny"]];
                    }
                }else{
                }
            }
        }
    }
        
//        if (_sectionCount == 4) {//释放
//            cell.title.text = [NSString stringWithFormat:@"%@釋放",_model.currency_name];
//            cell.volumeLabel.text = ConvertToString(_dataDic[@"user_release"]);
//            cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"user_release_cny"]];
//
//        }else if (_sectionCount == 5){
//
//            if (indexPath.section == 3){
//                cell.title.text = [NSString stringWithFormat:@"%@半年鎖倉包",_model.currency_name];
//
//                cell.volumeLabel.text = ConvertToString(_dataDic[@"forzen_num_half"]);
//                cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"forzen_num_half_cny"]];
//
//            }else if (indexPath.section == 4){
//                cell.title.text = [NSString stringWithFormat:@"%@一年鎖倉包",_model.currency_name];
//
//                cell.volumeLabel.text = ConvertToString(_dataDic[@"forzen_num_year"]);
//                cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"forzen_num_year_cny"]];
//            }
//        }else{
//            if (indexPath.section == 3){
//                cell.title.text = [NSString stringWithFormat:@"%@半年鎖倉包",_model.currency_name];
//
//                cell.volumeLabel.text = ConvertToString(_dataDic[@"forzen_num_half"]);
//                cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"forzen_num_half_cny"]];
//
//            }else if (indexPath.section == 4){
//                cell.title.text = [NSString stringWithFormat:@"%@一年鎖倉包",_model.currency_name];
//
//                cell.volumeLabel.text = ConvertToString(_dataDic[@"forzen_num_year"]);
//                cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"forzen_num_year_cny"]];
//            }else if (indexPath.section == 5){
//                cell.title.text = [NSString stringWithFormat:@"%@釋放",_model.currency_name];
//                cell.volumeLabel.text = ConvertToString(_dataDic[@"user_release"]);
//                cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"user_release_cny"]];
//
//            }
//        }
//
//    }
        
        
        
        
        
        
//    if (indexPath.section == 3){
//        cell.title.text = @"BCB半年鎖倉包";
//        cell.volumeLabel.text = ConvertToString(_dataDic[@"forzen_num_half"]);
//        cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"forzen_num_half_cny"]];
//
//    }else if (indexPath.section == 4){
//        cell.title.text = @"BCB一年鎖倉包";
//        cell.volumeLabel.text = ConvertToString(_dataDic[@"forzen_num_year"]);
//        cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"forzen_num_year_cny"]];
//
//    }else if (indexPath.section == 5){
//        cell.title.text = @"BCB半年釋放";
//        cell.volumeLabel.text = ConvertToString(_dataDic[@"forzen_num_year"]);
//        cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"forzen_num_year_cny"]];
//
//    }else if (indexPath.section == 6){
//        cell.title.text = @"BCB一年釋放";
//        cell.volumeLabel.text = ConvertToString(_dataDic[@"forzen_num_year"]);
//        cell.cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_dataDic[@"forzen_num_year_cny"]];
//
//    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }else{
        return 110;
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 5;
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





@end
