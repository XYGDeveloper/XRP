//
//  NSString+XPR.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XPR)

- (CGFloat)getTextHeightWithFont:(UIFont *)font width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
