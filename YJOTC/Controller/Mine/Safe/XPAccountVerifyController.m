//
//  XPAccountVerifyController.m
//  YJOTC
//
//  Created by 周勇 on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAccountVerifyController.h"
#import "XPAccountSetPwdCell.h"
#import "UIButton+LSSmsVerification.h"
#import "XPAccountBindViewController.h"


@interface XPAccountVerifyController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NTESVerifyCodeManagerDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,strong)UIButton *codeButton;
@property(nonatomic,copy)NSString *verifyStr;

@property(nonatomic,strong)UITextField *phoneTF;
@property(nonatomic,strong)UITextField *codeTF;

@end

@implementation XPAccountVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self configureVerify];
}

-(void)configureVerify
{
    _manager = [NTESVerifyCodeManager sharedInstance];
    _manager.delegate = self;
    _manager.alpha = 0;
    _manager.frame = CGRectNull;
    _manager.lang = [Utilities getLangguageForNTESVerifyCode];
    NSString *captchaId = kVerifyKey;
    [_manager configureVerifyCode:captchaId timeout:7];
}
-(void)setupUI
{
    if (_type == XPAccountVerifyControllerEmail) {
        self.title = kLocat(@"A_changebindemail");
    }else{
        self.title = kLocat(@"A_changebindphone");
    }
    
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStyleGrouped];
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
    
    [_tableView registerNib:[UINib nibWithNibName:@"XPAccountSetPwdCell" bundle:nil] forCellReuseIdentifier:@"XPAccountSetPwdCell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 40+45)];
    footerView.backgroundColor = kTableColor;
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(12, 40, kScreenW - 24, 45) title:kLocat(@"OTC_post_next") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [footerView addSubview:button];
    kViewBorderRadius(button, 8, 0, kRedColor);
    button.backgroundColor = kMainColor;
    _tableView.tableFooterView = footerView;
    
    [button addTarget:self action:@selector(finishiAction) forControlEvents:UIControlEventTouchUpInside];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"XPAccountSetPwdCell";
    XPAccountSetPwdCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
//    cell.TF.keyboardType = UIKeyboardTypeNumberPad;
    if (indexPath.row == 0 ) {
        cell.bottomC.constant = 0;
        cell.TF.userInteractionEnabled = NO;
        if (_type == XPAccountVerifyControllerEmail) {
            cell.descLabel.text = kLocat(@"A_plzenteroriginalemail");
            cell.TF.text = kUserInfo.securityEmail;
        }else{
            cell.descLabel.text = kLocat(@"A_plzenteroriginalphone");
            cell.TF.text = kUserInfo.securityphone;

        }
        cell.TF.placeholder = cell.descLabel.text;
        cell.codeButton.hidden = YES;
        _phoneTF = cell.TF;
        cell.countryButton.hidden = YES;
        
    }else{
        cell.TF.userInteractionEnabled = YES;

        cell.bottomC.constant = 20;
        if (_type == XPAccountVerifyControllerEmail) {
            cell.descLabel.text = kLocat(@"A_plzenteroriginalemailcode");
        }else{
            cell.descLabel.text = kLocat(@"A_plzenteroriginalphonecodel");
            cell.countryButton.hidden = YES;
//            [cell.countryButton addTarget:self action:@selector(showCountryChooseView) forControlEvents:UIControlEventTouchUpInside];
//            _countryOfCodeButton = cell.countryButton;
        }
        cell.TF.placeholder = cell.descLabel.text;
        cell.codeButton.hidden = NO;
        _codeButton = cell.codeButton;
        [cell.codeButton addTarget:self action:@selector(showVerifyInfo) forControlEvents:UIControlEventTouchUpInside];
        _codeTF = cell.TF;
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100-20;
    }else{
        return 100;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
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

-(void)showVerifyInfo
{
    [self.view endEditing:YES];
    
    if (_phoneTF.text.length == 0) {
        if (_type == XPAccountVerifyControllerPhone) {
            [self showTips:kLocat(@"A_plzenterphonenumber")];
        }else{
            [self showTips:kLocat(@"LEnterEamil")];
        }
        
        return;
    }
    
    [self.manager openVerifyCodeView:nil];
    
}
- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    
    if (result == YES) {
        _verifyStr = validate;
        [self sendCodeAction];
    }else{
        [self showTips:kLocat(@"OTC_buylist_codeerror")];
        _verifyStr = nil;
        
    }
}
-(void)sendCodeAction
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"validate"] = _verifyStr;
    
    NSString *url = kSenderSMS;
    if (_type == XPAccountVerifyControllerEmail) {
        url = kSendEmail;
        param[@"type"] = @"modifyemail";
        param[@"email"] = kUserInfo.email;
    }else if (_type == XPAccountVerifyControllerPhone){
        param[@"type"] = @"modifyphone";
        param[@"phone"] = kUserInfo.phone;
    }
    kShowHud;
    [self hideKeyBoard];
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:url] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self.codeButton startTimeWithDuration:60];
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


-(void)finishiAction
{
    [self hideKeyBoard];

    if (_codeTF.text.length == 0) {
        [self showTips:kLocat(@"LEnterVerificationCode")];
    }
    NSString *url;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    if (_type == XPAccountVerifyControllerEmail) {
        url = @"/Email/check";
        param[@"email"] = kUserInfo.email;
        param[@"email_code"] = _codeTF.text;
        param[@"type"] = @"modifyemail";

    }else{
        url = @"/Sms/check";
        param[@"phone"] = kUserInfo.phone;
        param[@"phone_code"] = _codeTF.text;
        param[@"type"] = @"modifyphone";
    }
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:url] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                XPAccountBindViewController *vc = [XPAccountBindViewController new];
                if (_type == XPAccountVerifyControllerEmail) {
                    vc.type = XPAccountBindViewControllerSecondEmail;
                }else{
                    vc.type = XPAccountBindViewControllerSecondPhone;
                }
                vc.oldCode = _codeTF.text;
                kNavPush(vc);
                
            });
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
        
    }];
}

- (NTESVerifyCodeManager *)manager {
    if (!_manager) {
        _manager = [NTESVerifyCodeManager sharedInstance];
        _manager.delegate = self;
        _manager.alpha = 0;
        _manager.frame = CGRectNull;
        _manager.lang = [Utilities getLangguageForNTESVerifyCode];
        NSString *captchaId = kVerifyKey;
        [_manager configureVerifyCode:captchaId timeout:7];
    }
    return _manager;
}

@end
