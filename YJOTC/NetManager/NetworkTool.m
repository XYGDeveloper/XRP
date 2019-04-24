//
//  NetworkTool.m
//  ywshop
//
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "NetworkTool.h"
#import "YTLoginManager.h"


typedef NS_ENUM(NSInteger, NetworkRequestMethod) {
    NetworkRequestMethodGET,
    NetworkRequestMethodPOST
};


@interface NetworkTool ()


@end

@implementation NetworkTool

static NetworkTool * singleton;

+ (instancetype)sharedTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singleton = [[NetworkTool alloc] initWithBaseURL:kBasePath.ks_URL];
//        singleton = [[NetworkTool alloc] init];
//        singleton.responseSerializer = [AFHTTPResponseSerializer serializer];

//        singleton.requestSerializer = [AFJSONRequestSerializer serializer];
        singleton.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"image/png", @"text/json", @"text/javascript", @"text/plain", nil];
//        singleton.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    });
    return singleton;
}

/**  post请求  */
- (void)POST_HTTPS :(NSString *) req_URL andParam:(NSDictionary *)param completeBlock:(void (^)(BOOL success,NSDictionary *responseObj,NSError *error ))completeBlock
{
    if ([Utilities netWorkUnAvalible]) {
        YJBaseViewController *vc = (YJBaseViewController *)[kKeyWindow visibleViewController];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc showTips:kLocat(@"U_checktourNetwork")];
        });
        completeBlock(NO,nil, nil);

        return;
    }
    param = [self _wapperParameters:param];

  AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:kBasePath.ks_URL];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"image/png", @"text/json", @"text/javascript", @"text/plain", nil];
    manager.requestSerializer.timeoutInterval = 20.0f;
    [manager POST:req_URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {
            NSInteger code = [[responseObject ksObjectForKey:kCode] integerValue];

            BOOL status = code == 10000 ? YES : NO;
            
            completeBlock(status , responseObject,nil);

            if (code == 10100) {
                
                [kUserInfo clearUserInfo];
                if (![[kKeyWindow visibleViewController] isKindOfClass:[HBLoginTableViewController class]]) {
                    if ([Utilities isExpired]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIViewController *vc = [HBLoginTableViewController fromStoryboard];
                            [[kKeyWindow visibleViewController] presentViewController:vc animated:YES completion:nil];
                        });
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(NO,nil, error);
        kLOG(@"%@",error);
        YJBaseViewController *vc = (YJBaseViewController *)[kKeyWindow visibleViewController];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc showTips:kLocat(@"U_networkfailplzretry")];
        });
    }];
}

/**  get请求  */
- (void)GET_HTTPS :(NSString *) req_URL andParam:(NSDictionary *)param completeBlock:(void (^)(BOOL success,NSDictionary *responseObj, NSError *error))completeBlock
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:kBasePath.ks_URL];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"image/png", @"text/json", @"text/javascript", @"text/plain", nil];
    [manager GET:req_URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject ksObjectForKey:@"code"] integerValue];
        
        BOOL status = code == 10000 ? YES : NO;
        
        if (code == 10000 || code == 200) {
            status = YES;
        }else{
            status = NO;
        }
        
        if (status == YES) {
            completeBlock(YES , responseObject,nil);
            
        }else{
            
            completeBlock( NO,responseObject,nil);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        kLOG(@"%@",error);
        //        [self showNetRequestResultTip];
    }];
 
}


- (NSDictionary *)_wapperParameters:(NSDictionary *)parameters {
    if (!parameters) {
        parameters = @{};
    }
    NSMutableDictionary *tmp = parameters.mutableCopy;
    if (![parameters.allKeys containsObject:@"language"]) {
        NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
        NSString *lang = nil;
        if ([currentLanguage containsString:@"en"]) {//英文
            lang = @"en-us";
        }else if ([currentLanguage containsString:@"Hant"]){//繁体
            lang = @"zh-tw";
        }else{//泰文
            lang = @"zh-tw";
        }
        
        tmp[@"language"] = lang ?: @"zh-tw";
    }
    
    
//    for (NSString *value in parameters.allValues) {
//        if ([value isKindOfClass:[NSString class]]) {
//   
//            
//        }        
//    }
    
    
    if (![parameters.allKeys containsObject:@"token_id"] && kUserInfo.uid > 0) {
        tmp[@"token_id"] = @(kUserInfo.uid);
    }
    
    if (![parameters.allKeys containsObject:@"key"] && kUserInfo.token) {
        tmp[@"key"] = kUserInfo.token ?: @"";
    }
    
    if (![parameters.allKeys containsObject:@"platform"]) {
        tmp[@"platform"] = @"ios";
    }
    if (![parameters.allKeys containsObject:@"uuid"]) {
        tmp[@"uuid"] = [Utilities randomUUID];
    }
    
    long time = [[kUserDefaults objectForKey:kServiceTimeKey] longLongValue] + [NSDate new].timeIntervalSince1970;
    
    tmp[@"sign__time"] = [NSString stringWithFormat:@"%ld",time];
    
    tmp[@"sign"] = [Utilities handleParamsWithDic:tmp];
    
    return tmp.copy;
}

- (NSURLSessionDataTask *)objPOST:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void(^)(YWNetworkResultModel *model, id responseObject))success
                          failure:(void(^)(NSError *error))failure {
    
    return [self requestMethod:NetworkRequestMethodPOST
                     URLString:URLString
                    parameters:parameters
                       success:success
                       failure:failure];
}
- (NSURLSessionDataTask *)requestMethod:(NetworkRequestMethod)requestMethod
                              URLString:(NSString *)URLString
                             parameters:(NSDictionary *)parameters
                                success:(void(^)(YWNetworkResultModel *data, id responseObject))success
                                failure:(void(^)(NSError *error))failure {
    parameters = [self _wapperParameters:parameters];
    
    void(^successHandler)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            YWNetworkResultModel *model = [YWNetworkResultModel modelWithJSON:responseObject];
            success(model, responseObject);
        }
    };
    
    switch (requestMethod) {
        case NetworkRequestMethodGET:
            return [self GET:URLString parameters:parameters progress:nil success:successHandler failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            break;
            
        case NetworkRequestMethodPOST:
            return [self POST:URLString parameters:parameters progress:nil success:successHandler failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            break;
    }
}


@end
