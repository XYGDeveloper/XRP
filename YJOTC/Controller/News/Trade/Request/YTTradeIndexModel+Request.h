//
//  YTTradeIndexModel+Request.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeIndexModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YTTradeIndexModel;
@interface YTTradeIndexModel (Request)

+ (void)requestTradeIndexsWithCurrencyID:(NSString *)ID
                                 success:(void(^)(YTTradeIndexModel *model, YWNetworkResultModel *obj))success
                                 failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END