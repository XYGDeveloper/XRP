//
//  XPAssetViewController.m
//  YJOTC
//
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPAssetViewController.h"
#import "XPAssetBankRecordController.h"
#import "XPAssetBankRecordCell.h"
#import "TPWalletSendListController.h"


@interface XPAssetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,copy)NSString *imgUrl;


@end

@implementation XPAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray new];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"kUserDidBuyAnAssetBankKey" object:nil];

//    [self loadData];
}
-(void)setupUI
{
    self.title = kLocat(@"ZB_assetBank");
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"XPAssetBankRecordCell" bundle:nil] forCellReuseIdentifier:@"XPAssetBankRecordCell"];

    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:kLocat(@"z_record") forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kColorFromStr(@"#E4A646") forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightbBarButton addTarget:self action:@selector(recordAction) forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
    
    UIButton *joinButton = [[UIButton alloc] initWithFrame:kRectMake(12, kScreenH - 45 - 50, kScreenW - 24, 45) title:kLocat(@"ZB_join") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    joinButton.backgroundColor = kColorFromStr(@"#6189C5");
    kViewBorderRadius(joinButton, 8, 0, kRedColor);
    [joinButton addShadow];
    [self.view addSubview:joinButton];
    [joinButton addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof(self)weakSelf = self;

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [_tableView.mj_header beginRefreshing];
}

-(void)loadData
{
    __weak typeof(self)weakSelf = self;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Money/getMoneyInterestList"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [_tableView.mj_header endRefreshing];
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            
            _imgUrl = [responseObj ksObjectForKey:@"image"];
            [self.dataArray removeAllObjects];

            if (datas.count == 0 ) {
                [self.tableView reloadData];
                [self showTips:kLocat(@"OTC_order_norecord")];
                return ;
            }

            for (NSDictionary *dic in datas) {
                
                [self.dataArray addObject:dic];
            }
            
            [self.tableView reloadData];
            
        }else{
//            [self showTips:[responseObj ksObjectForKey:kMessage]];
            
            if ([[responseObj ksObjectForKey:kCode]intValue] == 10001 ) {
//                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"OTC_order_norecord") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
//                    [weakSelf.tableView.mj_header beginRefreshing];
//                    [[EmptyManager sharedManager] removeEmptyFromView:weakSelf.view];
//                }];
                _imgUrl = [responseObj ksObjectForKey:@"image"];
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];

            }
            
        }
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        if (self.dataArray.count == 0) {
            return 1;
        }else{
            return self.dataArray.count;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [UITableViewCell new];
        cell.selectionStyle = 0;
        cell.backgroundColor = kTableColor;
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:kRectMake(12, 15, kScreenW - 24, (kScreenW - 24)*160/350.0)];
//        img.image = kImageFromStr(@"xrp_img_banner1");
        [img setImageWithURL:_imgUrl.ks_URL placeholder:nil];
        
        [cell.contentView addSubview:img];
        kViewBorderRadius(img, 8, 0, kRedColor);
        [img addShadow];
        return cell;
    }else{
        if (self.dataArray.count == 0) {
            UITableViewCell *cell = [UITableViewCell new];
            cell.contentView.backgroundColor = kTableColor;
            UIImageView *noContentView = [[UIImageView alloc] initWithFrame:kRectMake((kScreenW - 149)/2.0, 20, 149, 73)];
            [cell.contentView addSubview:noContentView];
            noContentView.image = kImageFromStr(@"lay_img_zwjl");
            
            UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(0, noContentView.bottom - 10, kScreenW, 14) text:kLocat(@"OTC_order_norecord") font:PFRegularFont(14) textColor:k666666Color textAlignment:1 adjustsFont:YES];
            [cell.contentView addSubview:label];
            cell.selectionStyle = 0;
            return cell;
            
        }else{
            
            static NSString *rid = @"XPAssetBankRecordCell";
            XPAssetBankRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
            }
            cell.dic = self.dataArray[indexPath.row];
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return (kScreenW - 24)*160/350.0 + 15+5;
    }else{
        if (self.dataArray.count == 0) {
            return 160;
        }
        
        return 120 + 15;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else{
        return 50;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return [self createTopViewWithTitle:kLocat(@"ZB_NewRrcord") showMore:NO action:nil];
    }
    
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)createTopViewWithTitle:(NSString *)str showMore:(BOOL)showMore action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 50)];
    view.backgroundColor = kTableColor;
    UILabel *line = [[UILabel alloc] initWithFrame:kRectMake(12, 20, 2, 20)];
    line.backgroundColor = kNaviColor;
    [view addSubview:line];
    [line alignVertical];
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(20, 0, 200, 16) text:str font:PFRegularFont(16) textColor:kColorFromStr(@"#222222") textAlignment:0 adjustsFont:0];
    [view addSubview:label];
    label.centerY = line.centerY;
    return view;
}
#pragma mark - 點擊事件

-(void)recordAction
{
    kNavPush([XPAssetBankRecordController new]);
}


-(void)joinAction
{
    TPWalletSendListController *vc = [TPWalletSendListController new];
    
    vc.isAssetBank = YES;
    
    kNavPush(vc);
    
}

@end
