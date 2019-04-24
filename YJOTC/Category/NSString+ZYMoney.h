//
//  NSString+ZYMoney.h
//  YJOTC
//
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 94863
 * NSNumberFormatterNoStyle = kCFNumberFormatterNoStyle,
 
 * 94,862.57
 * NSNumberFormatterDecimalStyle = kCFNumberFormatterDecimalStyle,
 
 * ￥94,862.57
 * NSNumberFormatterCurrencyStyle = kCFNumberFormatterCurrencyStyle,
 
 * 9,486,257%
 * NSNumberFormatterPercentStyle = kCFNumberFormatterPercentStyle,
 
 * 9.486257E4
 * NSNumberFormatterScientificStyle = kCFNumberFormatterScientificStyle,
 
 * 九万四千八百六十二点五七
 * NSNumberFormatterSpellOutStyle = kCFNumberFormatterSpellOutStyle
 */

@interface NSString (ZYMoney)

+ (NSString *)stringChangeMoneyWithStr:(NSString *)str numberStyle:(NSNumberFormatterStyle)numberStyle;


@end
