//
//  XPInfoAlertView.h
//  YJOTC
//
//  Created by l on 2019/3/18.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPInfoAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgview;
+ (void)alertControllerAppearIn:(UIViewController *)controller
                  accounterName:(NSString *)accounterName
                     statusText:(NSString *)statusText
                    publishTime:(NSString *)publishTime
                     finishTime:(NSString *)finishTime
                            xrp:(NSString *)xrp
                         shouxu:(NSString *)shouxu
                          shiji:(NSString *)shiji
                          guzhi:(NSString *)guzhi
                           note:(NSString *)note
                   leftTtopText:(NSString *)leftTtopText
                   leftTbomText:(NSString *)leftTbomText
                   rightTopText:(NSString *)rightTopText
                   rightBomText:(NSString *)rightBomText;
@end

NS_ASSUME_NONNULL_END
