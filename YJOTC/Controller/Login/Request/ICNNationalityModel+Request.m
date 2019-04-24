//
//  ICNNationalityModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ICNNationalityModel+Request.h"

@implementation ICNNationalityModel (Request)

+ (void)requestCountryListWithSuccess:(void(^)(NSArray<ICNNationalityModel *> *array, YWNetworkResultModel *model))success
                              failure:(void(^)(NSError *error))failure {
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
    

//    [kNetwork_Tool objPOST:@"/Api/Account/countrylist" parameters:param success:^(YWNetworkResultModel *model, id responseObject) {
//        NSLog(@"%@", responseObject);
//        NSArray<ICNNationalityModel *> *array = [ICNNationalityModel mj_objectArrayWithKeyValuesArray:model.result];
//        if ([model succeeded]) {
//            if (success) {
//                success(array, model);
//            }
//        } else {
//            if (failure) {
//                failure(model.error);
//            }
//        }
//    } failure:failure];
    
}

@end
