

//
//  XPAccountPwdController.m
//  YJOTC
//
//  Created by Roy on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAccountPwdController.h"
#import "XPAccountSetPwdCell.h"
#import "UIButton+LSSmsVerification.h"

@interface XPAccountPwdController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NTESVerifyCodeManagerDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@property(nonatomic,strong)UIButton *codeButton;

@property(nonatomic,strong)UITextField *codeTF;
@property(nonatomic,strong)UITextField *pwd1TF;
@property(nonatomic,strong)UITextField *pwd2TF;
@property(nonatomic,copy)NSString *verifyStr;



@end

@implementation XPAccountPwdController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupUI];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)setupUI
{
    if (_type == XPAccountPwdControllerTypePayPWD) {
        self.title = kLocat(@"k_ModifysetViewController_title");
    }else{
        self.title = kLocat(@"k_ModifyLoginsetViewController_title");
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
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(12, 40, kScreenW - 24, 45) title:kLocat(@"k_BindsetViewController_t4") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [footerView addSubview:button];
    kViewBorderRadius(button, 8, 0, kRedColor);
    button.backgroundColor = kMainColor;
    _tableView.tableFooterView = footerView;
    
    [button addTarget:self action:@selector(finishiAction) forControlEvents:UIControlEventTouchUpInside];
    
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
        return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"XPAccountSetPwdCell";
    XPAccountSetPwdCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.TF.keyboardType = UIKeyboardTypeNumberPad;
    if (indexPath.row == 0 && indexPath.section == 1) {
        cell.bottomC.constant = 0;
    }else{
        cell.bottomC.constant = 20;
    }
    if (indexPath.row == 0 && indexPath.section == 0) {
        cell.showCodeButton = YES;
        cell.codeButton.hidden = NO;
        cell.TF.secureTextEntry = NO;
        [cell.codeButton addTarget:self action:@selector(showVerifyInfo) forControlEvents:UIControlEventTouchUpInside];
        _codeButton = cell.codeButton;
    }else{
        cell.showCodeButton = NO;
        cell.TF.secureTextEntry = YES;

    }
    
    if (indexPath.section == 0 &&indexPath.row == 0) {
        
        
        if (_type == XPAccountPwdControllerTypeLoginOldPWD) {
            cell.showCodeButton = NO;
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;
            cell.TF.placeholder = kLocat(@"k_ModifyLoginsetViewController_t1");
            cell.descLabel.text = kLocat(@"k_ModifyLoginsetViewController_t1");
            cell.TF.secureTextEntry = YES;
            
        }else if(_type == XPAccountPwdControllerTypeLoginPhone){
            
            cell.descLabel.text = kLocat(@"k_Thecodetourphonereceive");
            cell.descLabel.text = [cell.descLabel.text stringByReplacingOccurrencesOfString:@"000" withString:kUserInfo.securityphone];
            cell.TF.placeholder = kLocat(@"k_BindphoneViewController_t2");
            
        }else if(_type == XPAccountPwdControllerTypeLoginEmail){
            cell.descLabel.text = kLocat(@"k_ThecodetourEmailreceive");
            cell.descLabel.text = [cell.descLabel.text stringByReplacingOccurrencesOfString:@"000" withString:kUserInfo.securityEmail];
            cell.TF.placeholder = kLocat(@"k_BindphoneViewController_t2");
        }else{
            if (kUserInfo.securityphone.length > 2) {
                cell.descLabel.text = kLocat(@"k_Thecodetourphonereceive");
                cell.descLabel.text = [cell.descLabel.text stringByReplacingOccurrencesOfString:@"000" withString:kUserInfo.securityphone];
                cell.TF.placeholder = kLocat(@"k_BindphoneViewController_t2");
            }else{
                cell.descLabel.text = kLocat(@"k_ThecodetourEmailreceive");
                cell.descLabel.text = [cell.descLabel.text stringByReplacingOccurrencesOfString:@"000" withString:kUserInfo.securityEmail];
                cell.TF.placeholder = kLocat(@"k_BindphoneViewController_t2");
            }
        }

        _codeTF = cell.TF;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        if (_type == XPAccountPwdControllerTypePayPWD) {
            cell.descLabel.text = kLocat(@"k_ModifysetViewController_t2");
            cell.TF.placeholder = kLocat(@"k_ModifysetViewController_t2");
            cell.TF.keyboardType = UIKeyboardTypeNumberPad;
        }else if(XPAccountPwdControllerTypeLoginPhone){
            cell.descLabel.text = kLocat(@"k_ModifyLoginViewController_t2");
            cell.TF.placeholder = kLocat(@"k_ModifyLoginViewController_t2");
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;

        }

        _pwd1TF = cell.TF;
    }else{
        if (_type == XPAccountPwdControllerTypePayPWD) {
            cell.TF.keyboardType = UIKeyboardTypeNumberPad;

            cell.descLabel.text = kLocat(@"k_ModifysetViewController_t3");
            cell.TF.placeholder = kLocat(@"k_ModifysetViewController_t3");
        }else if(XPAccountPwdControllerTypeLoginPhone){
            cell.descLabel.text = kLocat(@"k_ModifyLoginViewController_t3");
            cell.TF.placeholder = kLocat(@"k_ModifyLoginViewController_t3");
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;

        }
        _pwd2TF = cell.TF;
    }
    
    
    
    
    cell.TF.delegate = self;
    return cell;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _codeTF) {
        if (_type == XPAccountPwdControllerTypeLoginOldPWD) {
            return YES;
        }else{
            
            if (textField.text.length > 5 && ![string isEqualToString:@""]) {
                return NO;
            }else{
                return YES;
            }
        }
    }
    
    if (_type == XPAccountPwdControllerTypePayPWD) {
        if (textField.text.length > 5 && ![string isEqualToString:@""]) {
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else {
        if (indexPath.row == 0) {
            return 100-20;
        }else{
            return 100;
        }
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

#pragma mark - 点击事件

-(void)finishiAction
{
    [self hideKeyBoard];
    
    if (_type != XPAccountPwdControllerTypeLoginOldPWD) {
        
        if (_codeTF.text.length == 0) {
            [self showTips:kLocat(@"LEnterVerificationCode")];
            return;
        }
    }
    
    
    if (_type != XPAccountPwdControllerTypeLoginOldPWD) {
        if (_verifyStr.length < 2) {
            [self showTips:kLocat(@"LGetVerifyCodeFirst")];
            return;
        }
    }
    
    
    
    if (_type == XPAccountPwdControllerTypeLoginPhone || _type == XPAccountPwdControllerTypeLoginEmail         ) {//短信修改登錄密碼
        if (_pwd1TF.text.length == 0 || _pwd2TF.text.length == 0) {

            [self showTips:kLocat(@"Z_EnterNewLoginPWDTips")];

            return;
        }
        
        if (![_pwd1TF.text isEqualToString:_pwd2TF.text]) {
            [self showTips:kLocat(@"LLoginPWDNotSame")];

            return;
        }
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"pwd"]  = _pwd1TF.text;
        param[@"repwd"] = _pwd2TF.text;
        param[@"phone_code"] = _codeTF.text;
        
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Account/modifypwd"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [self showTips:[responseObj ksObjectForKey:kMessage]];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [kUserInfo clearUserInfo];
                    [self gotoLoginVC];
                });
            }else{
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }else if(_type == XPAccountPwdControllerTypePayPWD){//修改安全密碼
        
        if (_pwd1TF.text.length == 0 || _pwd2TF.text.length == 0) {
            [self showTips:kLocat(@"k_ModifysetViewController_t2")];

            return;
        }
        
        if (![_pwd1TF.text isEqualToString:_pwd2TF.text]) {
            [self showTips:kLocat(@"LPayPWDNotSame")];
            return;
        }
        kShowHud;
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"pwd"]  = _pwd1TF.text;
        param[@"repwd"] = _pwd2TF.text;
        param[@"phone_code"] = _codeTF.text;

        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Account/retradepass"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            if (success) {
                [self showTips:[responseObj ksObjectForKey:kMessage]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backAction];
                });
            }else{
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }else if (_type == XPAccountPwdControllerTypeLoginOldPWD){//舊密码修改登錄密碼
        
        if (_codeTF.text.length == 0) {

            [self showTips:kLocat(@"LPayPWDNotSame")];
            return;
        }
    
        
        if (_pwd1TF.text.length == 0 || _pwd2TF.text.length == 0) {

            [self showTips:kLocat(@"Z_EnterNewLoginPWDTips")];

            return;
        }
        
        if (![_pwd1TF.text isEqualToString:_pwd2TF.text]) {

            [self showTips:kLocat(@"LLoginPWDNotSame")];

            return;
        }
        if ([_codeTF.text isEqualToString:_pwd1TF.text]) {

            [self showTips:kLocat(@"k_pwdissame")];

            return;
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"pwd"]  = _pwd1TF.text;
        param[@"repwd"] = _pwd2TF.text;
        param[@"oldpwd"] = _codeTF.text;

        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Account/repass"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [self showTips:[responseObj ksObjectForKey:kMessage]];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [kUserInfo clearUserInfo];
                    [self gotoLoginVC];
                });
            }else{
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }
}




-(void)showVerifyInfo
{
    [self.view endEditing:YES];
    
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
    if (_type == XPAccountPwdControllerTypePayPWD) {
//        if (kUserInfo.securityEmail.length > 0) {
//            url = @"/Email/code";
//        }
        param[@"type"] = @"retradepwd";
    }else if (_type == XPAccountPwdControllerTypeLoginPhone){
        param[@"type"] = @"modifypwd";
    }else if(_type == XPAccountPwdControllerTypeLoginEmail){
        param[@"type"] = @"modifypwd";
        url = @"/Email/code";
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
