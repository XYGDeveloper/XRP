//
//  XPGetLogListApi.h
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "BaseListApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface XPGetLogListApi : BaseListApi
- (instancetype)initWithKey:(NSString *)token
                   token_id:(NSString *)token_id
                       type:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
