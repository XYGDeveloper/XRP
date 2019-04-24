//
//  NSString+Operation.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Operation)

+ (NSDecimalNumberHandler *)decimalNumberHandlerByScale:(NSInteger)scale;

- (NSString *)resultByDividingByNumber:(NSString *)text roundingScale:(NSInteger)scale;

- (NSString *)resultByDividingByNumber:(NSString *)text;

- (NSString *)resultByMultiplyingByNumber:(NSString *)text;

- (NSDecimalNumber *)toDecimalNumber;

- (NSString *)toUsdFormat:(NSString *)format;

- (NSString *)roundWithScale:(NSInteger)scale;
/**  截取小数点后6位，使用 rouning Down  */
- (NSString *)rouningDownByScale:(NSInteger)scale;

- (NSString *)resultBySubtractingByNumber:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
