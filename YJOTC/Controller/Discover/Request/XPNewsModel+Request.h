//
//  XPNewsModel+Request.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/13.
//  Copyright © 2018年 前海. All rights reserved.
//


#import "XPNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XPNewsModel (Request)

+ (void)requestNewsModelsWithPage:(NSInteger)page
                         pageSize:(NSInteger)pageSize
                          success:(void(^)(NSArray<XPNewsModel *> *models, YWNetworkResultModel *obj))success
                          failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
