//
//  BaseWebViewController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/29.
//  Copyright © 2017年 前海数交平台运营2. All rights reserved.
//

#import "BaseWebViewController.h"
#import "KSScanningViewController.h"


@interface BaseWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property(nonatomic,assign)NSInteger count;

//@property(nonatomic,copy)NSString *url_pre;
//@property(nonatomic,assign)NSTimeInterval url_pre_time;

@property(nonatomic,assign)BOOL firstLoad;

@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation BaseWebViewController

+ (instancetype)webViewControllerWithURIString:(NSString *)URIString {
    return [self webViewControllerWithURIString:URIString title:nil];
}

+ (instancetype)webViewControllerWithURIString:(NSString *)URIString title:(NSString *)title {
    BaseWebViewController *vc = [[self alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:title];
    if ([URIString containsString:@"http"]) {
        vc.urlStr = URIString;
    }else{
        vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,URIString];
    }
    return vc;
}

-(instancetype)initWithWebViewFrame:(CGRect)frame title:(NSString *)title
{
    BaseWebViewController *vc = [BaseWebViewController new];
    vc.webViewFrame = frame;
    vc.titleString = title;
    _webViewFrame = frame;
    _titleString = title;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kLoginSuccessKey object:nil];

    self.title = _titleString;

    self.enablePanGesture = YES;
    

    [self setupWebView];
    
}

-(void)setupWebView
{
    _firstLoad = YES;

    _webView = [[WKWebView alloc] initWithFrame:_webViewFrame configuration:[self webViewConfigurate]];
    
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (_showNaviBar == YES) {
        _webView.frame = _webViewFrame;
    }
    
    
    
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    if (_cookieValue) {
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.bounces = NO;
    }

    
    
    
    [self.webView loadHTMLString:@"" baseURL:kBasePath.ks_URL];

    
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



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = !_showNaviBar;
    if (_webViewFrame.origin.y == kNavigationBarHeight) {
        self.navigationController.navigationBar.hidden = NO;
    }else{
        self.navigationController.navigationBar.hidden = YES;

    }
//    [self changeStatusBarColorWithWhite:NO];
    if (_webViewFrame.origin.y != kNavigationBarHeight) {
        [self setStatusBarColor:kNaviColor];
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (_webViewFrame.origin.y != kNavigationBarHeight) {
        [self setStatusBarColor:[UIColor clearColor]];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    kHideHud;
}


#pragma mark - WKNavigationDelegate

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{

    
    if (_firstLoad == NO) {
        kHideHud;
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
        if (_cookieValue) {
            JSFuncString = _cookieValue;
        }
        
        
        //拼凑js字符串，按照自己的需求拼凑Cookie
        NSMutableString *JSCookieString = JSFuncString.mutableCopy;
        for (NSHTTPCookie *cookie in cookieStorage.cookies) {
            NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 3);", cookie.name, cookie.value]; [JSCookieString appendString:excuteJSString];
        }
        //执行js
        [webView evaluateJavaScript:JSCookieString completionHandler:^(id obj, NSError * _Nullable error) {
            
                //加载真正的第一次Request [self loadRealRequest];
                NSURL *url = [NSURL URLWithString:_urlStr];
                
                // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                // 3. 发送请求给服务器
                [_webView loadRequest:request];
            
        }];
    }
    
    
}
// 页面加载失败时调用
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
    UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight)];
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


-(void)userDidLogin
{
    _firstLoad = YES;
    [self setupWebView];
}

//去除空格,UTF8
- (NSString *)handleFormatString:(NSString *)str
{
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([str containsString:@" "]) {
        return [str stringByReplacingOccurrencesOfString:@" "withString:@""];
    }else{
        return str;
    }
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
    if (_cookieValue) {
        cookieValue = _cookieValue;
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
    
//    [self showTips:actionSting];
//    return;
    if ([actionSting isEqual:@"iosLoginAction"]) {
        dispatch_async_on_main_queue(^{
            [kUserInfo clearUserInfo];
            
            [self gotoLoginVC];
        });
    }else if ([actionSting isEqual:@"goback"]){
        [self backAction];
    }else if ([actionSting isEqual:@"zh-cn"]){//简体
        [LocalizableLanguageManager setUserlanguage:CHINESESimlple];
    }else if ([actionSting isEqual:@"zh-tw"]){//繁体
        [LocalizableLanguageManager setUserlanguage:CHINESETradition];
    }else if ([actionSting isEqual:@"en-us"]){//英文
        [LocalizableLanguageManager setUserlanguage:ENGLISH];
    }else if ([actionSting isEqual:@"loginOut"]){//登出
    }else if ([actionSting isEqual:@"login"]){//登录
        [self gotoLoginVC];
    }else if ([actionSting isEqual:@"register"]){//登录
        [self gotoRegisterVC];
    }else if ([actionSting isEqual:@"code"]){//扫一扫
        [self scanAction];
    }else if ([actionSting isEqual:@"reloadaccount"]){//reload account
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadAccountKey" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([actionSting isEqual:@"reloadwallet"]){//reload account
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadWalletKey" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([actionSting isEqual:@"exit"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([actionSting isEqualToString:@"diableSlide"]){
        self.enablePanGesture = NO;
    }else if ([actionSting isEqualToString:@"checkNetwork"]){
        [self checkCurrentNetwork];
    }else if([actionSting hasPrefix:@"download"]){
        kShowHud;
//        NSArray *arr = [actionSting componentsSeparatedByString:@","];
//        [self downloadImageWithUrlString:arr.lastObject];
        [self saveImage:[self imageByCaptureScreen]];
        
    }
    
}

-(void)checkCurrentNetwork
{
    if ([Utilities netWorkUnAvalible]) {
        [self setupBlankViewWithStatus:1];
    }
}

-(void)scanAction
{
    
    __weak typeof(self)weakSelf = self;
    KSScanningViewController *vc = [[KSScanningViewController alloc] init];
    vc.callBackBlock = ^(NSString *scannedStr) {
        kLOG(@"%@",[NSString stringWithFormat:@"showName('%@')",scannedStr]);
        [weakSelf.webView evaluateJavaScript:[NSString stringWithFormat:@"showName('%@')",scannedStr] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        }];
    };
    
    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc]  animated:YES completion:nil];
    
}
#pragma mark 下载图片
/**  截屏  */
-(UIImage*) imageByCaptureScreen  {
    if(&UIGraphicsBeginImageContextWithOptions!=NULL)
    {
        //        UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size,NO,0);
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kScreenHeight - kNavigationBarHeight),NO,0);
        
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    for(UIWindow*window in[[UIApplication sharedApplication]windows])
    {
        if(![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width* [[window layer]anchorPoint].x,
                                  -([window bounds].size.height)* [[window layer]anchorPoint].y-kNavigationBarHeight);
            [[window layer]renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)downloadImageWithUrlString:(NSString *)urlString
{
//    UIImage *image = [self.webView snapshotImage];
    NSData * imageData =[[NSData alloc] initWithBase64EncodedString:urlString options:NSDataBase64DecodingIgnoreUnknownCharacters];

    UIImage *photo = [UIImage imageWithData:imageData ];
    
    [self saveImage:photo];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
//    NSURL *URL = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        //        NSLog(@"File downloaded to: %@", filePath);
//        NSData *data = [NSData dataWithContentsOfURL:filePath];
//        UIImage * image = [UIImage imageWithData:data];
//
//        [self saveImage:image];
//
//    }];
//    [downloadTask resume];
}
//image是要保存的图片





- (void) saveImage:(UIImage *)image{
    
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    }
}
//保存完成后调用的方法
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    kHideHud;

    if (error) {
        kLOG(@"保存图片出错%@", error.localizedDescription);
        dispatch_sync_on_main_queue(^{
            [self showTips:kLocat(@"OTC_qr_savefail")];
            
        });
    }
    else {
        dispatch_sync_on_main_queue(^{
            [self showTips:kLocat(@"OTC_qr_savesuccess")];
        });

    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];

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

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:kLocat(@"net_alert_load_message_sure")
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
    [alertController addAction:[UIAlertAction actionWithTitle:kLocat(@"net_alert_load_message_sure")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:kLocat(@"net_alert_load_message_cancel")
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
