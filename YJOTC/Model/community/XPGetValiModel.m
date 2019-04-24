//
//  XPGetValiModel.m
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPGetValiModel.h"

@implementation currentModel

@end

@implementation innerModel

@end

@implementation outterModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"child" : @"innerModel",
             };
}
@end

@implementation XPGetValiModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"list" : @"outterModel",
             };
}


@end
