
//
//  YJMineViewController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJMineViewController.h"
#import "KSScanningViewController.h"

@interface YJMineViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView * webView;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,assign)BOOL firstLoad;

@property(nonatomic,copy)NSString *mineUrl;

@property(nonatomic,assign)BOOL finishLoad;
@property (nonatomic,strong) UIProgressView *progressView;


@end

@implementation YJMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstLoad = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kLoginSuccessKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebView) name:@"kReloadAccountKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebView) name:@"kUserDidClickAccountVCKey" object:nil];

    [self setupWebView];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    self.tabBarController.tabBar.hidden = NO;

}



-(void)setupWebView
{
    _webView = [[WKWebView alloc] initWithFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) configuration:[self webViewConfigurate]];
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/AccountManage/account",kBasePath]];
//    NSURL *url = [NSURL URLWithString:@"http://dispatchmoney.com"];
    
    _mineUrl = [NSString stringWithFormat:@"%@/Mobile/AccountManage/account",kBasePath];
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
    _finishLoad = NO;
    [self.webView loadHTMLString:@"" baseURL:kBasePath.ks_URL];


//    [self.webView loadRequest:[NSURLRequest requestWithURL:_mineUrl.ks_URL]];

    
    [self.view addSubview:_webView];
    
    kShowHud;   
    [self initProgressView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}
-(void)initProgressView
{
    if (self.progressView) {
        [self.progressView removeFromSuperview];
    }
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, _webView.y, CGRectGetWidth(self.view.frame), 2)];
    self.progressView.progressTintColor = [UIColor colorWithRed:0.19 green:0.70 blue:0.91 alpha:1.00];
    [self.view addSubview:self.progressView];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.backgroundColor = [UIColor clearColor];
}

-(WKWebViewConfiguration *)webViewConfigurate
{
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    // 支持内嵌视频播放，不然网页中的视频无法播放
    webConfig.allowsInlineMediaPlayback = YES;
    NSString *cookieValue;
    
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else{//简体
        lang = @"zh-cn";
    }
    if ([Utilities isExpired]) {
        cookieValue =  [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",@"1",[Utilities randomUUID],lang];
    }else{
        cookieValue =  [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",kUserInfo.token,[Utilities randomUUID],lang];
    }

    // 加cookie给h5识别，表明在ios端打开该地址
    WKUserContentController* userContentController = [[WKUserContentController alloc] init];;
    [userContentController addScriptMessageHandler:self name:@"iosAction"];
    WKUserScript * cookieScript = [[WKUserScript alloc]
                                   initWithSource: cookieValue
                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    webConfig.userContentController = userContentController;
    return webConfig;
}
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSString *actionSting = message.body;
    kLOG(@"webview返回的字段===%@===",actionSting);
    if ([actionSting isEqual:@"iosLoginAction"]) {
        dispatch_async_on_main_queue(^{
            [self gotoLoginVC];
        });
    }else if ([actionSting isEqual:@"goback"]){

        [self backAction];
    }else if ([actionSting isEqual:@"loginOut"]){//登出
        [self exitAction];
    }else if ([actionSting isEqual:@"login"]){//登录
        [self gotoLoginVC];
    }else if ([actionSting isEqual:@"register"]){//注册
        [self gotoRegisterVC];
    }else if ([actionSting isEqual:@"code"]){//扫一扫
        [self scanAction];
    }
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    kLOG(@"==%@==",navigationResponse.response.URL.absoluteString);

    if ([navigationResponse.response.URL.absoluteString isEqualToString:_mineUrl]) {

        decisionHandler(WKNavigationResponsePolicyAllow);

    }else{

        BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:@""];

        NSString *urlStr = webView.URL.absoluteString;

        vc.urlStr = urlStr;

        //        vc.showNaviBar = YES;
        kNavPush(vc);

        // 在发送请求之前，决定是否跳转
        decisionHandler(WKNavigationResponsePolicyCancel);
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    kLOG(@"===%@===",navigationAction.request.URL.absoluteString);
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    if (urlStr.length - kBasePath.length < 2) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else if ([urlStr isEqualToString:_mineUrl]){
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:@""];
        vc.urlStr = urlStr;
        vc.showNaviBar = NO;
        kNavPush(vc);
        // 在发送请求之前，决定是否跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}



-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)backAction
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)userDidLogin
{
    [_webView removeFromSuperview];
    _count = 0;
    _firstLoad = YES;

    [self setupWebView];
}
-(void)reloadWebView
{
    if (_finishLoad) {
        [_webView reload];
    }
    
}

-(void)exitAction
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *desAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        [kUserInfo clearUserInfo];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutKey object:nil];
        
        YJBaseNavController *vc = [[YJBaseNavController alloc] initWithRootViewController:[YJLoginViewController new]];
        
        [self presentViewController:vc animated:YES completion:nil];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:desAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)userDidlogout
{
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{

    if (_firstLoad == NO) {
        kHideHud;
        _finishLoad = YES;
    }
    if (_firstLoad) {
        _firstLoad = NO;
        
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
        NSString *lang = nil;
        if ([currentLanguage containsString:@"en"]) {//英文
            lang = @"en-us";
        }else if ([currentLanguage containsString:@"Hant"]){//繁体
            lang = @"zh-tw";
        }else{//简体
            lang = @"zh-cn";
        }
        NSString *JSFuncString =  [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",kUserInfo.token,[Utilities randomUUID],lang];
        
        //拼凑js字符串，按照自己的需求拼凑Cookie
        NSMutableString *JSCookieString = JSFuncString.mutableCopy;
        for (NSHTTPCookie *cookie in cookieStorage.cookies) {
            NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 3);", cookie.name, cookie.value]; [JSCookieString appendString:excuteJSString];
            
        }
        //执行js
        [webView evaluateJavaScript:JSCookieString completionHandler:^(id obj, NSError * _Nullable error) {
            //加载真正的第一次Request [self loadRealRequest];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/AccountManage/account",kBasePath]];
            
            // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            // 3. 发送请求给服务器
            [_webView loadRequest:request];
        }];
    }
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    kHideHud;
    switch (error.code) {
        case 1009:
        case -1009:
            [self setupBlankViewWithStatus:1];
            break;
        case -1001:
        case -2000:
//        case -999:
        case -1011:
        case -1008:
        case -1201:
        case -1005:
            [self setupBlankViewWithStatus:0];
            
            break;
        default:
            break;
    }
}
-(void)setupBlankViewWithStatus:(NSInteger)type
{
    /**  0 链接失败   1没有网络  */
    UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight - kTabbarItemHeight)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = kWhiteColor;
    NSString *img ;
    NSString *tipsStr;
    
    CGSize size = kSizeMake(kScreenW, 243 * kScreenHeightRatio);
    
    if (type) {
        img = @"mainnonet";
        tipsStr = @"網絡連接失敗";
    }else{
        img = @"mainconfail";
        tipsStr = @"請求失敗,請稍後重試";
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:kImageFromStr(img)];
    [bgView addSubview:imgView];
    imgView.image = kImageFromStr(img);
    if (type == 0) {
        imgView.size = size;
    }
    
    [imgView alignHorizontal];
    
    UIButton *retryButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 109, 38) title:@"重試" titleColor:kWhiteColor font:PFRegularFont(17) titleAlignment:0];
    [bgView addSubview:retryButton];
    [retryButton alignHorizontal];
    retryButton.bottom = bgView.height  - 256/2*kScreenHeightRatio;
    [retryButton addTarget:self action:@selector(didClickRetryButton:) forControlEvents:UIControlEventTouchUpInside];
    kViewBorderRadius(retryButton, 3, 0, kRedColor);
    retryButton.backgroundColor = kYellowColor;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, kScreenW, 19) text:tipsStr font:PFRegularFont(17) textColor:k323232Color textAlignment:1 adjustsFont:1];
    [bgView addSubview:tipsLabel];
    tipsLabel.bottom = retryButton.top -154/2*kScreenHeightRatio;
    
    imgView.bottom = tipsLabel.top - 5;
    
    if (type == 1) {
        imgView.bottom = tipsLabel.top - 25;
    }
    
    _webView.hidden = YES;
}
-(void)didClickRetryButton:(UIButton *)button
{
    [button.superview removeFromSuperview];
    [self userDidLogin];
}
-(void)scanAction
{
    
    __weak typeof(self)weakSelf = self;
    KSScanningViewController *vc = [[KSScanningViewController alloc] init];
    vc.callBackBlock = ^(NSString *scannedStr) {
        kLOG(@"%@",[NSString stringWithFormat:@"showName('%@')",scannedStr]);
        [weakSelf.webView evaluateJavaScript:[NSString stringWithFormat:@"showName('%@')",scannedStr] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            [weakSelf.view endEditing:YES];
            
        }];
        
    };
    
    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc]  animated:YES completion:nil];
    
    
//    if ([Utilities isExpired]) {
//        [self gotoLoginVC];
//    }else{
//        __weak typeof(self)weakSelf = self;
//        KSScanningViewController *vc = [[KSScanningViewController alloc] init];
//        vc.callBackBlock = ^(NSString *scannedStr) {
//            kLOG(@"%@",[NSString stringWithFormat:@"showName('%@')",scannedStr]);
//            [weakSelf.webView evaluateJavaScript:[NSString stringWithFormat:@"showName('%@')",scannedStr] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
//            }];
//
//        };
//        kNavPush(vc);
//    }
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        
        kLOG(@"%.2f",self.webView.estimatedProgress);
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
            }];
        }
    }
}

@end
