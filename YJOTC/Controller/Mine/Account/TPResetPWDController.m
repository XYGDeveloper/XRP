


//
//  TPResetPWDController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/6.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPResetPWDController.h"
#import "TPResetPWDCell.h"

@interface TPResetPWDController ()<UITableViewDelegate,UITableViewDataSource,NTESVerifyCodeManagerDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *loginArr;
@property(nonatomic,strong)NSArray *transactionArr;

@property(nonatomic,assign)NSInteger second;
@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)UITextField *oldTF;
@property(nonatomic,strong)UITextField *nwTF;
@property(nonatomic,strong)UITextField *confirmTF;

@property(nonatomic,strong)UITextField *userNameTF;
@property(nonatomic,strong)UITextField *nwTraTF;
@property(nonatomic,strong)UITextField *confirmTraTF;
@property(nonatomic,strong)UITextField *codeTF;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@property(nonatomic,copy)NSString *verifyStr;
@property(nonatomic,assign)NSInteger verifyCode;

@property(nonatomic,strong)UIButton *sendButton;


@end

@implementation TPResetPWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    _second = 60;
    
    [self setupUI];
    [self initVerifyConfigure];
}
-(void)setupUI
{
    if (_TPResetPWDType == TPResetPWDTypeLogin) {
        self.title = @"修改登錄密碼";
    }else{
        self.title = @"修改交易密碼";
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
    _tableView.backgroundColor = kColorFromStr(@"111419");
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [_tableView registerNib:[UINib nibWithNibName:@"TPResetPWDCell" bundle:nil] forCellReuseIdentifier:@"TPResetPWDCell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 50)];
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(12, 20, kScreenW - 24, 45) title:@"保存修改" titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    kViewBorderRadius(button, 22.5, 0, kRedColor);
    [button setBackgroundImage:kImageFromStr(@"loin_btn_loin") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    button.SG_eventTimeInterval = 3;
    [footerView addSubview:button];
    _tableView.tableFooterView = footerView;
    
}
-(void)initVerifyConfigure
{
    // sdk调用
    self.manager = [NTESVerifyCodeManager sharedInstance];
    self.manager.delegate = self;
    
    // 设置透明度
    self.manager.alpha = 0;
    _manager.lang = [Utilities getLangguageForNTESVerifyCode];
    // 设置frame
    self.manager.frame = CGRectNull;
    
    // captchaId从云安全申请，比如@"a05f036b70ab447b87cc788af9a60974"
    NSString *captchaId = kVerifyKey;
    [self.manager configureVerifyCode:captchaId timeout:7];
}
-(void)showVerifyInfo
{
    [self hideKeyBoard];
//    if (_codeTF.text.length == 0) {
//        [self showTips:@"請輸入手機號碼"];
//        return;
//    }
    [self.manager openVerifyCodeView:nil];
}
- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    // App添加自己的处理逻辑
    if (result == YES) {
        _verifyStr = validate;
        [self sendCodeAction:nil];
    }else{
        _verifyStr = @"";
        [self showTips:kLocat(@"OTC_buylist_codeerror")];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_TPResetPWDType == TPResetPWDTypeLogin) {
        return self.loginArr.count;
    }else{
        return self.transactionArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPResetPWDCell";
    TPResetPWDCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    if (_TPResetPWDType == TPResetPWDTypeLogin) {
       cell.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.loginArr[indexPath.row] attributes:@{NSForegroundColorAttributeName: kColorFromStr(@"999999")}];
        if (indexPath.row == 0) {
           _oldTF = cell.tf;
        }else if (indexPath.row == 1){
            _nwTF = cell.tf;
        }else{
            _confirmTF = cell.tf;
        }
        cell.tf.keyboardType = UIKeyboardTypeASCIICapable;
        cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.tf.secureTextEntry = YES;
        cell.codeButton.hidden = YES;
        cell.line2.hidden = YES;
        
    }else{
         cell.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.transactionArr[indexPath.row] attributes:@{NSForegroundColorAttributeName: kColorFromStr(@"999999")}];
        if (indexPath.row == 0) {
            cell.tf.keyboardType = UIKeyboardTypeASCIICapable;
            _userNameTF = cell.tf;
            cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;

        }else if (indexPath.row == 1){
            _nwTraTF = cell.tf;
            cell.tf.keyboardType = UIKeyboardTypeNumberPad;
            cell.tf.secureTextEntry = YES;
            cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;

        }else if (indexPath.row == 2){
            _confirmTraTF = cell.tf;
            cell.tf.keyboardType = UIKeyboardTypeNumberPad;
            cell.tf.secureTextEntry = YES;
            cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;

        }else if (indexPath.row == 3){
            _codeTF  = cell.tf;
            cell.tf.keyboardType = UIKeyboardTypeNumberPad;
            _sendButton = cell.codeButton;
            [_sendButton addTarget:self action:@selector(showVerifyInfo) forControlEvents:UIControlEventTouchUpInside];

        }

        cell.line2.hidden = indexPath.row == 3?NO:YES;
        cell.codeButton.hidden = indexPath.row == 3?NO:YES;

    }
    
    return cell;

}

-(void)nextAction
{
    [self hideKeyBoard];
    
    if (_TPResetPWDType == TPResetPWDTypeLogin) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"oldpwd"] = _oldTF.text;
        param[@"pwd"] = _nwTF.text;
        param[@"repwd"] = _confirmTF.text;
        
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Set/updatePassword"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                
                [self showTips:[responseObj ksObjectForKey:kMessage]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [kUserInfo clearUserInfo];
                    
                    //        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutKey object:nil];
                    YJBaseNavController *vc = [[YJBaseNavController alloc] initWithRootViewController:[YJLoginViewController new]];
                    [self presentViewController:vc animated:YES completion:nil];
                });
                
            }else{
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }else{
        if (_userNameTF.text.length == 0) {
            [self showTips:@"請輸入用戶名"];
            return;
        }
        
        if (_confirmTraTF.text.length == 0 || _nwTraTF.text.length == 0) {
            [self showTips:@"請輸入交易密碼"];
            return;
        }
        
        if (![_confirmTraTF.text isEqualToString:_nwTraTF.text]) {
            [self showTips:@"兩次輸入的交易密碼不壹致"];
            return;
        }
        if (_codeTF.text.length == 0) {
            [self showTips:@"請輸入驗證碼"];
            return;
        }
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"username"] = _userNameTF.text;
        param[@"pwdtrade"] = _nwTraTF.text;
        param[@"repwdtrade"] = _confirmTraTF.text;
        param[@"phone_code"] = _codeTF.text;

        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Set/updatePwdtrade"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [self showTips:[responseObj ksObjectForKey:kMessage]];
               
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    kNavPop;
                });
            }else{
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }
}
-(void)sendCodeAction:(UIButton *)button
{
    _verifyCode = 0;
    [self hideKeyBoard];
//    if (_phoneTF.text.length == 0) {
//        [self showTips:kLocat(@"LEnterPhoneNumber")];
//        return;
//    }
    if (self.timer == nil) {
        
        self.timer = [WeakTimeObject weakScheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        self.sendButton.userInteractionEnabled = NO;
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"validate"] = _verifyStr;
    param[@"type"] = @"update_pwd";
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kSenderSMS] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
        }else{
            _second = 1;
        }
        [self showTips:[responseObj ksObjectForKey:kMessage]];
    }];
}
-(void)countDown
{
    _second --;
    if (_second == 0) {
        _sendButton.userInteractionEnabled = YES;
        [_sendButton setTitle:kLocat(@"LResend") forState:UIControlStateNormal];
        _second = 60;
        [_timer invalidate];
        _timer = nil;
    }else{
        _sendButton.userInteractionEnabled = NO;
        [_sendButton setTitle:[NSString stringWithFormat:@"%lds%@",(long)_second,kLocat(@"LResend")] forState:UIControlStateNormal];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSArray *)transactionArr
{
    if (_transactionArr == nil) {
        _transactionArr = @[@"請輸入用戶名",@"輸入新交易密碼",@"重複新的交易密碼",@"請輸入手機驗證碼"];
    }
    return _transactionArr;
}


-(NSArray *)loginArr
{
    if (_loginArr == nil) {
        _loginArr = @[@"請輸入原登錄密碼",@"新密碼",@"確認新密碼"];
    }
    return _loginArr;
}
-(void)dealloc
{
    [_timer invalidate];
}

@end
