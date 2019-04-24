//
//  TPNewsDrawerController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPNewsDrawerController.h"
#import "TPQuotationModel.h"
#import "TPNewerDrawCell.h"
#import "TPTradeMallController.h"
#import "YTTradeViewController.h"

@interface TPNewsDrawerController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)CGFloat w;
@property(nonatomic,strong)UIButton *BCBButton;
@property(nonatomic,strong)UIButton *ETHButton;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray<TPQuotationModel *> *BCBArrays;

@property(nonatomic,strong)NSMutableArray<TPQuotationModel *> *ETHArrays;
@property(nonatomic,assign)BOOL isBCB;


@property(nonatomic,strong)NSMutableArray<XPQuotationModel*> *XRPArrays;

@property(nonatomic,strong)NSMutableArray<XPQuotationModel*> *USDTArrays;


@property(nonatomic,strong)NSArray *dataArr;

@property(nonatomic,assign)NSInteger index;



@end

@implementation TPNewsDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];

    _w = kScreenW * 0.86;
    _BCBArrays = [NSMutableArray array];
    _ETHArrays = [NSMutableArray array];
    _isBCB = YES;
    [self loadBBData];
    
//    [self setupUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backAction) name:@"kTPNewsDrawerControllerDidAppear" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [self setStatusBarColor:kNaviColor];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setStatusBarColor:kClearColor];
}
-(void)setupUI
{
    
    
    UIView *topView = [[UIView alloc] initWithFrame:kRectMake(0, kStatusBarHeight + 20, _w, 50)];
    [self.view addSubview:topView];
    topView.backgroundColor = kWhiteColor;
    CGFloat w = 37 + 24;
    
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        
        
        UIButton *BCBButton = [[UIButton alloc] initWithFrame:kRectMake((w+15)*i, 0,w, 50) title:@"BCB" titleColor:k222222Color font:PFRegularFont(18) titleAlignment:0];
        [BCBButton setTitleColor:kColorFromStr(@"#066B98") forState:UIControlStateSelected];
        [topView addSubview:BCBButton];
        BCBButton.tag = i;
        [BCBButton setTitle:_dataArr[i][@"name"] forState:UIControlStateNormal];
        if (i == 0) {
            BCBButton.selected = YES;
        }
        [BCBButton addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:kRectMake(_w - 50, 0, 50, 50)];
    [backButton setImage:kImageFromStr(@"hq_icon_listno") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,topView.bottom, _w, kScreenH - topView.bottom) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPNewerDrawCell" bundle:nil] forCellReuseIdentifier:@"TPNewerDrawCell"];
    
    
    _tableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
}

-(void)topButtonAction:(UIButton *)button
{
    
    if (button.tag == _index) {
        return;
    }else{
        _index = button.tag;
        [self.tableView reloadData];
        for (UIButton *btn in button.superview.subviews) {
            if (button == btn) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }
    }
    return;
    
    
    _index = button.tag;
    
    
    if (button.isSelected) {
        return;
    }else{
        if (button.tag == 0) {
            _BCBButton.selected = YES;
            _ETHButton.selected = NO;
        }else{
            _BCBButton.selected = NO;
            _ETHButton.selected = YES;
        }
    }
    _isBCB = _BCBButton.isSelected;
//    [self loadData];
    
}



-(void)loadBBData
{
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Trade/quotation1"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            _dataArr = [responseObj ksObjectForKey:kData];

            [self setupUI];
            
        }else{
            [[EmptyManager sharedManager]showNetErrorOnView:self.view response:nil operationBlock:^{
                [self loadBBData];
            }];
        }
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr[_index][@"data_list"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *rid = @"TPNewerDrawCell";
    TPNewerDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    
    cell.dic = _dataArr[_index][@"data_list"][indexPath.row];
    
    
//    if (_isBCB) {
//        cell.model = self.BCBArrays[indexPath.row];
//    }else{
//        cell.model = self.ETHArrays[indexPath.row];
//    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    ListModel *model = [ListModel modelWithJSON:self.dataArr[_index][@"data_list"][indexPath.row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidSelectedNewCurrencyKey" object:model];
    
    [self backAction];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



@end
