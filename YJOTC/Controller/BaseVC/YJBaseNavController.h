//
//  YJBaseNavController.h
//  YJOTC
//
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ATKeyWindow     [[UIApplication sharedApplication] keyWindow]
#define ATNavViewW      [UIScreen mainScreen].bounds.size.width

#define ATAnimationDuration     0.5f
#define ATMinX                  (0.3f * ATNavViewW)

@interface UIViewController (ATNavigationControllerAdd)
/**
 *  If yes, disable the drag back, default no.
 */
@property (nonatomic, assign) BOOL disableDragBack;

@end



@interface YJBaseNavController : UINavigationController


@property (nonatomic , assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic , assign) UIInterfaceOrientationMask interfaceOrientationMask;


@end
