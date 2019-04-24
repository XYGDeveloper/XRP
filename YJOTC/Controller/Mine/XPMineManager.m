//
//  XPMineManager.m
//  YJOTC
//
//  Created by 周勇 on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMineManager.h"
#import "TPMineViewController.h"
#import "XPMineTableCell.h"
#import "TPMineAvatarInfoCell.h"
#import <ACAlertController.h>
#import "XPSetLanguagController.h"
#import "XPAccountPwdController.h"
#import "TPAccountSafeController.h"
#import "XPAccountBindViewController.h"
#import "XPAccountVerifyController.h"
#import "XPWalletChibiCell.h"
#import "XNIdentifyViewController.h"
#import "XPIdentifySuccessController.h"

@interface XPMineManager ()<UITableViewDelegate,UITableViewDataSource,XPMineTableCellTapDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)TPMineAvatarInfoCell *topView;
//@property (nonatomic, strong) UILabel *accountLabel;

@property(nonatomic,strong)NSDictionary *dataDic;

@property(nonatomic,strong)YJBaseViewController *vc;

@property(nonatomic,copy)NSString *phone;

@property(nonatomic,copy)NSString *invit_url;
@property(nonatomic,copy)NSString *inviteCode;


@end

@implementation XPMineManager


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self showMineView];
    }
    
    return self;
}

-(void)showMineView
{
    // 创建BezierPath 并设置角 和 半径 这里只设置了 右上 和 右下
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
    
    self.backgroundColor = kTableColor;
    
    _vc = (YJBaseViewController *)[kKeyWindow visibleViewController];
    [self setupUI];
    [self loadData];
 
}
-(void)setupUI
{

    TPMineAvatarInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TPMineAvatarInfoCell" owner:self options:nil] lastObject];
    cell.frame = kRectMake(0, 0, kScreenW, 80);
    _topView = cell;
    [self addSubview:cell];
    [cell.dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [cell.modButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self _alertNicknameTextField];
    }];

    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,cell.bottom, kScreenW, kScreenH-cell.height - kStatusBarHeight) style:UITableViewStyleGrouped];
    [self addSubview:_tableView];
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
    

    [_tableView registerNib:[UINib nibWithNibName:@"XPMineTableCell" bundle:nil] forCellReuseIdentifier:@"XPMineTableCell"];
    

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    
    UIView *footerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 85)];
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(12, 20, kScreenW - 24, 45) title:kLocat(@"x_Minesignout") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    kViewBorderRadius(button, 8, 0, kRedColor);
    [button addShadow];
    button.backgroundColor = kColorFromStr(@"#6189C5");
    [button addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    _tableView.tableFooterView = footerView;
    
    
}

-(void)loadData
{
//    __weak typeof(self)weakSelf = self;
    //    return;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Account/memberinfo"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
//        _firstLoad = NO;
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
            model.avatar = dic[@"head"];
            model.userName = dic[@"name"];
            model.verify_state = ConvertToString(dic[@"verify_state"]);
            
            _invit_url = dic[@"invit_url"];
            _inviteCode = ConvertToString(dic[@"invitation_code"]);
            [model saveUserInfo];
            _topView.accountLabel.text = model.nickName;
            _topView.nickNameLabel.text = [NSString stringWithFormat:@"ID：%zd",model.uid];
            //        [cell.avatar setImageWithURL:kUserInfo.avatar.ks_URL placeholder:kImageFromStr(@"user_icon_phto")];
            _topView.avatar.image = kImageFromStr(@"user_icon_phto");
//            [_topView.avatar setImageWithURL:kUserInfo.avatar.ks_URL placeholder:kImageFromStr(@"user_icon_phto")];
            [self.tableView reloadData];
            
            //            [self.tableView reloadData];
        }else{
        
        }
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.section == 0) {
        static NSString *rid = @"XPWalletChibiCell";
        XPWalletChibiCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.volumeLabel.hidden = NO;
        cell.descW.constant = 126 ;
        cell.descLabel.adjustsFontSizeToFitWidth = YES;
        cell.volumeLabel.text = _inviteCode;
        cell.icon.image = kImageFromStr(@"yaoyue_icon_inte");
        cell.nameLabel.text = kLocat(@"x_MineinvitTitle");
        cell.descLabel.text = kLocat(@"x_Mineinvitcode");
        cell.supportLabel.text = kLocat(@"x_Mineinvitdesc");
        [cell.joinButton setTitle:@"Go" forState:UIControlStateNormal];
        return cell;
    }
    
    static NSString *rid = @"XPMineTableCell";
    XPMineTableCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.contentView.tag = indexPath.section;
    if (indexPath.section == 1) {
        cell.isAuth = YES;
        NSString *phone;
        NSString *email;
        
        if (kUserInfo.securityphone.length < 2) {
            phone = kLocat(@"A_bindphone");
        }else{
            phone = kLocat(@"A_changephone");
        }
        if (kUserInfo.securityEmail.length < 2) {
            email = kLocat(@"A_bindemail");
        }else{
            email = kLocat(@"A_changeemail");
        }
 
        //kLocat(@"x_Mineemail"),kLocat(@"x_Minephone")
        [cell setDataWithIcons:@[@"emll_icon",@"phone_icon",@"login_icon_",@"sec_icon"] titles:@[email,phone,kLocat(@"x_Minelogincode"),kLocat(@"x_Minesecuritycode")]];
        /**  verify_state实名认证状态 -1未认证 0未通过 1:已认证 2: 审核中  */
        if (kUserInfo.verify_state.intValue == -1) {
            cell.statusLabel.text = kLocat(@"s_NOAuth");
        }else if (kUserInfo.verify_state.intValue == 0){
            cell.statusLabel.text = kLocat(@"s_nopass");
        }else if (kUserInfo.verify_state.intValue == 1){
            cell.statusLabel.text = kLocat(@"s_checked");
        }else if (kUserInfo.verify_state.intValue == 2){
            cell.statusLabel.text = kLocat(@"W_checking");
        }
        
        cell.icon5.image = kImageFromStr(@"smrz_icon");
       cell.label5.text = kLocat(@"s_shimingrenzheng");

    }else{
        cell.isAuth = YES;
        cell.icon5.image = kImageFromStr(@"kefu_icon_new");
        cell.statusLabel.text = @"";
        cell.label5.text = kLocat(@"s_0301_kfly");

        [cell setDataWithIcons:@[@"yuyan_icon",@"about_icon_mine",@"supp_icon",@"CU_icon"] titles:@[kLocat(@"x_MineLang"),kLocat(@"x_Mineabout"),kLocat(@"x_Minesupport"),kLocat(@"x_Minecontractus")]];
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 97+8;
    }
    
    if (indexPath.section == 1) {
        return 210+50;
    }else{
        return 210+50;

//        return 210;
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
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return [self createTopViewWithTitle:kLocat(@"x_MineInvite") showMore:NO action:nil];
    }else if (section == 1){
        return [self createTopViewWithTitle:kLocat(@"x_Minesafesetting") showMore:NO action:nil];
    }else if (section == 2){
        return [self createTopViewWithTitle:kLocat(@"x_Minesetting") showMore:NO action:nil];
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
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (scrollView.contentOffset.y < -50) {
        [self dismiss];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BaseWebViewController *vc = [BaseWebViewController webViewControllerWithURIString:self.invit_url];
        [self.vc.navigationController pushViewController:vc animated:YES];
        [self dismiss];
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
    
    [[kKeyWindow visibleViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)modifyNick:(NSString *)nick {
    if (!nick) {
        return;
    }
    [kKeyWindow showHUD];
    [kNetwork_Tool objPOST:@"Api/Account/modifynick" parameters:@{@"nick" : nick ?: @""} success:^(YWNetworkResultModel *model, id responseObject) {
        [kKeyWindow hideHUD];

//        kHideHud;
        if ([model succeeded]) {
//            self.accountLabel.text = nick;
            YJUserInfo *mm = kUserInfo;
            mm.nickName = nick;
            [mm saveUserInfo];
            //            [self.tableView reloadData];
            _topView.accountLabel.text = nick;
        } else {
            
            [kKeyWindow showWarning:model.message];
//            [self showTips:model.message];
        }
    } failure:^(NSError *error) {
        [kKeyWindow hideHUD];
//        [self showTips:error.localizedDescription];
    }];
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


-(void)dismiss
{
    _vc.tabBarController.tabBar.hidden = NO;

    [UIView animateWithDuration:0.25 animations:^{
        self.frame = kRectMake(0, kScreenH, kScreenW, kScreenH - kStatusBarHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)exitAction
{
    ACAlertController *alertVc = [[ACAlertController alloc]initWithActionSheetTitles:@[kLocat(@"net_alert_load_message_sure")] cancelTitle:LocalizedString(@"Cancel")];
    alertVc.cancelButtonTextFont = PFRegularFont(14);
    alertVc.cancelButtonTextColor = k323232Color;
    alertVc.actionButtonsTextFont = PFRegularFont(14);
    alertVc.actionButtonsTextColor = kRedColor;
    
    
    [alertVc clickActionButton:^(NSInteger index) {
        if (index == 0) {//拍照
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            
            param[@"key"] = kUserInfo.token;
            param[@"token_id"] = @(kUserInfo.uid);
            //        kShowHud;
            [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Account/logout"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
                //            kHideHud;
                if (success) {
                    [self dismiss];
                    [kUserInfo clearUserInfo];
                    [_vc gotoLoginVC];
                }
            }];
        }
    }];
    [alertVc show];
}


-(void)xPMineTableCell:(XPMineTableCell *)cell didTapIndex:(NSInteger)index
{
    [self dismiss];
    
    if (cell.contentView.tag == 1) {
        switch (index) {
            case 0:
            {
                
                if (kUserInfo.securityEmail.length < 2) {
                    XPAccountBindViewController *vc = [XPAccountBindViewController new];
                    vc.type = XPAccountBindViewControllerTypeEmail;
                    [_vc.navigationController pushViewController:vc animated:YES];
                }else{
                    XPAccountVerifyController *vc = [XPAccountVerifyController new];
                    vc.type = XPAccountVerifyControllerEmail;
                    [_vc.navigationController pushViewController:vc animated:YES];

                }

            }
                break;
            case 1:
            {
                if (kUserInfo.securityphone.length < 2) {
                    XPAccountBindViewController *vc = [XPAccountBindViewController new];
                    vc.type = XPAccountBindViewControllerTypePhone;
                    [_vc.navigationController pushViewController:vc animated:YES];
                }else{
                    XPAccountVerifyController *vc = [XPAccountVerifyController new];
                    vc.type = XPAccountVerifyControllerPhone;
                    [_vc.navigationController pushViewController:vc animated:YES];
                }
                
            }
                break;
            case 2:
            {
                TPAccountSafeController *vc = [TPAccountSafeController new];
                vc.type = TPAccountSafeControllerTypeLoginPWD;
                [_vc.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                
                if (kUserInfo.securityphone.length  < 3) {
                    [kKeyWindow showWarning:kLocat(@"A_plzbindphonefirst")];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        XPAccountBindViewController *vc = [XPAccountBindViewController new];
                        vc.type = XPAccountBindViewControllerTypePhone;
                        [_vc.navigationController pushViewController:vc animated:YES];
                    });
                }else{
                    XPAccountPwdController *vc = [XPAccountPwdController new];
                    vc.type = XPAccountPwdControllerTypePayPWD;
                    vc.phone = _phone;
                    [_vc.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
                case 4:
            {
                /**  verify_state实名认证状态 -1未认证 0未通过 1:已认证 2: 审核中  */
                if (kUserInfo.verify_state.intValue <= 0) {
                    XNIdentifyViewController *vc = [XNIdentifyViewController new];
                    [_vc.navigationController pushViewController:vc animated:YES];
                }else if (kUserInfo.verify_state.intValue == 1){
                    XPIdentifySuccessController *vc = [XPIdentifySuccessController new];
                    vc.dataDic = _dataDic;
                    [_vc.navigationController pushViewController:vc animated:YES];
                }else if (kUserInfo.verify_state.intValue == 2){
//                    cell.statusLabel.text = kLocat(@"W_checking");
                    return;
                }
            }
                break;
                
            default:
                break;
        }
        
    }else{
        switch (index) {
            case 0:
            {
//                [kKeyWindow showWarning:kLocat(@"g_jqqd")];
//                return;
                
                XPSetLanguagController *vc = [XPSetLanguagController new];
                [_vc.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                [self gotoWebViewWith:_dataDic[@"setting"][@"about"]];
            }
                break;
            case 2:
            {
                [self gotoWebViewWith:_dataDic[@"setting"][@"support"]];
            }
                break;
            case 3:
            {
                [self gotoWebViewWith:_dataDic[@"setting"][@"contact"]];
            }
                break;
            case 4:
            {
                if ([_dataDic[@"setting"][@"kf"] length] > 2) {
                    [self gotoWebViewWith:_dataDic[@"setting"][@"kf"]];
                }else{
                    [kKeyWindow showWarning:kLocat(@"g_jqqd")];
                }
            }
                break;
            default:
                break;
        }
    }
}
-(void)gotoWebViewWith:(NSString *)urlStr
{
    BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:nil];
    vc.urlStr = urlStr;
    vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,urlStr];
    
    [_vc.navigationController pushViewController:vc animated:YES];
}
@end
