//
//  XPJHMemberViewController.m
//  YJOTC
//
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPJHMemberViewController.h"
#import "XPJHHeaderTableViewCell.h"
#import "XPCashierViewController.h"
#import "XPVotesTableViewCell.h"
#import "XPGetValiModel.h"

@interface XPJHMemberViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)XPJHHeaderTableViewCell *header;

@property(nonatomic,strong)NSDictionary *dataDic;

@property(nonatomic,assign)NSInteger value;

@property(nonatomic,strong)UIButton *voteButton;


@end

@implementation XPJHMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    [self loadData];
}

-(void)setupUI
{
    
    self.title = kLocat(@"C_community_search_detai03_nav");
    
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
    [_tableView registerClass:[XPVotesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XPVotesTableViewCell class])];

    
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"XPJHHeaderTableViewCell" owner:self options:nil] lastObject];
    self.header.frame = CGRectMake(0, kNavigationBarHeight, kScreenW, 190);
    _tableView.tableHeaderView = self.header;
    
    UIView *footView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 113 + 45)];
    _tableView.tableFooterView = footView;
    footView.backgroundColor = kTableColor;
    
    UIButton *topButton = [[UIButton alloc] initWithFrame:kRectMake(12, 110, kScreenW - 24, 45) title:kLocat(@"A_boss_confirm") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    topButton.backgroundColor = kColorFromStr(@"#6189C5");
    [footView addSubview:topButton];
    kViewBorderRadius(topButton, 8, 0, kRedColor);
    [topButton addShadow];
    _voteButton = topButton;
    __weak typeof(self)weakSelf = self;
    
    [topButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        kLOG(@"%zd== ",weakSelf.value);
        XPCashierViewController *vc = [XPCashierViewController new];
        vc.votes = weakSelf.value;
        vc.member_id = weakSelf.memberID;
        vc.parent_id = weakSelf.parentId;
        kNavPushSafe(vc);
    }];
}

-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/BossPlan/active_step_list"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            _dataDic = [responseObj ksObjectForKey:kData];
            _value = [_dataDic[@"min_votes"] integerValue];
            NSLog(@"%@",[responseObj ksObjectForKey:kData]);
            /**=$Z xx
             @property (nonatomic,copy)NSString *current;
             @property (nonatomic,copy)NSString *votes;
             @property (nonatomic,copy)NSString *number;
             @property (nonatomic,copy)NSString *min;
             */
            XPGetValiModel *model = [XPGetValiModel new];
            [self.header refreshWithModel:model];
            self.header.firLabel.text = [NSString stringWithFormat:@"%@ :  %@%@",kLocat(@"C_community_search_current_jx"),_dataDic[@"votes"],kLocat(@"C_community_search_votes")];
            self.header.sedLabel.text = [NSString stringWithFormat:@"%@ :  %@",kLocat(@"C_community_reward_manager_piaoshu"),_dataDic[@"number"]];
            self.header.thirdLabel.text = [NSString stringWithFormat:@"%@ :  %@%@",kLocat(@"C_community_search_alert_sure_min"),_dataDic[@"min_votes"],kLocat(@"C_community_search_votes")];
            [self.tableView reloadData];
//            if ([_dataDic[@"votes"] integerValue] >= [_dataDic[@"max_votes"] integerValue]) {
//                _voteButton.userInteractionEnabled = NO;
//                _voteButton.backgroundColor = kColorFromStr(@"#93A3B6");
//            }
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPVotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPVotesTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.desLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"C_community_reward_xrp_vote_max"),_dataDic[@"max_votes"],kLocat(@"C_community_search_votes")];
    cell.stepper.maxValue = [_dataDic[@"max_votes"] integerValue];
    cell.stepper.minValue = [_dataDic[@"min_votes"] integerValue];
    cell.stepper.value = _value;
    cell.stepper.isValueEditable = NO;
    cell.stepper.valueChanged = ^(double value) {
        _value = value;
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
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


@end
