



//
//  TPNewsViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPNewsViewController.h"
#import "TPNewsPriceCell.h"
#import "TPCurrencyInfoController.h"

@interface TPNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;



@end

@implementation TPNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _dataArray = [NSMutableArray array];
    [self setupUI];

}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}
-(void)setupUI
{
    self.title = kLocat(@"hangqing");
    

    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH - 44- kNavigationBarHeight - kTabbarItemHeight) style:UITableViewStyleGrouped];
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
//    _tableView.tableHeaderView = [self setupHeadView];
    [_tableView registerNib:[UINib nibWithNibName:@"TPMainActivityCell" bundle:nil] forCellReuseIdentifier:@"TPMainActivityCell"];
    
    
    __weak typeof(self)weakSelf = self;

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadBBData];
    }];
}
-(void)loadBBData
{
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Trade/quotation1"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [_tableView.mj_header endRefreshing];
        if (success) {

            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *listModels = [NSMutableArray array];
            id data = [responseObj ksObjectForKey:kData][_index][@"data_list"];
            listModels = [ListModel mj_objectArrayWithKeyValuesArray:data];
            for (NSDictionary *dic in [responseObj ksObjectForKey:kData][_index][@"data_list"]) {
                [arr addObject:[XPQuotationModel modelWithJSON:dic]];
                
//                ListModel *model = [ListModel mj_obj:dic];
//                [listModels addObject:model];
                
            }
            _dataArray = arr.mutableCopy;
            _ListModelArray = listModels.mutableCopy;
            

            [self.tableView reloadData];
            
        }else{
            [[EmptyManager sharedManager]showNetErrorOnView:self.view response:nil operationBlock:^{
                [self loadBBData];
            }];
        }
    }];
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
    static NSString *rid = @"TPNewsPriceCell";
    TPNewsPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.model = self.dataArray[indexPath.section];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPCurrencyInfoController *vc= [TPCurrencyInfoController new];
//    vc.model = self.dataArray[indexPath.section];
    vc.listModel = self.ListModelArray[indexPath.section];
    kNavPush(vc);
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80 + 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_dataArray.count > 0) {
        if (section == _dataArray.count - 1) {
            return 7.5+10;
        }else{
            return 0.01;
        }
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 7.5;
    }else{
        return 0.01;
    }
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
