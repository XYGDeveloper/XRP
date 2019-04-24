//
//  UpdateVersionManager.m
//  UUC
//
//  Created by Roy on 2018/11/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "UpdateVersionManager.h"

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
    
    if ([kBasePath containsString:@"tp://te"]) {
        return;
    }
    if ([kBasePath containsString:@"192"]) {
        return;
    }
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Api2/App/iosVersion"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        //http://d.bcbcom.club/q3
        if (success) {
            
            kLOG(@"%@",responseObj);
            
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            //            CFShow((__bridge CFTypeRef)(infoDictionary));
            // app名称
            //            NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            // app版本
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            // app build版本
            //            NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
            
            NSDictionary *dic = [responseObj ksObjectForKey:kResult];
            
            NSInteger isForceUpdata = [dic[@"versionForce"] integerValue] ;
            
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
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, 250, 120)];
    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
    tipsLabel.textColor = k323232Color;
    tipsLabel.font = PFRegularFont(16);
    tipsLabel.text = @"发现新版本,请前往升级";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, tipsLabel.bottom, midView.width, midView.height - tipsLabel.height) title:@"确定" titleColor:kBlueColor font:PFRegularFont(16) titleAlignment:0];
    
    [midView addSubview:button];
    
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton*  _Nonnull sender) {
        
        [self gotoSafariUpdataWith:_updateUrl];
        
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
