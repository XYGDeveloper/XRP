//
//  XPAccountBindViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAccountBindViewController.h"
#import "XPAccountSetPwdCell.h"
#import "UIButton+LSSmsVerification.h"
#import "ICNNationalityModel+Request.h"
#import "HBSelectCodeOfCountryView.h"


@interface XPAccountBindViewController ()<HBSelectCodeOfCountryViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NTESVerifyCodeManagerDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,strong)UIButton *codeButton;
@property(nonatomic,copy)NSString *verifyStr;

@property(nonatomic,strong)UITextField *phoneTF;
@property(nonatomic,strong)UITextField *codeTF;

@property(nonatomic,strong)ICNNationalityModel *selectedCountryModel;
@property(nonatomic,strong)UIButton *countryOfCodeButton;
@property (nonatomic, strong) NSArray<ICNNationalityModel *> *codesOfCountry;


@end

@implementation XPAccountBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadCountryInfo];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)loadCountryInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else{//泰文
        lang = @"zh-tw";
    }
    param[@"language"] = lang;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Account/countrylist"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        if (success) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in [responseObj ksObjectForKey:kData]) {
                [arr addObject:[ICNNationalityModel modelWithJSON:dic]];
            }
            self.codesOfCountry = arr;
        }
    }];
}

-(void)setupUI
{
    if (_type == XPAccountBindViewControllerTypeEmail || _type == XPAccountBindViewControllerSecondEmail) {
        self.title = kLocat(@"A_bindemail");
    }else{
        self.title = kLocat(@"A_bindphone");
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
        if (_type == XPAccountBindViewControllerTypeEmail || _type == XPAccountBindViewControllerSecondEmail) {
            cell.descLabel.text = kLocat(@"A_plzenternewemail");
        }else{
            cell.descLabel.text = kLocat(@"A_plzenternewphone");
        }
        cell.TF.placeholder = cell.descLabel.text;
        cell.codeButton.hidden = YES;
        _phoneTF = cell.TF;
        cell.countryButton.hidden = YES;
        
    }else{
        cell.bottomC.constant = 20;
        if (_type == XPAccountBindViewControllerTypeEmail || _type == XPAccountBindViewControllerSecondEmail) {
            cell.descLabel.text = kLocat(@"A_plzverifynewemail");
        }else{
            cell.descLabel.text = kLocat(@"A_plzverifynewphone");
            cell.countryButton.hidden = NO;
            [cell.countryButton addTarget:self action:@selector(showCountryChooseView) forControlEvents:UIControlEventTouchUpInside];
            _countryOfCodeButton = cell.countryButton;
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
#pragma mark - 點擊事件

-(void)showVerifyInfo
{
    [self.view endEditing:YES];
 
    if (_phoneTF.text.length == 0) {
        if (_type == XPAccountBindViewControllerTypeEmail || _type == XPAccountBindViewControllerSecondEmail) {
            [self showTips:kLocat(@"LEnterEamil")];
        }else{
            [self showTips:kLocat(@"A_plzenterphonenumber")];
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
    if (_type == XPAccountBindViewControllerTypeEmail || _type == XPAccountBindViewControllerSecondEmail) {
        url = kSendEmail;
        param[@"type"] = @"bindemail";
        param[@"email"] = _phoneTF.text;
    }else {
        param[@"type"] = @"bindphone";
        param[@"phone"] = _phoneTF.text;
        if (_selectedCountryModel) {
            param[@"country_code"] = _selectedCountryModel.countrycode;
        }else{
            param[@"country_code"] = @"86";
        }
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
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    NSString *url;
    if (_type == XPAccountBindViewControllerTypeEmail) {
        if (_phoneTF.text.length == 0) {
            [self showTips:kLocat(@"LEnterEamil")];
            return;
        }
        url = @"/Account/bindemail";
        param[@"email"] = _phoneTF.text;
        param[@"email_code"] = _codeTF.text;
    }else if (_type == XPAccountBindViewControllerTypePhone){
        if (_phoneTF.text.length == 0) {
            [self showTips:kLocat(@"A_plzenterphonenumber")];
            return;
        }
        url = @"Account/bindphone";
        param[@"phone"] = _phoneTF.text;
        param[@"phone_code"] = _codeTF.text;
        if (_selectedCountryModel) {
            param[@"countrycode"] = _selectedCountryModel.countrycode;
        }else{
            param[@"countrycode"] = @"86";
        }
    }else if (_type == XPAccountBindViewControllerSecondEmail){
        if (_phoneTF.text.length == 0) {
            [self showTips:kLocat(@"LEnterEamil")];
            return;
        }
        url = @"/Account/modifyemail";
        param[@"new_email"] = _phoneTF.text;
        param[@"new_email_code"] = _codeTF.text;
        param[@"email_code"] = _oldCode;
        
    }else if (_type == XPAccountBindViewControllerSecondPhone){
        if (_phoneTF.text.length == 0) {
            [self showTips:kLocat(@"A_plzenterphonenumber")];
            return;
        }
        url = @"/Account/modifyphone";
        
        param[@"new_phone"] = _phoneTF.text;
        param[@"new_phone_code"] = _codeTF.text;
        param[@"phone_code"] = _oldCode;
        
        if (_selectedCountryModel) {
            param[@"country_code"] = _selectedCountryModel.countrycode;
        }else{
            param[@"country_code"] = @"86";
        }
    }
    if (_codeTF.text.length == 0) {
        [self showTips:kLocat(@"LEnterVerificationCode")];
        return;
    }
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:url] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popToRootViewControllerAnimated:YES];
                
                [kUserInfo clearUserInfo];
                [self gotoLoginVC];
            });
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
        
    }];
    
}

-(void)showCountryChooseView
{
    HBSelectCodeOfCountryView *view = [HBSelectCodeOfCountryView viewLoadNib];
    view.codesOfCountry = self.codesOfCountry;
    view.delegate = self;
    [view showInWindow];
}
- (void)selectCodeOfCountryView:(HBSelectCodeOfCountryView *)view didSelectModel:(ICNNationalityModel *)model {
    [self.countryOfCodeButton setTitle:[NSString stringWithFormat:@"%@ ", model.name] forState:UIControlStateNormal];
    _selectedCountryModel = model;
//    self.codeOfCountryLabel.text = [NSString stringWithFormat:@"+%@",model.countrycode];
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
