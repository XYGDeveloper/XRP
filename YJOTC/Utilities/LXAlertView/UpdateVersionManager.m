//
//  UpdateVersionManager.m
//  UUC
//
//  Created by Roy on 2018/11/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "UpdateVersionManager.h"
#import "LXAlertView.h"

static UpdateVersionManager *__manager = nil;

@interface UpdateVersionManager ()

@property(nonatomic,copy)NSString *updateUrl;


@end


@implementation UpdateVersionManager


+ (instancetype)sharedUpdate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[UpdateVersionManager alloc] init];
    });
    return __manager;
}


- (void)versionControl{
    
//    if ([kBasePath containsString:@"tp://te"]) {
//        return;
//    }
//    if ([kBasePath containsString:@"192"]) {
//        return;
//    }
    
    
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
    param[@"platform"] = @"ios";
    
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/District/version"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        //http://d.bcbcom.club/q3
        if (success) {
            
            kLOG(@"%@",responseObj);
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            //            NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            // app版本
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            // app build版本
            
            NSDictionary *dic = [responseObj ksObjectForKey:kResult];
            
            int time =  [dic[@"last_get"] longLongValue] - [NSDate new].timeIntervalSince1970;
            
            [kUserDefaults setObject:@(time) forKey:kServiceTimeKey];
            
            
//            NSInteger isForceUpdata = [dic[@"versionForce"] integerValue] ;
            
            NSArray *tipsArr = dic[@"mobile_apk_explain"];
            NSMutableString *tipsStr = [NSMutableString new];
            for (NSDictionary *dic in tipsArr) {
                [tipsStr appendString:[NSString stringWithFormat:@"%@\n",dic[@"text"]]];
            }
            
            if (![dic[@"versionName"] isEqualToString:app_Version]) {
                
                LXAlertView *alert=[[LXAlertView alloc] initWithTitle:kLocat(@"U_updataTips") message:tipsStr.mutableCopy cancelBtnTitle:nil otherBtnTitle:kLocat(@"U_update") clickIndexBlock:^(NSInteger clickIndex) {
                    
                    [self gotoSafariUpdataWith:_updateUrl];
                    
//                    NSLog(@"点击index====%ld",clickIndex);
                }];
                alert.animationStyle = LXASAnimationDefault;
                [alert showLXAlertView];
                alert.dontDissmiss = YES;
                
                _updateUrl = dic[@"downloadUrl"];

            }
        }
    }];
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
