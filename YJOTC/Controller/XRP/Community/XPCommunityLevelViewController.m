//
//  XPCommunityLevelViewController.m
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCommunityLevelViewController.h"
#import "XPCommunityLeHeaderTableViewCell.h"
#import "XPcommunityProgressTableViewCell.h"
#import "XPcommunityProgressTopCell.h"

@interface XPCommunityLevelViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)XPCommunityLeHeaderTableViewCell *header;

@property(nonatomic,strong)NSArray *listArray;


@end

@implementation XPCommunityLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview registerNib:[UINib nibWithNibName:@"XPcommunityProgressTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPcommunityProgressTableViewCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:@"XPcommunityProgressTopCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPcommunityProgressTopCell class])];
    _tableview.backgroundColor = kTableColor;
    
    
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"XPCommunityLevelHeaderTableViewCell" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = self.header;
    
    [self loadData];
    self.title = kLocat(@"A_boss_xrpshequgaunlidenjiTitle");
    UIView *footView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 135)];
    footView.backgroundColor = kTableColor;
//    _tableview.tableFooterView = footView;
    UIButton *applyButton = [[UIButton alloc] initWithFrame:kRectMake(35, 30, 280 *kScreenWidthRatio, 40) title:kLocat(@"s0122_tobecomeleader") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [footView addSubview:applyButton];
    applyButton.centerX = kScreenW/2.0;
    
    applyButton.backgroundColor = kColorFromStr(@"#6189C5");
    kViewBorderRadius(applyButton, 8, 0, kRedColor);
    [applyButton addShadow];
    [applyButton addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(12, applyButton.bottom + 10, kScreenW - 24, 16) text:kLocat(@"s0122_tobecomeleaderLimit") font:PFRegularFont(14) textColor:k666666Color textAlignment:1 adjustsFont:YES];
    [footView addSubview:tipsLabel];
    
    
}


-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/boss/plan_level"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            self.header.dataDic = [responseObj ksObjectForKey:kData][@"member"];
            
            _listArray = [responseObj ksObjectForKey:kData][@"level_list"];
            
            [self.tableview reloadData];
        }
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_listArray.count == 0) {
        return 0;
    }else{
        return _listArray.count;
    }
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        static NSString *rid = @"XPcommunityProgressTopCell";
        XPcommunityProgressTopCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.dataDic = _listArray[indexPath.section];
        return cell;
    }else{

        XPcommunityProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPcommunityProgressTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = _listArray[indexPath.section];
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 210 + 5 + 7.5;
    }
    return 110 + 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.1;
    }else{
        return 0.1;
    }
}

-(void)applyAction
{
    
}


@end
