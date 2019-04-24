//
//  TPQuotationModel.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPQuotationModel.h"

@implementation TPQuotationModel
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"nprice_status" :@"new_price_status",
             @"nprice" : @"new_price",
             @"change_24H" : @"change_24",
             @"done_24H" : @"24H_done_num",
             @"currency_mark" : @"currency_mark",
             @"nprice_cny" : @"new_price_cny"
             };
}
@end
