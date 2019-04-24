//
//  XPQuotationModel.m
//  YJOTC
//
//  Created by Roy on 2018/12/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPQuotationModel.h"

@implementation XPQuotationModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"n_price" :@"new_price",
             @"n_price_status" :@"new_price_status",
             @"n_price_usd" :@"new_price_usd",
             @"nw_price_unit" :@"new_price_unit"
             };
}


@end
