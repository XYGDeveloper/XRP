//
//  UIView+Shadow.h
//  YJOTC
//
//  Created by Roy on 2018/12/10.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Effects.h"

@interface UIView (Shadow)

/**  添加圆角  */
//- (void)addCornerRadius:(CGFloat)radius;

/**  添加边框  */
//- (void)addBorderWith:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**  添加阴影  */
//- (void)addShadowAndCornerRadius;


/**  先切圆角,再加阴影  必须 masksToBounds = NO  */
-(void)addShadow;



//- (void)addShadowAndCornerRadius;

@end


