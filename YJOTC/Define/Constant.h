//
//  Constant.h
//  jys
//
//  Created by 周勇 on 2017/4/17.
//  Copyright © 2017年 前海数交所. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#pragma mark - appKey


//验证码key
#define kVerifyKey @"393c58cccfa44537b90c773fcbcb43cb"

//环信
#define kEMAppKey @"1100170803178038#otc"
#define kJPush @"438a7cbc1f356e0c29bcfab1"

#define kShareKey @"1dfbe8e57378e"
#define kShareSecret @"3b1724944954794a86ec93aefd383e86"
#define kQQAppId @"1105631359"//41E690BE
#define kQQAppKey @"GOGebKHk1NPtxfBy"
#define kSinaWeiboAppKey @"4145223938"
#define kSinaWeiboAppSecret @"7f9b2bc7d8f5aa5e585dfae323a8db1a"

#define kWEChatOpenPlatformAppID @"wx9fc8114d8893f11f"
#define kWEChatOpenPlatformSecret @"b718f95dfaa56900e59beb5f1fdbf7f1"

#define kGaoDeMapKey @"171b8a9b5d1ba83316e88b61400dcc90"



#define kOnLineServiceUrl @"http://kefu.qycn.com/vclient/chat/?m=m&websiteid=121988&clerkid=1799102"









#define kAppName @"易物商城"
#define kAppVersion @"1.0.0"

#define iOS11Upwards ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)


/******  appdelegate指针  ******/
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

/******  屏幕点宽高  ******/
#define kScreenW ([UIScreen mainScreen].bounds.size.width)
#define kScreenH ([UIScreen mainScreen].bounds.size.height)
#define kScreenBounds ([UIScreen mainScreen].bounds)
#define kScreenNativeH ([UIScreen mainScreen].nativeBounds.size.height)
#define kScreenNativeW ([UIScreen mainScreen].nativeBounds.size.width)
#define kRectMake(x,y,w,h) CGRectMake(x, y, w, h)
#define kSizeMake(w,h) CGSizeMake(w,h)

/******  keyWindow  ******/
#define kKeyWindow     [UIApplication sharedApplication].keyWindow
#define kUserDefaults [NSUserDefaults standardUserDefaults]
//用户idkey
#define kUserIDKey @"kUserIDKey"
//客服电话 10086
#define kCustomerServicePhone @"10086"


//斜体文字
#define kItalic(label)     CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 180.0), 1, 0, 0);\
label.transform = matrix;


/******  设置RGB/RGBA颜色  ******/
#define kRGBA(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define kRGBColor(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])

#define kRandColor kRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
/******  clear背景颜色  ******/
#define kClearColor ([UIColor clearColor])

/******  测试用NSLog  ******/
#ifdef DEBUG
#define kLOG(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define kLOG(...)
#endif

//显示hud
#define kShowHud [self.view showHUD]
//隐藏hud
#define kHideHud [self.view hideHUD]



/**  设置textfield placehold颜色  */
#define kTextFieldPlaceHoldColor(TextField,Color)  [TextField setValue:Color forKeyPath:@"_placeholderLabel.textColor"];




/******  设置view圆角和边框  ******/
#define kViewBorderRadius(View, Radius, Width, Color)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
//导航push
#define kNavPush(ViewController) [self.navigationController pushViewController:ViewController animated:YES]

#define kNavPushSafe(ViewController) [weakSelf.navigationController pushViewController:ViewController animated:YES]


//pop
#define kNavPop [self.navigationController popViewControllerAnimated:YES]
//dismiss
#define kDismiss [self dismissViewControllerAnimated:YES completion:nil]


#define kUserInfo [YJUserInfo userInfo]
//转为string
#define ConvertToString(var) [NSString stringWithFormat:@"%@",var]

#define isNull(var) [var isKindOfClass:[NSNull class]]


// 高度比例
#define kScreenHeightRatio [Utilities stdScreenHeightRatio]
// 宽度比例
#define kScreenWidthRatio [Utilities stdScreenRatio]

#define IS_IPHONE_X ((kScreenH == 812.0f) ? YES : NO)

//#define kNavigationBarHeight 64
//#define kTabbarItemHeight 49
#define kStatusBarHeight ((IS_IPHONE_X==YES)?44.0f: 20.0f)
#define kNavigationBarHeight    ((IS_IPHONE_X==YES)?88.0f: 64.0f)
#define kTabbarItemHeight    ((IS_IPHONE_X==YES)?83.0f: 49.0f)
#define kMargin 12.0

//#define kCornerRadius 2
//商圈一张图片的大小
#define OnePicWidth (150 * kScreenWidthRatio)
//行间距
#define UILABEL_LINE_SPACE 2

//上传图片最大size  (M)
#define kMaxImageSize 1.0

#define kWhiteColor [UIColor colorFromStr: @"#ffffff"]
//黑色
#define kBlackColor [UIColor colorFromStr: @"#000000"]
//黄色
#define kYellowColor [UIColor colorFromStr: @"#FFCB41"]
//背景色
#define kBGColor kColorFromStr(@"#f5f5f5")
#define kNewBgColor kColorFromStr(@"#090c11")

//涨 绿色
#define kRiseColor kColorFromStr(@"#03C086")

//跌 红色
#define kFallColor kColorFromStr(@"#EA6E44")

//绿色
#define kGreenColor [UIColor colorFromStr: @"#03C086"]

//橙色
#define kOrangeColor [UIColor colorFromStr: @"#E96E44"]

//导航栏颜色
#define kNaviColor [UIColor colorFromStr: @"#066B98"]

//tabbarColor
#define kTabbarColor [UIColor colorFromStr: @"#FFFFFF"]

//红色
#define kRedColor [UIColor colorFromStr: @"#e62019"]

//323232color
#define k323232Color kColorFromStr(@"#313131")
#define k222222Color kColorFromStr(@"#222222")
#define k666666Color kColorFromStr(@"#666666")
#define k999999Color kColorFromStr(@"#999999")
#define kCCCCCCColor kColorFromStr(@"#cccccc")

#define k404040Color kColorFromStr(@"#404040")
#define kTableColor kColorFromStr(@"#f4f4f4")

#define kDarkGrayColor kColorFromStr(@"#979CAD")
#define kLightGrayColor kColorFromStr(@"#222222")
#define k111419Color kColorFromStr(@"#111419")
#define kMainColor kColorFromStr(@"#6189C5")


#define kThemeColor kTableColor

#define kServiceTimeKey @"kServiceTimeKey"

/**  蓝色 0080ff */
#define kBlueColor kColorFromStr(@"#1798f2")
//占位文字颜色
#define kPlaceholderColor kColorFromStr(@"#acacae")

//头像展位图
#define kAvatarString @"poc_icon_phot"

//灰线
#define kGrayLineColor [UIColor colorFromStr: @"#CCCCCC"]

//16进制颜色
#define kColorFromStr(str) [UIColor colorFromStr:str]

//字体
#define kPFMediumFtName              @"PingFangSC-Medium"
#define kPFRegularFtName             @"PingFangSC-Regular"
#define kPFLightFtName               @"PingFangSC-Light"
#define kPFSemiboldFtName            @"PingFangSC-Semibold"
//细体
#define PFLihgtFont(size) [UIFont pingFangSC_LightFontSize:size]
//常规
#define PFRegularFont(size) [UIFont pingFangSC_RegularFontSize:size]
//中黑
#define PFMediumFont(size) [UIFont pingFangSC_MediumFontSize:size]
//中粗
#define PFSemiboldFont(size) [UIFont pingFangSC_SemiboldFontSize:size]

#define HiraginoSans(size) [UIFont HiraginoSansW3FontSize:size]

//image
#define kImageFromStr(str) [UIImage imageNamed:str]

#define kCommonAlertView [JSYCommonAlertView sharedAlertView]


#define kCurrentLatitudeKey @"kCurrentLatitudeKey"
#define kCurrentLongitudeKey @"kCurrentLongitudeKey"

#define kChooseSubmitTypeKey @"kChooseSubmitTypeKey"


//占位图key
#define kImagePlaceHolder @"zhanweitu"
#define kUserAvatarDefault @"user_icon_phto"

#define ThAI @"zh-tw"



// 付款后状态消息
#define kPaySuccessKey  @"kPaySuccessKey"
#define kPayCanceledKey   @"kPayCanceledKey"
#define kPayFailedKey    @"kPayFailedKey"


#define kTokenExpiredKey @"kTokenExpiredKey"

//DeviceToken
#define kDeviceTokenKey @"kDeviceTokenKey"

//登录成功
#define kLoginSuccessKey @"kLoginSuccessKey"
//退出登录
#define kLoginOutKey @"kLoginOutKey"
//点击了登录界面的返回按钮
#define kDidClickLoginBackButton @"kDidClickLoginBackButton"

//登录成功 mall
#define kLoginSuccessForMallKey @"kLoginSuccessForMallKey"
//点击了登录界面的返回按钮 mall
#define kDidClickLoginBackForMallButton @"kDidClickLoginBackForMallButton"
#define kDidSubmitDistrictKey @"kDidSubmitDistrictKey"

//未读消息
#define kUnreadMessageCountKey @"kUnreadMessageCountKey"


#define kAllAvailableCurrencyArrayKey @"kAllAvailableCurrencyArrayKey"

//点击了提示框的按钮
#define kDidClickAlertViewButtonKey @"kDidClickAlertViewButtonKey"
#define kUserNeedToLoginOutKey @"kUserNeedToLoginOutKey"

//用户实名认证成功
#define kUserDidIdentifySuccessKey @"kUserDidIdentifySuccessKey"

#define kUserNotLoginCode 10100
#define kMessage @"message"
#define kData @"result"
#define kResult @"result"
#define kCode @"code"


#define kVideoPath [NSString stringWithFormat:@"/%@_newVideo.mov",kUserInfo.account]




#define kWechat @"wechat"
#define kYHK @"bank"
#define kZFB @"alipay"

//全剧静态WEB页面
#define playMethod @"mobile/News/detail/position_id/180"






#endif /* Constant_h */
