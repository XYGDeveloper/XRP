//
//  AppDelegate+ZY.m
//  jys
//
//  Copyright © 2017年 前海数交所. All rights reserved.
//

#import "AppDelegate+ZY.h"
#import <IQKeyboardManager.h>
//#import "JPUSHService.h"
//#import "ShareSDK/ShareSDK.h"
//#import "ShareSDKConnector/ShareSDKConnector.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import "TencentOpenAPI/TencentOAuth.h"
//#import "TencentOpenAPI/QQApiInterface.h"
//微信SDK头文件
//#import "WXApi.h"
//#import "WeiboSDK.h"

//#import "YWDiscoverViewController.h"
//#import "YWCircleViewController.h"

@implementation AppDelegate (ZY)

-(void)initIQKeyboard
{
    //实例IQ键盘单例
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
//    manager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框

    manager.enableAutoToolbar = NO;
    manager.keyboardDistanceFromTextField = 0;
//    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[CircleDetailController class]];
    

}

- (void)networkDidLogin:(NSNotification *)notification
{
    if (![Utilities isExpired]) {
        NSString *alias = [NSString stringWithFormat:@"%zd",kUserInfo.uid];
        
//        [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        } seq:0];
    }
}

//- (void)configShareSDK
//{
//    
//    [ShareSDK registerActivePlatforms:@[
//                                        @(SSDKPlatformTypeSinaWeibo),
//                                        @(SSDKPlatformTypeWechat),
//                                        @(SSDKPlatformTypeQQ)
//                                        ]
//                             onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
//             default:
//                 break;
//         }
//     }
//                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:kSinaWeiboAppKey
//                                           appSecret:kSinaWeiboAppSecret
//                                         redirectUri:@"http://www.sharesdk.cn"
//                                            authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:kWEChatOpenPlatformAppID
//                                       appSecret:kWEChatOpenPlatformSecret];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:kQQAppId
//                                      appKey:kQQAppKey
//                                    authType:SSDKAuthTypeSSO];
//                 break;
//             default:
//                 break;
//         }
//     }];
//}

-(void)successPay
{
    [[NSNotificationCenter defaultCenter] postNotificationName: kPaySuccessKey object: nil];
}

-(void)failedPay
{
    [[NSNotificationCenter defaultCenter] postNotificationName: kPayFailedKey object: nil];
}

-(void)cancelPay
{
    [[NSNotificationCenter defaultCenter] postNotificationName: kPayCanceledKey object: nil];
}


-(void)autoLoginAction
{
    
    if ([Utilities isExpired]) {
        kLOG(@"未登录");
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"platform"] = @"ios";
    param[@"token"]  = kUserInfo.token;
//    param[@"member_id"] = @(kUserInfo.uid);
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
//    [JSYBaseNetworking POST_HTTPS:kAutoLogin andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
//        if (success) {
//            kLOG(@"自动登录成功");
//            JSYUserInfo *model = kUserInfo;
//            
//            model = [JSYUserInfo modelWithDictionary:[responseObj ksObjectForKey:kResult]];
//            
//            [model saveUserInfo];
//            
//            [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSuccessKey  object:nil];
//
//
//            
//        }else{
//            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
//            [[NSNotificationCenter defaultCenter]postNotificationName:kTokenExpiredKey object:nil];
//            JSYUserInfo *model = kUserInfo;
//            model.token = @"";
//            [model saveUserInfo];
//
//        }
//    }];
}

//在didFinishLaunchingWithOptions方法中调用即可
- (void)add3DTouchItems:(UIApplication *)application{
    
    //给App图标添加3D Touch菜单
    //拍照
    
    //菜单图标
    UIApplicationShortcutIcon *iconCamera = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    //菜单文字
    UIMutableApplicationShortcutItem *itemCamera = [[UIMutableApplicationShortcutItem alloc] initWithType:@"1" localizedTitle:@"拍照"];
    //绑定信息到指定菜单
    itemCamera.icon = iconCamera;
    
    //相册
    //菜单图标
    UIApplicationShortcutIcon *iconPhotoLibrary = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    //菜单文字
    UIMutableApplicationShortcutItem *itemPhotoLibrary = [[UIMutableApplicationShortcutItem alloc] initWithType:@"2" localizedTitle:@"相册"];
    //绑定信息到指定菜单
    itemPhotoLibrary.icon = iconPhotoLibrary;
    
    UIMutableApplicationShortcutItem *openItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"3" localizedTitle:@"打开"];
    openItem.localizedSubtitle = @"文件详情";
    openItem.icon = nil;
    //绑定到App icon
    application.shortcutItems = @[itemCamera,itemPhotoLibrary,openItem];
    
}

@end
