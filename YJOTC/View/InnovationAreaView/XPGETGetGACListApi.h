//
//  XPGETGetGACListApi.h
//  YJOTC
//
//  Created by l on 2019/3/18.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "BaseListApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface XPGETGetGACListApi : BaseListApi
- (instancetype)initWithKey:(NSString *)token
                   token_id:(NSString *)token_id;
@end

NS_ASSUME_NONNULL_END
