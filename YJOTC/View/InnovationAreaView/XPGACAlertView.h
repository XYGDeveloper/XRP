//
//  XPGACAlertView.h
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPGACAlertView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *accounterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouxuLabel;
@property (weak, nonatomic) IBOutlet UILabel *xrpCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *shijiLabel;
@property (weak, nonatomic) IBOutlet UILabel *guzhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBomLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBomLabel;

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
