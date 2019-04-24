//
//  YTData_listModel.m
//  YJOTC
//
//  Created by l on 2018/10/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTData_listModel.h"

@implementation ListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"price": @"new_price",
             @"price_usd": @"new_price_usd",
             @"price_status": @"new_price_status",
             @"H24": @"24H_done_num",
             @"H24_change": @"24H_change",
             @"H24_down_num": @"24H_done_num",
             @"nw_price_unit" :@"new_price_unit"
             };
}


+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"price" :@"new_price",
             @"price_status" :@"new_price_status",
             @"price_usd" :@"new_price_usd",
             @"nw_price_unit" :@"new_price_unit"

             };
}


- (NSString *)currency_id {
    
    return [NSString stringWithFormat:@"%@_%@", _currency_id, _trade_currency_id];
}

- (NSString *)originalCurrency_id {
    return _currency_id;
}

- (NSString *)comcurrencyName {
    return [NSString stringWithFormat:@"%@/%@", _currency_mark, _trade_currency_mark];
}

- (NSString *)comcurrencyName1 {
    return [NSString stringWithFormat:@"%@_%@", _currency_mark, @"KOK"];
}

- (NSString *)change24String {
    return [NSString stringWithFormat:@"%@%%",self.change_24];
}

- (UIColor *)statusColor {
    if ([self.price_status isEqualToString:@"1"]){
        return kGreenColor;
    }else{
        return kOrangeColor;
    }
    
}

- (NSString *)getFeeFactorStringByIsBuy:(BOOL)isBuy {
    if (isBuy) {
        return [self getBuyFeeFactorString];
    } else {
        return [self getSellFeeFactorString];
    }
}

- (NSString *)getBuyFeeFactorString {
    CGFloat factor = 1 + self.currency_buy_fee / 100.;
    return [NSString stringWithFormat:@"%@", @(factor)];
}

- (NSString *)getSellFeeFactorString {
    CGFloat factor = 1 - self.currency_sell_fee / 100.;
    return [NSString stringWithFormat:@"%@", @(factor)];
}

@end

@implementation YTData_listModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"data_list" : @"ListModel",
             };
}

+ (NSArray<YTData_listModel *> *)sortArray:(NSArray<YTData_listModel *> *)array sortDescriptor:(NSSortDescriptor *)sortDescriptor {
    
    
    if (!array) {
        return nil;
    }
    
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
    
    [tmp enumerateObjectsUsingBlock:^(YTData_listModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *a = [obj.data_list sortedArrayUsingDescriptors:@[sortDescriptor]];
        obj.data_list = a;
    }];
    
    return tmp.copy;
}

- (id)copyWithZone:(NSZone *)zone {
    YTData_listModel *newModel = [[[self class] allocWithZone:zone] init];
    if (newModel) {
        newModel.name = self.name;
        newModel.id = self.id;
        newModel.data_list = self.data_list.copy;
    }
    
    return newModel;
}


@end
