//
//  TPMineViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/1.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPMineViewController.h"
#import "TPMineCommenCell.h"
#import "TPMineAvatarInfoCell.h"
#import "TPIdentifyViewController.h"
#import "TPAccountSafeController.h"
#import "XPWalletChibiCell.h"
#import "XPMineMoreItemCell.h"
#import "YWMineNickNameController.h"
#import "XPAccountPwdController.h"
#import "TPAccountSafeController.h"
#import "XPSetLanguagController.h"
#import "XPMineTableCell.h"


@interface TPMineViewController ()<UITableViewDelegate,UITableViewDataSource,XPMineTableCellTapDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)NSInteger identifyType;

@property(nonatomic,copy)NSString *inviteCode;
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,copy)NSString *phone;

@property (nonatomic, strong) UILabel *accountLabel;


@property(nonatomic,copy)NSString *invit_url;

@property(nonatomic,strong)TPMineAvatarInfoCell *topView;

@property(nonatomic,assign)BOOL firstLoad;


@end

@implementation TPMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstLoad = YES;
    [self setupUI];
//    [self loadData];

    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    if (_firstLoad == NO) {
        [self loadData];
//    }
 
    
}


-(void)setupUI
{
    self.title = kLocat(@"account");
    
    
    TPMineAvatarInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TPMineAvatarInfoCell" owner:self options:nil] lastObject];
    cell.frame = kRectMake(0, 0, kScreenW, 80);
    _topView = cell;
    [self.view addSubview:cell];
    __weak typeof(self)weakSelf = self;

    [cell.dismissButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.view.frame = kRectMake(0, kScreenH, kScreenW, kScreenH - kStatusBarHeight);

        } completion:^(BOOL finished) {
            [weakSelf.view.superview removeFromSuperview];
        }];
        
    }];
    
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,cell.bottom, kScreenW, kScreenH-cell.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"YWCircleSpaceListCell" bundle:nil] forCellReuseIdentifier:@"YWCircleSpaceListCell"];
    _tableView.backgroundColor = kTableColor;
    
    [_tableView registerNib:[UINib nibWithNibName:@"XPWalletChibiCell" bundle:nil] forCellReuseIdentifier:@"XPWalletChibiCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"XPMineMoreItemCell" bundle:nil] forCellReuseIdentifier:@"XPMineMoreItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"XPMineTableCell" bundle:nil] forCellReuseIdentifier:@"XPMineTableCell"];

    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:kLocat(@"x_Minesignout") forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightbBarButton addTarget:self action:@selector(exitAction) forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"TPMineAvatarInfoCell" bundle:nil] forCellReuseIdentifier:@"TPMineAvatarInfoCell"];

     [_tableView registerNib:[UINib nibWithNibName:@"TPMineCommenCell" bundle:nil] forCellReuseIdentifier:@"TPMineCommenCell"];
    
//    UIView *footerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 70)];
//    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(12, 20, kScreenW - 24, 45) title:@"安全退出" titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
//    kViewBorderRadius(button, 22.5, 0, kRedColor);
//    [button setBackgroundImage:kImageFromStr(@"loin_btn_loin") forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:button];
//    _tableView.tableFooterView = footerView;
  
    
}


-(void)loadData
{
    __weak typeof(self)weakSelf = self;
//    return;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Account/memberinfo"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        _firstLoad = NO;
        if (success) {
            kLOG(@"%@",responseObj);
            _dataDic = [responseObj ksObjectForKey:kData];
            NSDictionary *dic = [responseObj ksObjectForKey:kData][@"member"];
            
            YJUserInfo *model = kUserInfo;
//            model.avatar = dic[@"head"];
            model.userName = dic[@"name"];
            model.nickName = dic[@"nick"];
            model.securityphone = dic[@"phone"];
            model.securityEmail = dic[@"email"];

            _invit_url = dic[@"invit_url"];
            _inviteCode = ConvertToString(dic[@"invitation_code"]);
            [model saveUserInfo];
            _topView.accountLabel.text = model.nickName;
            _topView.nickNameLabel.text = [NSString stringWithFormat:@"ID：%zd",model.uid];
            //        [cell.avatar setImageWithURL:kUserInfo.avatar.ks_URL placeholder:kImageFromStr(@"user_icon_phto")];
            _topView.avatar.image = kImageFromStr(@"user_icon_phto");
            [_topView.modButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                [weakSelf _alertNicknameTextField];
            }];
            
//            [self.tableView reloadData];
        }else{
//            NSInteger code = [[responseObj ksObjectForKey:kCode] integerValue];
//            if (code == 10100) {//token失效
//                [kUserInfo clearUserInfo];
//                [self gotoLoginVC];
//            }
        }
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;

    
    static NSString *rid = @"XPMineTableCell";
    XPMineTableCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.contentView.tag = indexPath.section;
    if (indexPath.section == 0) {
        [cell setDataWithIcons:@[@"emll_icon",@"phone_icon",@"login_icon_",@"sec_icon"] titles:@[kLocat(@"x_Mineemail"),kLocat(@"x_Minephone"),kLocat(@"x_Minelogincode"),kLocat(@"x_Minesecuritycode")]];
    }else{
        [cell setDataWithIcons:@[@"yuyan_icon",@"about_icon",@"supp_icon",@"CU_icon"] titles:@[kLocat(@"x_MineLang"),kLocat(@"x_Mineabout"),kLocat(@"x_Minesupport"),kLocat(@"x_Minecontractus")]];
    }


    return cell;

    if (indexPath.section == 10) {
        static NSString *rid = @"TPMineAvatarInfoCell";
        TPMineAvatarInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        YJUserInfo *userInfo = kUserInfo;
        cell.accountLabel.text = userInfo.nickName;
        cell.nickNameLabel.text = [NSString stringWithFormat:@"ID：%zd",kUserInfo.uid];
//        [cell.avatar setImageWithURL:kUserInfo.avatar.ks_URL placeholder:kImageFromStr(@"user_icon_phto")];
        cell.avatar.image = kImageFromStr(@"user_icon_phto");
        [cell.modButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            kNavPushSafe([YWMineNickNameController new]);
            [self _alertNicknameTextField];
        }];

        return cell;
    }

    if (indexPath.section < 2) {
        static NSString *rid = @"XPWalletChibiCell";
        XPWalletChibiCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        if (indexPath.section == 0) {
            cell.volumeLabel.hidden = NO;
            cell.descW.constant = 126 ;
            cell.descLabel.adjustsFontSizeToFitWidth = YES;
            cell.volumeLabel.text = _inviteCode;
            cell.icon.image = kImageFromStr(@"yaoyue_icon_inte");
            cell.nameLabel.text = kLocat(@"x_MineinvitTitle");
            cell.descLabel.text = kLocat(@"x_Mineinvitcode");
            cell.supportLabel.text = kLocat(@"x_Mineinvitdesc");
            [cell.joinButton setTitle:@"Go" forState:UIControlStateNormal];
            [cell.joinButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                BaseWebViewController *vc = [BaseWebViewController webViewControllerWithURIString:_invit_url];
                kNavPushSafe(vc);
            }];

        }else{
            cell.volumeLabel.hidden = YES;
            cell.descW.constant = kScreenW - 76 - 67;
            cell.descLabel.adjustsFontSizeToFitWidth = NO;
            cell.nameLabel.text = _dataDic[@"boss_plan"][@"title"];
            cell.descLabel.text = _dataDic[@"boss_plan"][@"info"];
            //            cell.volumeLabel.text = [NSString stringWithFormat:@"%@%%",_dataDic[@"asset_bank"][@"rate"]];
            cell.supportLabel.text = _dataDic[@"boss_plan"][@"support"];
            cell.icon.image = kImageFromStr(@"bossi_icon_inte");
            [cell.joinButton setTitle:kLocat(@"x_MineJoin") forState:UIControlStateNormal];
            [cell.joinButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                [weakSelf showTips:kLocat(@"g_jqqd")];
            }];
        }
        return cell;
    }

//    static NSString *rid = @"XPMineMoreItemCell";
//    XPMineMoreItemCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
//    }
//
//    if (indexPath.section == 2) {
//
//        [cell configureItemInfoWithTitleArray:@[kLocat(@"x_Mineemail"),kLocat(@"x_Minephone"),kLocat(@"x_Minelogincode"),kLocat(@"x_Minesecuritycode")] icons:@[@"emll_icon",@"phone_icon",@"login_icon_",@"sec_icon"]];
//
//        [cell.button0 addTarget:self action:@selector(emailAction) forControlEvents:UIControlEventTouchUpInside];
//        [cell.button1 addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
//        [cell.button2 addTarget:self action:@selector(loginPWdAction) forControlEvents:UIControlEventTouchUpInside];
//        [cell.button3 addTarget:self action:@selector(payPWdAction) forControlEvents:UIControlEventTouchUpInside];
//
//    }else {
//        [cell configureItemInfoWithTitleArray:@[kLocat(@"x_MineLang"),kLocat(@"x_Mineabout"),kLocat(@"x_Minesupport"),kLocat(@"x_Minecontractus")] icons:@[@"yuyan_icon",@"about_icon",@"supp_icon_",@"CU_icon_"]];
//
//        [cell.button0 addTarget:self action:@selector(languageAction) forControlEvents:UIControlEventTouchUpInside];
//        [cell.button1 addTarget:self action:@selector(aboutAction) forControlEvents:UIControlEventTouchUpInside];
//        [cell.button2 addTarget:self action:@selector(suppportAction) forControlEvents:UIControlEventTouchUpInside];
//        [cell.button3 addTarget:self action:@selector(contractUsAction) forControlEvents:UIControlEventTouchUpInside];
//    }


    return cell;

}

-(void)xPMineTableCell:(XPMineTableCell *)cell didTapIndex:(NSInteger)index
{
    if (cell.contentView.tag == 0) {
        
    }else{
        
        
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return;
    if (indexPath.section == 0) {
        BaseWebViewController *vc = [BaseWebViewController webViewControllerWithURIString:_invit_url];
        kNavPush(vc);
    }else if (indexPath.section == 1) {
        [self showTips:kLocat(@"g_jqqd")];
    }
}





-(void)emailAction
{
    [self showTips:kLocat(@"g_jqqd")];
}
-(void)phoneAction
{
    [self showTips:kLocat(@"g_jqqd")];
}
-(void)loginPWdAction
{
    
    TPAccountSafeController *vc = [TPAccountSafeController new];
    vc.type = TPAccountSafeControllerTypeLoginPWD;
    kNavPush(vc);
//    XPAccountPwdController *vc = [XPAccountPwdController new];
//    vc.type = XPAccountPwdControllerTypeLoginFirst;
//    vc.phone = _phone;
//
//    kNavPush(vc);
}
-(void)payPWdAction
{
    XPAccountPwdController *vc = [XPAccountPwdController new];
    vc.type = XPAccountPwdControllerTypePayPWD;
    vc.phone = _phone;
    kNavPush(vc);
}
-(void)languageAction
{
    
//    kNavPush([XPSetLanguagController new]);
//
//    return;
    
    NSString *currenLan = [LocalizableLanguageManager userLanguage];
    
    kLOG(@"當前語言%@",currenLan);
    if (![currenLan containsString:@"en"]) {
        [kUserDefaults setBool:NO forKey:@"isTradition"];
        [LocalizableLanguageManager setUserlanguage:ENGLISH];
    }else{
        [kUserDefaults setBool:YES forKey:@"isTradition"];
        [LocalizableLanguageManager setUserlanguage:CHINESETradition];
    }
}
-(void)aboutAction
{
    BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:nil];
    vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,_dataDic[@"setting"][@"about"]];
    kNavPush(vc);
}
-(void)suppportAction
{
    BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:nil];
    vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,_dataDic[@"setting"][@"support"]];
    kNavPush(vc);
}
-(void)contractUsAction
{
    BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:nil];
    vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,_dataDic[@"setting"][@"contact"]];
    kNavPush(vc);
    
}






-(void)exitAction
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:kLocat(@"k_ConfirmLoginout") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *desAction = [UIAlertAction actionWithTitle:kLocat(@"net_alert_load_message_sure") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Account/logout"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [kUserInfo clearUserInfo];
                [self gotoLoginVC];
            }
        }];
        
        [self gotoLoginVC];
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"net_alert_load_message_cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:desAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
    
    if (showMore) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 38, 40) title:@"More" titleColor:kColorFromStr(@"#066B98") font:PFRegularFont(14) titleAlignment:0];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [view addSubview:button];
        [button alignVertical];
        button.right = kScreenW - 12;
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return view;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    return 210+5+5;
    if (indexPath.section == 10) {
        return 80;
    }else if(indexPath.section < 2){
        return 97+8;
    }else{
        return 108;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 15;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 10) {
        return 0.01;
    }else{
        return 50;
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 10) {
        return nil;
    }else if (section == 0){
        return [self createTopViewWithTitle:kLocat(@"x_MineInvite") showMore:NO action:nil];
    }else if (section == 1){
        return [self createTopViewWithTitle:kLocat(@"x_Minebooosplan") showMore:NO action:nil];
    }else if (section == 2){
        return [self createTopViewWithTitle:kLocat(@"x_Minesafesetting") showMore:NO action:nil];
    }else if (section == 3){
        return [self createTopViewWithTitle:kLocat(@"x_Minesetting") showMore:NO action:nil];
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    __weak typeof(self)weakSelf = self;
    if (scrollView.contentOffset.y < -50) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.view.frame = kRectMake(0, kScreenH, kScreenW, kScreenH - kStatusBarHeight);
        } completion:^(BOOL finished) {
            [weakSelf.view.superview removeFromSuperview];
        }];
    }
}


- (void)_alertNicknameTextField {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLocat(@"HBMemberViewController_set_nickname") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = kUserInfo.nickName;
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:kLocat(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *nickName = alertController.textFields.firstObject.text;
        [self modifyNick:nickName];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)modifyNick:(NSString *)nick {
    if (!nick) {
        return;
    }
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/Account/modifynick" parameters:@{@"nick" : nick ?: @""} success:^(YWNetworkResultModel *model, id responseObject) {
        
        kHideHud;
        if ([model succeeded]) {
            self.accountLabel.text = nick;
            YJUserInfo *mm = kUserInfo;
            mm.nickName = nick;
            [mm saveUserInfo];
//            [self.tableView reloadData];
            _topView.accountLabel.text = nick;
        } else {
            [self showTips:model.message];
        }
    } failure:^(NSError *error) {
        kHideHud;
        [self showTips:error.localizedDescription];
    }];
}

@end
