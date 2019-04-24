//
//  NSString+XPR.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "NSString+XPR.h"

@implementation NSString (XPR)

- (CGFloat)getTextHeightWithFont:(UIFont *)font width:(CGFloat)width {
    NSDictionary *attributes = @{NSFontAttributeName : font};
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGRectGetHeight(rect);
}

@end
