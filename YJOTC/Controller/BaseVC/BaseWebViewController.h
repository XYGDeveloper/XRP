//
//  BaseWebViewController.h
//  YJOTC
//
//  Created by 周勇 on 2017/12/29.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import <WebKit/WebKit.h>



@interface BaseWebViewController : YJBaseViewController

@property(nonatomic,strong)WKWebView * webView;


@property(nonatomic,copy)NSString * cookieValue;

@property(nonatomic,copy)NSString *urlStr;

@property(nonatomic,copy)NSString *titleString;

@property(nonatomic,assign)CGRect webViewFrame;

@property(nonatomic,assign)BOOL showNaviBar;

@property(nonatomic,assign)BOOL isDiscover;
/**  是否是在线客服,隐藏导航栏  */
@property(nonatomic,assign)BOOL isOnlineService;

@property(nonatomic,assign)BOOL isPublish;
@property(nonatomic,assign)BOOL isCheck;




-(instancetype)initWithWebViewFrame:(CGRect)frame title:(NSString *)title;

+ (instancetype)webViewControllerWithURIString:(NSString *)URIString;

+ (instancetype)webViewControllerWithURIString:(NSString *)URIString title:(NSString *)title ;


@end
