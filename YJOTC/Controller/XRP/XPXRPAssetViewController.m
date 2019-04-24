//
//  XPXRPAssetViewController.m
//  YJOTC
//
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPXRPAssetViewController.h"
#import "XPAssetBankCommonCell.h"
#import "XPHuazhuanViewController.h"
#import "XPZhuanZhangController.h"
#import "XPXPRDetailViewController.h"

@interface XPXRPAssetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSDictionary *dataDic;

@property(nonatomic,assign)BOOL firstLoad;


@end

@implementation XPXRPAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstLoad = YES;
    [self setupUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"kRefreshXPXRPAssetViewControllerKey" object:nil];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_firstLoad == NO) {
        [self loadData];
    }
    
}
-(void)setupUI
{
    self.title = kLocat(@"s0221_zengsong");
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
    [_tableView registerNib:[UINib nibWithNibName:@"XPAssetBankCommonCell" bundle:nil] forCellReuseIdentifier:@"XPAssetBankCommonCell"];
    UIView *footView = [self createFootView];
    if (kScreenW < 321) {
        _tableView.tableFooterView = footView;
        
    }else{
        footView.frame = kRectMake(0, kScreenH - 109-50, kScreenW, 109+50);
        [self.view addSubview:footView];
    }
    //kLocat(@"z_record");
    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:kLocat(@"hz_detail") forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightbBarButton addTarget:self action:@selector(recordAction) forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
    
}

-(void)loadData
{
    if (_firstLoad == YES) {
        kShowHud;
    }

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/transfer_xrp/currency"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        _firstLoad = NO;
        kHideHud;
        if (success) {
            _dataDic = [responseObj ksObjectForKey:kData];
            [self.tableView reloadData];
        }
    }];
}

-(UIView *)createFootView
{
    __weak typeof(self)weakSelf = self;
    UIView *footView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 109 + 50)];
    footView.backgroundColor = kTableColor;
    UIButton *topButton = [[UIButton alloc] initWithFrame:kRectMake(12, 15, kScreenW - 24, 45) title:kLocat(@"Z_memberechange") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    topButton.backgroundColor = kColorFromStr(@"#6189C5");
    [footView addSubview:topButton];
    kViewBorderRadius(topButton, 8, 0, kRedColor);
    [topButton addShadow];
    [topButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        kNavPushSafe([XPZhuanZhangController new]);
    }];
    
    UIButton *bottomButton = [[UIButton alloc] initWithFrame:kRectMake(12, topButton.bottom + 15, kScreenW - 24, 45) title:kLocat(@"hz_hztomywallet") titleColor:kColorFromStr(@"#6189C5") font:PFRegularFont(16) titleAlignment:0];
//    topButton.backgroundColor = kColorFromStr(@"#6189C5");
    [footView addSubview:bottomButton];
    kViewBorderRadius(bottomButton, 8, 0.5, kColorFromStr(@"#6189C5"));
    [bottomButton addShadow];
    [bottomButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        XPHuazhuanViewController *vc = [XPHuazhuanViewController new];
        kNavPushSafe(vc);
    }];
    return footView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataDic) {
        return 1;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 2) {
        
        static NSString *rid = @"XPAssetBankCommonCell";
        XPAssetBankCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.icon.hidden = YES;
        if (indexPath.section == 0) {
            cell.itemLabel.text = kLocat(@"hz_name");
            cell.infoLabel.textColor = k222222Color;
            cell.infoLabel.text = kLocat(@"s0221_zengsong");
        }else{
            cell.itemLabel.text = kLocat(@"Number");
            cell.infoLabel.text = ConvertToString(_dataDic[@"xrp_num"]);
            cell.infoLabel.textColor = kColorFromStr(@"#068998");
        }
        return cell;
    }else{
        UITableViewCell *cell = [UITableViewCell new];
        cell.backgroundColor = kTableColor;
        cell.selectionStyle = 0;
        
        UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(12, 7.5, kScreenW - 24, 200)];
        
        [cell.contentView addSubview:bgView];
        bgView.backgroundColor = kWhiteColor;

        UILabel *title = [[UILabel alloc] initWithFrame:kRectMake(10, 14, 120, 14) text:kLocat(@"hz_intro") font:PFRegularFont(14) textColor:k222222Color textAlignment:0 adjustsFont:YES];
        [bgView addSubview:title];
        
        NSString *descStr = _dataDic[@"content"];
        
        CGSize size = [Utilities calculateWidthAndHeightWithWidth:kScreenW - 24-20 height:100000 text:descStr font:PFRegularFont(12)].size;
        UILabel *descLabel = [[UILabel alloc] initWithFrame:kRectMake(10, 40, size.width, size.height) text:descStr font:PFRegularFont(12) textColor:k666666Color textAlignment:0 adjustsFont:NO];
        descLabel.numberOfLines = 0;
        [bgView addSubview:descLabel];
        bgView.height = descLabel.bottom + 25 + 0;
        
        kViewBorderRadius(bgView, 8, 0, kRedColor);
        [bgView addShadow];
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 2) {
        return 60;
    }else{
        
        NSString *descStr = _dataDic[@"content"];
        
        CGSize size = [Utilities calculateWidthAndHeightWithWidth:kScreenW - 24-20 height:100000 text:descStr font:PFRegularFont(12)].size;
        
        return size.height + 40 -20-20;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2 && kScreenW < 321) {
        return 30;
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

-(void)recordAction
{
    kNavPush([XPXPRDetailViewController new]);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
