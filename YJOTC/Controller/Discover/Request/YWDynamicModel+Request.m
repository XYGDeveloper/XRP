//
//  YWDynamicModel+Request.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "YWDynamicModel+Request.h"

@implementation YWDynamicModel (Request)

+ (void)requestDynamicModelsWithPage:(NSInteger)page
                                pageSize:(NSInteger)pageSize
                                 success:(void(^)(NSArray<YWDynamicModel *> *models, YWNetworkResultModel *obj))success
                                 failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"request_type" : @"list",
                                 @"page" : @(page),
                                 @"page_size" : @(pageSize),
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/zhongchoum/detailsm_log_release" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                NSArray<YWDynamicModel *> *models = [NSArray modelArrayWithClass:YWDynamicModel.class json:model.result];
                success(models, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

@end
