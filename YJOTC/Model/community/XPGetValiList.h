//
//  XPGetValiList.h
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "BaseListApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface XPGetValiList : BaseListApi
- (instancetype)initWithKey:(NSString *)token
                   token_id:(NSString *)token_id;
@end

NS_ASSUME_NONNULL_END
