//
//  YJLoginViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/4/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJLoginViewController.h"
//#import "YJForgetViewController.h"


@interface YJLoginViewController ()<NTESVerifyCodeManagerDelegate>

@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *pwdTF;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@property(nonatomic,copy)NSString *verifyStr;

@property(nonatomic,copy)NSString *updateUrl;

@property(nonatomic,copy)NSString *updateString;

@end

@implementation YJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

    /**  延迟1.5秒调用检测更新  */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![kBasePath containsString:@"test.bcbwa"]) {
            [self checkCurrentVersion];
        }
    });

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self initVerifyConfigure];
    kHideHud;
}
-(void)setupUI
{
    UIImageView *topView = [[UIImageView alloc] initWithFrame:kScreenBounds];
    topView.image = kImageFromStr(@"login_img_bg");
    [self.view addSubview:topView];
//    UIImageView *logo = [[UIImageView alloc] initWithFrame:kRectMake(0,kNavigationBarHeight + 20 *kScreenHeightRatio,154 * kScreenHeightRatio , 114 * kScreenHeightRatio)];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:kRectMake(0,kNavigationBarHeight + 20 *kScreenHeightRatio,99 * kScreenHeightRatio , 116 * kScreenHeightRatio)];

    logo.image = kImageFromStr(@"loin_img_logo");
    [self.view addSubview:logo];
    [logo alignHorizontal];
    
    
//    self.title = @"";
//    self.titleWithNoNavgationBar = @"";
    [self hideBackButton];
    
    
    CGFloat w = kScreenWidth - 26 * kScreenWidthRatio * 2;
    CGFloat h = 45 * kScreenHeightRatio;
    
    UITextField *phoneTF = [self createCommenTFWithPlaceHolder:kLocat(@"Z_UserNameAndPhone") frame:kRectMake(26 * kScreenWidthRatio,kNavigationBarHeight + 181 * kScreenHeightRatio, w, h)];
    [self.view addSubview:phoneTF];
    phoneTF.keyboardType = UIKeyboardTypeDefault;
    
    UIView *leftView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 48, h)];
    leftView.backgroundColor = kClearColor;
    UIImageView *img = [[UIImageView alloc] initWithImage:kImageFromStr(@"lon_icon_user")];
    [leftView addSubview:img];
    [img alignVertical];
    [img alignHorizontal];
    phoneTF.leftView = leftView;

    
    UITextField *pwdTF = [self createCommenTFWithPlaceHolder:kLocat(@"LEnterPWD") frame:kRectMake(26 * kScreenWidthRatio, phoneTF.bottom + 10 * kScreenHeightRatio , w, h)];
    pwdTF.secureTextEntry = YES;
    [self.view addSubview:pwdTF];
    pwdTF.leftView = leftView;
    
    UIView *leftView1= [[UIView alloc] initWithFrame:kRectMake(0, 0, 48, h)];
    leftView1.backgroundColor = kClearColor;
    UIImageView *img1 = [[UIImageView alloc] initWithImage:kImageFromStr(@"lon_icon_paswd")];
    [leftView1 addSubview:img1];
    [img1 alignVertical];
    [img1 alignHorizontal];
    pwdTF.leftView = leftView1;
    
    

    UIButton *registerButton = [[UIButton alloc] initWithFrame:kRectMake(phoneTF.x, pwdTF.bottom + 15 * kScreenHeightRatio, w, h) title:kLocat(@"LLogin") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [self.view addSubview:registerButton];
//    registerButton.backgroundColor = kColorFromStr(@"dbba54");
    [registerButton addTarget:self action:@selector(showVerifyInfo) forControlEvents:UIControlEventTouchUpInside];
//    kViewBorderRadius(registerButton, h / 2, 0, kColorFromStr(@"dbba54"));
//    [registerButton setBackgroundImage:kImageFromStr(@"register_icon") forState:UIControlStateNormal];
//    registerButton.backgroundColor = [[UIColor colorWithPatternImage:kImageFromStr(@"register_icon")]colorWithAlphaComponent:0.7];
    
    registerButton.backgroundColor = [[UIColor colorWithRed:0.68 green:0.38 blue:0.22 alpha:1.00] colorWithAlphaComponent:0.7];
    [registerButton setBackgroundImage:kImageFromStr(@"loin_btn_loin") forState:UIControlStateNormal];
    
    
//    UIButton *haveAccountButton = [[UIButton alloc] initWithFrame:kRectMake(phoneTF.x, registerButton.bottom + 15 * kScreenHeightRatio, w, h) title:kLocat(@"R_HaveCount") titleColor:kWhiteColor font:PFRegularFont(15) titleAlignment:0];
//    [self.view addSubview:haveAccountButton];
////    kViewBorderRadius(haveAccountButton, h / 2, 1, kColorFromStr(@"dbba54"));
//    haveAccountButton.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.4];
//    [haveAccountButton setTitle:kLocat(@"R_HaveCount") forState:UIControlStateNormal];

    
    
//    UILabel *langLabel = [[UILabel alloc] initWithFrame:kRectMake(0, registerButton.bottom + 158 * kScreenHeightRatio, kScreenW, 17) text:@"语言  中文繁体" font:PFRegularFont(14) textColor:kColorFromStr(@"dddddd") textAlignment:1 adjustsFont:1];
//    [self.view addSubview:langLabel];
    

    UILabel *reBtn = [[UILabel alloc] initWithFrame:kRectMake(37, registerButton.bottom + 14, 50, 16) text:kLocat(@"LRegister") font:PFRegularFont(14) textColor:kColorFromStr(@"c1ccd4") textAlignment:0 adjustsFont:1];
    [self.view addSubview:reBtn];
    reBtn.userInteractionEnabled = YES;
    [reBtn addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerAction)]];
    
    UILabel *forBtn = [[UILabel alloc] initWithFrame:kRectMake(37, registerButton.bottom + 14, 80, 16) text:kLocat(@"LForgetPWD") font:PFRegularFont(14) textColor:kColorFromStr(@"c1ccd4") textAlignment:2 adjustsFont:1];
    [self.view addSubview:forBtn];
    forBtn.right = kScreenW - 37;
    forBtn.userInteractionEnabled = YES;
    [forBtn addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgetAction)]];
    
 
    _nameTF = phoneTF;
    _pwdTF = pwdTF;
    if ([kUserDefaults objectForKey:@"kUserLoginAccountKey"]) {
        _nameTF.text = [kUserDefaults objectForKey:@"kUserLoginAccountKey"];
    }
}

-(void)initVerifyConfigure
{
    // sdk调用
    self.manager = [NTESVerifyCodeManager sharedInstance];
    self.manager.delegate = self;
    
    // 设置透明度
    self.manager.alpha = 0;
    
    // 设置frame
    self.manager.frame = CGRectNull;
    
    // captchaId从云安全申请，比如@"a05f036b70ab447b87cc788af9a60974"
    NSString *captchaId = kVerifyKey;
    [self.manager configureVerifyCode:captchaId timeout:7];
}
-(void)showVerifyInfo
{
    [self hideKeyBoard];
    if (_nameTF.text.length == 0) {
        [self showTips:@"请输入用户名"];
        return;
    }
    if (_pwdTF.text.length == 0) {
        [self showTips:@"请输入密码"];
        return;
    }
    [self.manager openVerifyCodeView:nil];
}

- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    // App添加自己的处理逻辑
    if (result == YES) {
        _verifyStr = validate;
        [self loginAction];
    }else{
        _verifyStr = @"";
        [self showTips:@"验证码错误"];
    }
}
- (void)verifyCodeNetError:(NSError *)error
{
    //App添加自己的处理逻辑
    [self showTips:@"网络错误"];
}


-(void)loginAction
{

    [self hideKeyBoard];
    if (_nameTF.text.length == 0) {
        
        return;
    }
    if (_pwdTF.text.length == 0) {
        
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if ([_nameTF.text containsString:@" "]) {
        _nameTF.text = [_nameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }

    param[@"platform"] = @"ios";
    
    param[@"username"] = _nameTF.text;
    param[@"password"] = _pwdTF.text;
    param[@"NECaptchaValidate"] = _verifyStr;

    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:@"/Api/Account/login" andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            kLOG(@"%@",responseObj);
            [self showTips:kLocat(@"LLoginSuccess")];
            
            [kUserDefaults setObject:_nameTF.text forKey:@"kUserLoginAccountKey"];
            //            NSArray *dic = [responseObj ksObjectForKey:kResult];
            
            //保存数据
            YJUserInfo *model = [YJUserInfo modelWithJSON:[responseObj ksObjectForKey:kResult]];
            [kUserDefaults setInteger:model.uid forKey:kUserIDKey];
            [model saveUserInfo];
            
            //发通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessKey object:nil];
            //保存当前登录时间
            [kUserDefaults setObject:[NSDate date] forKey:@"kLastLoginTimeKey"];
            
            YJTabBarController *tabbar = [[YJTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
            
            
        }else{
            
            NSInteger code = [[responseObj ksObjectForKey:kCode] integerValue];
            
            NSString *tips = [responseObj ksObjectForKey:kMessage];

            [self showTips:tips];
            
            
        }
    }];
    
}

-(void)registerAction
{
//    if (self.navigationController.viewControllers.count == 1) {
//        YJRegisterViewController *vc = [YJRegisterViewController new];
//
//        kNavPush(vc);
//
//    }else{
//        kNavPop;
//    }
}
-(void)forgetAction
{
//    YJForgetViewController *vc  =[YJForgetViewController new];

//    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}

-(UITextField *)createCommenTFWithPlaceHolder:(NSString *)placeholder frame:(CGRect)frame
{
    
    UITextField *loginTF = [[UITextField alloc] initWithFrame:frame];
    loginTF.backgroundColor = [kColorFromStr(@"ffffff") colorWithAlphaComponent:0.4];
//    kViewBorderRadius(loginTF, frame.size.height / 2.0, 0, kColorFromStr(@"f4f1f4"));
    loginTF.font = PFRegularFont(15);
    loginTF.keyboardType = UIKeyboardTypeDefault;
    loginTF.leftViewMode = UITextFieldViewModeAlways ;
    loginTF.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 48, 0)];
//    loginTF.rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 0)];
//    loginTF.rightViewMode = UITextFieldViewModeAlways ;
    loginTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: kColorFromStr(@"545454")}];
    loginTF.textColor = kColorFromStr(@"c1ccd4");
//    loginTF.textAlignment = NSTextAlignmentCenter;
    
    
    loginTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    //关闭联想和大写
    [loginTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    loginTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //    loginTF.placeholder = placeholder;
    return loginTF;
}


-(void)checkCurrentVersion
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //    param[@"token"] = kUserInfo.token;
    //    param[@"mark"] = kUserInfo.mark;
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    
    [kNetwork_Tool POST_HTTPS:@"/Api/District/iosversion" andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        if (success) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            //            CFShow((__bridge CFTypeRef)(infoDictionary));
            // app名称
            //            NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            // app版本
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            // app build版本
            //            NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
            
            
            NSDictionary *dic = [responseObj ksObjectForKey:kResult];
            NSArray *tipsArr = dic[@"mobile_apk_explain"];
            
            NSMutableString *tipsStr = [NSMutableString new];
            for (NSDictionary *dic in tipsArr) {
                [tipsStr appendString:[NSString stringWithFormat:@"%@\n",dic[@"text"]]];
                
            }
            
            _updateString = tipsStr.mutableCopy;
            NSInteger isForceUpdata = [dic[@"versionForce"]integerValue] ;
            
            if (![dic[@"versionName"] isEqualToString:app_Version]) {
                
                _updateUrl = dic[@"downloadUrl"];
                
                if (isForceUpdata) {
                    [self showUpdateView:YES];
                    
                }else{
                    [self showUpdateView:NO];
                }
            }
        }
    }];
}

-(void)showUpdateView:(BOOL)isForce
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    [kKeyWindow addSubview:bgView];
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 250, 180)];
    [bgView addSubview:midView];
    [midView alignVertical];
    [midView alignHorizontal];
    midView.backgroundColor = kWhiteColor;
    kViewBorderRadius(midView, 6, 0, kRedColor);
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(30, 0, 250-60, 120)];
    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
    tipsLabel.textColor = k323232Color;
    tipsLabel.font = PFRegularFont(14);
    if (_updateString.length > 2) {
        tipsLabel.text = _updateString;
    }else{
        tipsLabel.text = @"发现新版本,请前往升级";
        tipsLabel.textAlignment = NSTextAlignmentCenter;
    }    tipsLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, tipsLabel.bottom, midView.width, midView.height - tipsLabel.height) title:@"确定" titleColor:kBlueColor font:PFRegularFont(16) titleAlignment:0];
    
    [midView addSubview:button];
    
    __weak typeof(self)weakSelf = self;

    
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton*  _Nonnull sender) {
        
        [weakSelf gotoSafariUpdataWith:weakSelf.updateUrl];
        
        if (isForce == NO) {
            [sender.superview.superview removeFromSuperview];
        }
        
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, button.top, midView.width, 0.5)];
    lineView.backgroundColor = kColorFromStr(@"e6e6e6");
    
    [midView addSubview:lineView];
}

-(void)gotoSafariUpdataWith:(NSString *)urlStr
{
    //    NSString * urlStr = url;
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{}
                                         completionHandler:^(BOOL success) {
                                             NSLog(@"Open %d",success);
                                         }];
            } else {
                // Fallback on earlier versions
            }
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            NSLog(@"Open  %d",success);
        }
        
    } else{
        bool can = [[UIApplication sharedApplication] canOpenURL:url];
        if(can){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


@end
