//
//  UILabel+ZY.m
//  jianpan
//
//

#import "UILabel+ZY.h"

@implementation UILabel (ZY)


- (UILabel *)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSInteger)textAlignment adjustsFont:(BOOL)isAdjust
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.adjustsFontSizeToFitWidth = isAdjust;
    return label;
}


@end
