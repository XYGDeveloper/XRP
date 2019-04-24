//
//  XPGetFridendListApi.h
//  YJOTC
//
//  Created by l on 2019/1/5.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "BaseListApi.h"

@interface XPGetFridendListApi : BaseListApi
- (instancetype)initWithKey:(NSString *)token
                   token_id:(NSString *)token_id;
@end
