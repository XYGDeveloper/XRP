
//
//  TPTransferToPocketEndController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPTransferToPocketEndController.h"

@interface TPTransferToPocketEndController ()<NTESVerifyCodeManagerDelegate,UITextFieldDelegate>



@property(nonatomic,copy)NSString *left;
@property(nonatomic,strong)UILabel *leftMoneyLabel;


@property(nonatomic,strong)UITextField *volumeTF;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger second;
@property(nonatomic,strong)UIButton *sendButton;

@property(nonatomic,strong)UITextField *pwdTF;
@property(nonatomic,strong)UITextField *codeTF;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,copy)NSString *verifyStr;




@end

@implementation TPTransferToPocketEndController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self manager];


    [self setupUI];

    [self loadAvaiVolume];
    
}
-(void)loadAvaiVolume
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Transfer/avail_bcb"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            _left = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kData][@"num"]];
            _leftMoneyLabel.text = _left;
        }
    }];
    
}
-(void)setupUI
{
    self.title = @"轉到口袋賬戶";
    self.view.backgroundColor = k111419Color;
    
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:kRectMake(0, 40 + kNavigationBarHeight, 60, 60)];
    
    [self.view addSubview:avatar];
    [avatar alignHorizontal];
    avatar.image = kImageFromStr(@"toux_icon");
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:kRectMake(12, avatar.bottom + 10, kScreenW - 24, 16) text:_account font:PFRegularFont(14) textColor:kLightGrayColor textAlignment:1 adjustsFont:NO];
    [self.view addSubview:addLabel];
    
    
    
    UIView *topView = [[UIView alloc] initWithFrame:kRectMake(0, avatar.bottom + 55 *kScreenHeightRatio, kScreenW, 45)];
    topView.backgroundColor = kColorFromStr(@"#1E1F22");
    [self.view addSubview:topView];

    UILabel *label1 = [[UILabel alloc] initWithFrame:kRectMake(12, 0, 35, topView.height) text:@"餘額" font:PFRegularFont(16) textColor:kLightGrayColor textAlignment:0 adjustsFont:YES];
    [topView addSubview:label1];
    
    UILabel *leftMoneyLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, 250, topView.height) text:@"0.000000" font:PFRegularFont(18) textColor:kColorFromStr(@"#D8123C") textAlignment:2 adjustsFont:YES];
    
    [topView addSubview:leftMoneyLabel];
    leftMoneyLabel.right = kScreenW - 12;
    
    
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(0, topView.bottom, kScreenW, 45)];
    midView.backgroundColor = kColorFromStr(@"#1E1F22");
    [self.view addSubview:midView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, 0, 65, midView.height) text:@"金額" font:PFRegularFont(16) textColor:kLightGrayColor textAlignment:0 adjustsFont:YES];
    [midView addSubview:label];
    
    UITextField *accountTF = [[UITextField alloc] initWithFrame:kRectMake(58, 0, kScreenW - 58 - 12, midView.height)];
    [midView addSubview:accountTF];
    accountTF.placeholder = @"請輸入轉賬金額";
    kTextFieldPlaceHoldColor(accountTF, kColorFromStr(@"#707589"));
    accountTF.textColor = kLightGrayColor;
    accountTF.font = PFRegularFont(16);
    accountTF.keyboardType = UIKeyboardTypeDecimalPad;
    UIButton *nextButton = [[UIButton alloc] initWithFrame:kRectMake(12, midView.bottom + 20, kScreenW - 24, 45) title:@"下一步" titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [self.view addSubview:nextButton];
    //    nextButton.backgroundColor = kColorFromStr(@"#11B1ED");
    [nextButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#11B1ED")] forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    kViewBorderRadius(nextButton, 8, 0, kRedColor);
    accountTF.delegate = self;
    _volumeTF = accountTF;
    _leftMoneyLabel = leftMoneyLabel;
}


-(void)nextAction
{
    [self hideKeyBoard];
    if (_volumeTF.text.length == 0) {
        [self showTips:@"請輸入轉賬金額"];
        return;
    }
    if (_volumeTF.text.doubleValue > _left.doubleValue) {
        [self showTips:@"轉帳金額不能大於余額"];
        return;
    }
    if (_volumeTF.text.doubleValue <= 0) {
        [self showTips:@"轉賬金額必須大於0"];
        return;
    }    
    [self showTransferView];
}

-(void)trasferAction:(UIButton *)button
{
    [_pwdTF resignFirstResponder];
    [_codeTF resignFirstResponder];
    if (_pwdTF.text.length == 0) {
        [kKeyWindow showWarning:@"請輸入交易密碼"];
        return;
    }
    if (_codeTF.text.length == 0) {
        [kKeyWindow showWarning:@"請輸入短信驗證碼"];
        return;
    }
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"email"] = _account;
    param[@"number"] = _volumeTF.text;
    param[@"phone_code"] = _codeTF.text;
    param[@"pwd"] = [_pwdTF.text md5String];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Transfer/koudai"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            
            [button.superview.superview removeFromSuperview];
 
            [self showSuccessView];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidTransferSuccessKey" object:nil];
            
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];

        }
    }];
}



-(void)showTransferView
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:.64];
    [kKeyWindow addSubview:bgView];
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(25, 178 *kScreenHeightRatio, kScreenW - 50, 295)];
    [bgView addSubview:midView];
        midView.backgroundColor = kColorFromStr(@"#F4F4F4");
    
    UILabel *title = [[UILabel alloc] initWithFrame:kRectMake(0, 0, midView.width, 60) text:@"轉賬" font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:title];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, midView.width, 0.5)];
    lineView.backgroundColor = kColorFromStr(@"#DADADA");

    NSString *volumeStr = [NSString stringWithFormat:@"%@ BCB",_volumeTF.text];
    
    UILabel *volumeLabel = [[UILabel alloc ]initWithFrame:kRectMake(12, lineView.bottom + 18, midView.width - 24, 20)];
    [midView addSubview:volumeLabel];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:volumeStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:k323232Color
                          range:NSMakeRange(0, volumeStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:kColorFromStr(@"#11B1ED")
                          range:NSMakeRange(0, _volumeTF.text.length)];
    
    [attributedStr addAttribute:NSFontAttributeName
                          value:PFRegularFont(16)
                          range:NSMakeRange(0, volumeStr.length)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:PFRegularFont(24)
                          range:NSMakeRange(0, _volumeTF.text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 设置文字居中
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [volumeStr length])];
    
    volumeLabel.attributedText = attributedStr;

 
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(12, lineView.bottom + 50, midView.width - 24, 13) text:@"" font:PFRegularFont(12) textColor:kColorFromStr(@"666666") textAlignment:1 adjustsFont:YES];
    [midView addSubview:tipsLabel];
//    tipsLabel.text = @"提示：您本次將消耗0.46666BCB";
    tipsLabel.text = [NSString stringWithFormat:@"提示：您本次將消耗%@BCB",_volumeTF.text];

    UITextField *pwdTF = [[UITextField alloc] initWithFrame:kRectMake(12, lineView.bottom + 82, midView.width - 24, 40)];
    [midView addSubview:pwdTF];
    pwdTF.keyboardType = UIKeyboardTypeNumberPad;
    pwdTF.secureTextEntry = YES;
    pwdTF.leftView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 10, 20)];
    pwdTF.leftViewMode = UITextFieldViewModeAlways;
    pwdTF.placeholder = @"輸入交易密碼";
    pwdTF.font = PFRegularFont(14);
    kTextFieldPlaceHoldColor( pwdTF, kColorFromStr(@"#999999"));
    pwdTF.backgroundColor = kWhiteColor;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:kRectMake(12, pwdTF.bottom + 12, pwdTF.width, pwdTF.height)];
    [midView addSubview:bottomView];
    bottomView.backgroundColor = kWhiteColor;

    UITextField *codelTF = [[UITextField alloc] initWithFrame:kRectMake(12, 0, midView.width - 24 - 90, 40)];
    [bottomView addSubview:codelTF];
    codelTF.keyboardType = UIKeyboardTypeNumberPad;
    codelTF.placeholder = @"輸入短信驗證碼";
    codelTF.font = PFRegularFont(14);
    kTextFieldPlaceHoldColor( codelTF, kColorFromStr(@"#999999"));
    codelTF.backgroundColor = kWhiteColor;
    
    UIView *line = [[UIView alloc] initWithFrame:kRectMake(bottomView.width - 89.5, 10, 0.5, 20)];
    line.backgroundColor = kColorFromStr(@"#E2E2E2");
    [bottomView addSubview:line];
    
    UIButton *codeButton = [[UIButton alloc] initWithFrame:kRectMake(line.right, 0, 90, codelTF.height) title:@"獲取驗證碼" titleColor:kColorFromStr(@"#11B1ED") font:PFRegularFont(14) titleAlignment:0];
    [bottomView addSubview:codeButton];
    _sendButton = codeButton;
    
    [codeButton addTarget:self action:@selector(showVerifyInfo) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 250, midView.width/2, 45) title:@"取消" titleColor:kColorFromStr(@"#9BBBEB") font:PFRegularFont(14) titleAlignment:0];
    [midView addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#434A5D");
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {

        [sender.superview.superview removeFromSuperview];
    }];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:kRectMake(midView.width/2, 250, cancelButton.width, 45) title:@"确定" titleColor:kWhiteColor font:PFRegularFont(14) titleAlignment:1];
    [midView addSubview:confirmButton];
    confirmButton.backgroundColor = kColorFromStr(@"#11B1ED");
    
    
    [confirmButton addTarget:self action:@selector(trasferAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _codeTF = codelTF;
    _pwdTF = pwdTF;
}

-(void)showSuccessView
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
    [kKeyWindow addSubview:bgView];
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(25, 230 *kScreenHeightRatio, kScreenW - 50, 170)];
    midView.backgroundColor = kColorFromStr(@"#F4F4F4");
    [bgView addSubview:midView];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:kRectMake(0, 46, 48, 48)];
    [midView addSubview:icon];
    icon.image = kImageFromStr(@"cg_icon");
    [icon alignHorizontal];
    
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(0, icon.bottom + 15, 200, 16) text:@"轉賬成功" font:PFRegularFont(16) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:tipsLabel];
    [tipsLabel alignHorizontal];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [bgView removeFromSuperview];
        kNavPop;
    });
    
 
}
-(void)showVerifyInfo
{
    [self hideKeyBoard];
    [_pwdTF resignFirstResponder];
    [_codeTF resignFirstResponder];
    
    if (self.manager == nil) {
        [self manager];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.manager openVerifyCodeView:nil];
        });
    }else{
        
        [self.manager openVerifyCodeView:nil];
    }
    
}
#pragma mark - 图形验证码
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

-(void)sendCodeAction:(UIButton *)button
{
    [self hideKeyBoard];
    _second = 60;

    if (self.timer == nil) {
        
        self.timer = [WeakTimeObject weakScheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        button.userInteractionEnabled = NO;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"validate"] = _verifyStr;
    param[@"type"] = @"bring_forward";
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kSenderSMS] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        
        if (success) {
            
        }else{
            _second = 1;
        }
        [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        
    }];
}

-(void)countDown
{
    _second --;
    if (_second == 0) {
        _sendButton.userInteractionEnabled = YES;
        [_sendButton setTitle:kLocat(@"LResend") forState:UIControlStateNormal];
        _second = 60;
        _sendButton.backgroundColor = kColorFromStr(@"#4C9EE4");
        
        [_timer invalidate];
        _timer = nil;
    }else{
        _sendButton.userInteractionEnabled = NO;
        [_sendButton setTitle:[NSString stringWithFormat:@"%lds%@",(long)_second,kLocat(@"LResend")] forState:UIControlStateNormal];
        
        _sendButton.backgroundColor = kColorFromStr(@"CECECE");
        
    }
}

-(NTESVerifyCodeManager *)manager
{
    if (_manager == nil) {
        // sdk调用
        _manager = [NTESVerifyCodeManager sharedInstance];
        _manager.delegate = self;
        
        // 设置透明度
        _manager.alpha = 0;
        
        // 设置frame
        _manager.frame = CGRectNull;
        
        // captchaId从云安全申请，比如@"a05f036b70ab447b87cc788af9a60974"
        NSString *captchaId = kVerifyKey;
        [_manager configureVerifyCode:captchaId timeout:7];
    }
    return _manager;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if([textField.text length] == 0){
                if(single == '.') {
                    //                    showMsg(@"数据格式有误");
                    kLOG(@"数据格式有误");
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    //                    showMsg(@"数据格式有误");
                    kLOG(@"数据格式有误");
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (textField == _volumeTF) {
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 6) {
                            return YES;
                        }else{
                            kLOG(@"最多两位小数");
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }else{
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            return YES;
                        }else{
                            kLOG(@"最多两位小数");
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }
        }else{//输入的数据格式不正确
            //            showMsg(@"数据格式有误");
            kLOG(@"数据格式有误");
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _volumeTF) {
        if (_volumeTF.text.doubleValue > _left.doubleValue) {
            _volumeTF.text = _left;
        }
    }
}
@end
