//
//  XPCommunityDetailViewController.m
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCommunityDetailViewController.h"
#import "XPCommunityDetailTableViewCell.h"
#import "XPCommunityDetailHeaderTableViewCell.h"
#import "XPCommunityFooterTableViewCell.h"
#import "XPCommunityLevelViewController.h"
#import "XPCommunityZTViewController.h"
#import "XPManagerRewardViewController.h"
#import "XPBoundRewardViewController.h"
#import "XPBasicBoundsViewController.h"
#import "XPMyMemberController.h"
#import "XPNoticeViewController.h"
#import "XPCommunityMemberViewController.h"
#import "XPJHListViewController.h"
#import "XPDetailModel.h"
#import "XPCommunityLeaderViewController.h"
#import "XPCommunityZTViewController.h"
#import "LSPaoMaView.h"
#import "XPXRPBannerCell.h"
#import "XPBossVoteViewController.h"
#import "XPXRPAssetViewController.h"
#import "XPInnovateViewController.h"


@interface XPCommunityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)XPCommunityDetailHeaderTableViewCell *header;
@property (nonatomic,strong)XPCommunityFooterTableViewCell *footer;
@property (nonatomic,strong)XPDetailModel *model;
@property(nonatomic,copy)NSString *bannerStr;
@property(nonatomic,copy)NSString *articleId;
@end

@implementation XPCommunityDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"C_community_title");
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,self.topView.bottom, kScreenW, kScreenH  - self.topView.bottom) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    [self.tableView registerNib:[UINib nibWithNibName:@"XPCommunityDetailHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"header"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XPCommunityDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"s1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XPCommunityDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"s2"];
     [self.tableView registerNib:[UINib nibWithNibName:@"XPCommunityDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"s3"];
     [self.tableView registerNib:[UINib nibWithNibName:@"XPCommunityDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"s4"];
     [self.tableView registerNib:[UINib nibWithNibName:@"XPCommunityDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"s5"];
     [self.tableView registerNib:[UINib nibWithNibName:@"XPCommunityDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"s6"];
     [self.tableView registerNib:[UINib nibWithNibName:@"XPCommunityDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"s7"];
     [self.tableView registerNib:[UINib nibWithNibName:@"XPCommunityDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"s8"];
     [self.tableView registerNib:[UINib nibWithNibName:@"XPCommunityDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"s9"];
  
//    self.footer = [[[NSBundle mainBundle] loadNibNamed:@"XPCommunityFooterTableViewCell" owner:self options:nil] lastObject];
//    self.footer.frame = CGRectMake(0, 0, kScreenW, 60);
//    self.tableView.tableFooterView = self.footer;
   
//    self.footer.backgroundColor = kRedColor;
    
    _tableView.backgroundColor = kTableColor;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self addRightBarButtonWithFirstImage:kImageFromStr(@"rui_icon_navbar") action:@selector(rightButtonAction:)];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
   
    // Do any additional setup after loading the view from its nib.
}

- (void)toGet:(UIButton *)sender{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/boss/user_one_receive"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        if (success) {
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            [self loadData];
            [self.tableView reloadData];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


- (void)loadData{
    NSMutableDictionary *param1 = [NSMutableDictionary dictionary];
    param1[@"type"] = @"2";
    param1[@"key"] = kUserInfo.token;
    param1[@"token_id"] = @(kUserInfo.uid);

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/news/ad"] andParam:param1 completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            _bannerStr = [responseObj ksObjectForKey:kData][@"title"];
            _articleId  = ConvertToString([responseObj ksObjectForKey:kData][@"article_id"]);
            [self.tableView reloadData];
        }
    }];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/boss/plan"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        kLOG(@"%@",responseObj);
        [self.tableView.mj_header endRefreshing];
        if (success) {
            self.model = [XPDetailModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            
            if ([self.model.today_type isEqualToString:@"1"]) {
                [self.footer.communityButton setTitle:kLocat(@"C_community_button_option") forState:UIControlStateNormal];
                [self.footer.communityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.footer.communityButton.userInteractionEnabled = YES;
            }else{
                [self.footer.communityButton setTitle:kLocat(@"C_community_button_option") forState:UIControlStateNormal];
                self.footer.communityButton.backgroundColor = kColorFromStr(@"#93A3B6");
                self.footer.communityButton.userInteractionEnabled = NO;
            }
            [self.tableView reloadData];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}


- (void)toDetail:(UIButton *)sender{
    kNavPush([XPCommunityLevelViewController new]);
}

- (void)toZengtou:(UIButton *)sender{
    kNavPush([XPBossVoteViewController new]);
}
-(void)toRBJ
{
    kNavPush([XPInnovateViewController new]);
}

-(UIView *)topView
{
    
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight, kScreenW, 70)];
        [self.view addSubview:_topView];
        _topView.backgroundColor = kColorFromStr(@"#225686");
        CGFloat h = _topView.height;
        //        NSArray *titles = @[@"Send",@"Receive",@"Receive",@"Receive",@"Flod"];
        NSArray *titles = titles = @[kLocat(@"s0221_myzengsong"),kLocat(@"C_community_search_detai02_nav"),kLocat(@"C_community_search_detai03_nav"),kLocat(@"C_community_search_detai04_nav"),kLocat(@"x_xfold")];
        NSArray *icons = @[@"nav_01",@"nav_02",@"nav_03",@"nav_04",@"fi_icon_fold"];
        CGFloat w = kScreenW/icons.count;
        
        for (NSInteger i = 0; i < icons.count; i++) {
            CGFloat x = w * i;
            
            YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(x, 0, w, h)];
            [_topView addSubview:button];
            [button alignVertical];
            [self configureButton:button With:titles[i] image:icons[i]];
            button.tag = i;
            [button addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _topView;
}

-(void)rightButtonAction:(UIButton *)button
{
    
    if (self.topView.height == 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, 70);
            self.tableView.frame = kRectMake(0, self.topView.bottom, kScreenW, kScreenH - self.topView.bottom );
        }];
    }
}
-(void)topButtonAction:(UIButton *)button
{
    if (button.tag == 0) {
        kNavPush([XPXRPAssetViewController new]);
    }else if (button.tag == 1){
//        kNavPush([XPCommunityZTViewController new]);
        kNavPush([XPBossVoteViewController new]);
    }else if (button.tag == 2){
        kNavPush([XPCommunityMemberViewController new]);
    }else if (button.tag == 3){
        if ([Utilities isExpired]) {
            [self gotoLoginVC];
            return;
        }
        BaseWebViewController *vc = [BaseWebViewController webViewControllerWithURIString:[NSString stringWithFormat:@"%@/%@",kBasePath,playMethod] title:nil];
        kNavPush(vc);
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.height = 0;
            self.tableView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
        }];
        return;
    }

//    BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight) title:button.currentTitle];
//    if ([url containsString:@"http"]) {
//        vc.urlStr = url;
//    }else{
//        vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,url];
//    }
//
//    kNavPush(vc);
}

-(void)configureButton:(YLButton *)button With:(NSString *)title image:(NSString *)image
{
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.font = PFRegularFont(12);
    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [button setImage:kImageFromStr(image) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    button.imageRect = kRectMake((kScreenW/5-34)/2, 12, 32, 32);
    button.titleRect = kRectMake(0, 50, button.width, 12);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;//设置文字位置，现设为居左，默认的是居中
    button.titleLabel.textAlignment = 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 4;
    }else{
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        static NSString *rid = @"XPXRPBannerCell";
        XPXRPBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.icon.image = kImageFromStr(@"news_icon_b");
        for (UIView *v in cell.bgView.subviews) {
            if (v.tag == 10000) {
                [v removeFromSuperview];
            }
        }
        
        if (_bannerStr.length > 1) {
            LSPaoMaView* paomav = [[LSPaoMaView alloc] initWithFrame:kRectMake(31, 10, kScreenW - 24 - 31 - 24, 20) title:_bannerStr];
            paomav.tag = 10000;
            [cell.bgView addSubview:paomav];
        }
        return cell;
    }else if (indexPath.section == 1){
        XPCommunityDetailHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detaiButton addTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.zengtouButton addTarget:self action:@selector(toZengtou:) forControlEvents:UIControlEventTouchUpInside];
        [cell refreshWithModel:self.model.info];
        [cell.rbjDetailButton addTarget:self action:@selector(toRBJ) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            XPCommunityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.image = [UIImage imageNamed:@"community_detail_fenhong"];
            boundsModel *model = self.model.bouns[0];
            cell.itemLabel.text = [NSString stringWithFormat:@"%@ +%@",kLocat(@"C_community_bouns_basic_incre"),model.number];
            return cell;
        }else if (indexPath.row == 1){
            XPCommunityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.image = [UIImage imageNamed:@"community_detail_zenjia_fenhong"];
            boundsModel *model = self.model.bouns[1];
            cell.itemLabel.text = [NSString stringWithFormat:@"%@ +%@",kLocat(@"C_community_bouns_incre"),model.number];
            return cell;
        }else if (indexPath.row == 2){
            XPCommunityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s3"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.image = [UIImage imageNamed:@"community_detail_first_fenhong"];
            boundsModel *model = self.model.bouns[2];
            cell.itemLabel.text = [NSString stringWithFormat:@"%@ +%@",kLocat(@"C_community_bouns_one"),model.number];
            return cell;
        }else{
            XPCommunityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s4"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.image = [UIImage imageNamed:@"community_detail_huzhufenhong"];
            boundsModel *model = self.model.bouns[3];
            cell.itemLabel.text = [NSString stringWithFormat:@"%@ +%@",kLocat(@"C_community_bouns_help"),model.number];
            return cell;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            XPCommunityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s5"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.image = [UIImage imageNamed:@"community_detail_recommend"];
            boundsModel *model = self.model.bouns[4];
            cell.itemLabel.text = [NSString stringWithFormat:@"%@ +%@",kLocat(@"C_community_reward_recommend"),model.number];
            return cell;
        }else if (indexPath.row == 1){
            XPCommunityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s6"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.image = [UIImage imageNamed:@"community_detail_shequjinagli"];
            boundsModel *model = self.model.bouns[5];
            cell.itemLabel.text = [NSString stringWithFormat:@"%@ +%@",kLocat(@"C_community_reward_community"),model.number];
            return cell;
        }else if (indexPath.row == 2){
            XPCommunityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s7"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.image = [UIImage imageNamed:@"community_detail_pingjijiangli"];
            boundsModel *model = self.model.bouns[6];
            cell.itemLabel.text = [NSString stringWithFormat:@"%@ +%@",kLocat(@"C_community_reward_level"),model.number];
            return cell;
        }else if (indexPath.row == 3){
            XPCommunityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s8"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.image = [UIImage imageNamed:@"community_detail_guanlijiangli"];
            boundsModel *model = self.model.bouns[7];
            cell.itemLabel.text = [NSString stringWithFormat:@"%@ +%@",kLocat(@"C_community_reward_manager"),model.number];
            return cell;
        }else{
            XPCommunityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s9"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.image = [UIImage imageNamed:@"community_detail_womember"];
            boundsModel *model = self.model.bouns[8];
            cell.itemLabel.text = [NSString stringWithFormat:@"%@ +%@",kLocat(@"C_community_reward_mymember"),model.number];
            return cell;
        }
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        return 65;
    }else if (indexPath.section == 1){
        
        if (self.model.info.xrpj_num.doubleValue > 0) {
            return 160 + 36 - 36;
        }
        return 160 - 40;
    }else{
        return 60;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (@available(iOS 11.0, *)) {
//        return nil;
//    }else{
//        return nil;
//    }
    
    if (section != 1) {
        return nil;
        
    }else{
        self.footer = [[[NSBundle mainBundle] loadNibNamed:@"XPCommunityFooterTableViewCell" owner:self options:nil] lastObject];
        self.footer.frame = CGRectMake(0, 0, kScreenW, 60);
        [self.footer.communityButton addTarget:self action:@selector(toGet:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.model.today_type isEqualToString:@"1"]) {
            [self.footer.communityButton setTitle:kLocat(@"C_community_button_option") forState:UIControlStateNormal];
            [self.footer.communityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.footer.communityButton.userInteractionEnabled = YES;
        }else{
            [self.footer.communityButton setTitle:kLocat(@"C_community_button_option") forState:UIControlStateNormal];
            self.footer.communityButton.backgroundColor = kColorFromStr(@"#93A3B6");
            self.footer.communityButton.userInteractionEnabled = NO;
        }
        return _footer;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 5;
    }else{
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (@available(iOS 11.0, *)) {
//        return 0.1;
//    }else{
//        return 0.1;
//    }
    if (section != 1) {
        return 0.01;
    }else{
        return 60;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        
        XPNoticeViewController *vc = [XPNoticeViewController new];
        vc.type = 2;
        kNavPush(vc);
        
//        BaseWebViewController *vc = [BaseWebViewController webViewControllerWithURIString:[NSString stringWithFormat:@"/mobile/news/detail/id/%@", _articleId] title:_bannerStr];
//
//        if (_articleId.length > 1) {
//
//            vc.showNaviBar = NO;
//            kNavPush(vc);
//        }
    }else if (indexPath.section == 1){
       
    }else if (indexPath.section == 2) {
        
        switch (indexPath.row) {
            case 0:
            {
                boundsModel *model = self.model.bouns[0];
                XPBasicBoundsViewController *basicBounds = [XPBasicBoundsViewController new];
                basicBounds.boundsType = model.type;
                NSLog(@"%@",model.type);
                basicBounds.type = indexPath.row;
                kNavPush(basicBounds);
            }
                break;
            case 1:
            {
                boundsModel *model = self.model.bouns[1];
                XPBasicBoundsViewController *basicBounds = [XPBasicBoundsViewController new];
                basicBounds.boundsType = model.type;
                NSLog(@"%@",model.type);
                basicBounds.type = indexPath.row;
                kNavPush(basicBounds);
            }
                break;
            case 2:
            {
                boundsModel *model = self.model.bouns[2];
                XPBasicBoundsViewController *basicBounds = [XPBasicBoundsViewController new];
                basicBounds.boundsType = model.type;
                NSLog(@"%@",model.type);
                basicBounds.type = indexPath.row;
                kNavPush(basicBounds);
            }
                break;
            case 3:
            {
//                [self showTips:kLocat(@"C_community_search_detai04_jijiangkaifa")];
                boundsModel *model = self.model.bouns[3];
                XPBasicBoundsViewController *basicBounds = [XPBasicBoundsViewController new];
                basicBounds.boundsType = model.type;
                NSLog(@"%@",model.type);
                basicBounds.type = indexPath.row;
                kNavPush(basicBounds);
//
//
//                kNavPush([XPBoundRewardViewController new]);
            }
                break; 
            default:
                break;
        }
    }else if (indexPath.section == 3){
        switch (indexPath.row) {
            case 0:
            {
                //                [self showTips:kLocat(@"C_community_search_detai04_jijiangkaifa")];
                boundsModel *model = self.model.bouns[4];
                XPManagerRewardViewController *recommend = [XPManagerRewardViewController new];
                recommend.type = indexPath.row;
                recommend.boundsType = model.type;
                kNavPush(recommend);
            }
                break;
            case 1:
            {
                boundsModel *model = self.model.bouns[5];
                XPManagerRewardViewController *level = [XPManagerRewardViewController new];
                level.type = indexPath.row;
                level.boundsType = model.type;
                kNavPush(level);
//                [self showTips:kLocat(@"C_community_search_detai04_jijiangkaifa")];

            }
                break;
            case 2:
            {
                boundsModel *model = self.model.bouns[6];
                XPManagerRewardViewController *community = [XPManagerRewardViewController new];
                community.type = indexPath.row;
                community.boundsType = model.type;
                kNavPush(community);
//                [self showTips:kLocat(@"C_community_search_detai04_jijiangkaifa")];

            }
                break;
            case 3:
            {
                boundsModel *model = self.model.bouns[7];
                XPManagerRewardViewController *manager = [XPManagerRewardViewController new];
                manager.type = indexPath.row;
                manager.boundsType = model.type;
                kNavPush(manager);
//                [self showTips:kLocat(@"C_community_search_detai04_jijiangkaifa")];

            }
                break;
            case 4:
            {
                kNavPush([XPMyMemberController new]);

                //                [self showTips:kLocat(@"C_community_search_detai04_jijiangkaifa")];
                
            }
                break;
            default:
                break;
        }
    }else if(indexPath.section == 4){
//        [self showTips:kLocat(@"C_community_search_detai04_jijiangkaifa")];
    }
    
    NSLog(@"%ld",indexPath.section);
}



@end
