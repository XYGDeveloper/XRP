//
//  YWDynamicModel+Request.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "YWDynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YWDynamicModel (Request)

+ (void)requestDynamicModelsWithPage:(NSInteger)page
                            pageSize:(NSInteger)pageSize
                             success:(void(^)(NSArray<YWDynamicModel *> *models, YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
