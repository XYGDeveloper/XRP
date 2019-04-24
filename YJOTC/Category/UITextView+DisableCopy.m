//
//  UITextView+DisableCopy.m
//  YJOTC
//
//  Copyright © 2019年 前海. All rights reserved.
//

#import "UITextView+DisableCopy.h"

@implementation UITextView (DisableCopy)

/**
 *  创建UITextField 的catgory ，将此方法粘贴到.m文件。
 *  也就是重写长按方法 ,将长按的菜单关闭掉.
 *  @return 在需要使用的类直接引入.h文件即可 无需调用
 */

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    //一旦双击，里面禁用。取消第一响应者，设置不可交互。
    [self resignFirstResponder];
//    self.userInteractionEnabled = NO;
    
    if ([UIMenuController sharedMenuController])
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    
    return NO;
}

@end
