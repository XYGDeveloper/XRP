


//
//  TPWalletCurrencyModel.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletCurrencyModel.h"

@implementation TPWalletCurrencyModel


+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"cny_total" :@"money",
             @"nw_price_unit" :@"new_price_unit"

             };
}

@end
