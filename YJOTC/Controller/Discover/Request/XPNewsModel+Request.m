//
//  XPNewsModel+Request.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/13.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPNewsModel+Request.h"

@implementation XPNewsModel (Request)

+ (void)requestNewsModelsWithPage:(NSInteger)page
                         pageSize:(NSInteger)pageSize
                          success:(void(^)(NSArray<XPNewsModel *> *models, YWNetworkResultModel *obj))success
                          failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"page" : @(page),
                                 @"rows" : @(pageSize),
                                 };
    
    [kNetwork_Tool objPOST:@"/api/News/newsList" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                NSArray<XPNewsModel *> *models = [NSArray modelArrayWithClass:XPNewsModel.class json:model.result];
                success(models, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

@end
