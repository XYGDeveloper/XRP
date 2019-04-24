//
//  WarmAlertView.h
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sureEvent)(void);
typedef void (^cancelEvent)(void);

@interface WarmAlertView : UIView
@property (nonatomic,strong)sureEvent sure;
@property (nonatomic,strong)cancelEvent cancel;
+(void)AlertWith:(NSString *)title
          detail:(NSString *)detail
      leffButton:(NSString *)leffButton
      rightButton:(NSString *)rightButton
      controller:(UIViewController *)controller
      cancelAction:(cancelEvent)cancel
      sureAction:(sureEvent)sure;
@end
