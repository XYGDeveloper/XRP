//
//  XPGACAlertView.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPGACAlertView.h"

@implementation XPGACAlertView


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

+ (void)alertControllerAppearIn:(UIViewController *)controller accounterName:(NSString *)accounterName statusText:(NSString *)statusText publishTime:(NSString *)publishTime finishTime:(NSString *)finishTime xrp:(NSString *)xrp shouxu:(NSString *)shouxu shiji:(NSString *)shiji guzhi:(NSString *)guzhi note:(NSString *)note leftTtopText:(NSString *)leftTtopText leftTbomText:(NSString *)leftTbomText rightTopText:(NSString *)rightTopText rightBomText:(NSString *)rightBomText{
    
    XPGACAlertView *alert = [[NSBundle mainBundle]loadNibNamed:@"XPGACAlertView" owner:nil options:nil][0];
    alert.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    alert.accounterNameLabel.text = accounterName;
    alert.statusLabel.text = statusText;
    alert.pubTimeLabel.text = publishTime;
    alert.finishTimeLabel.text = finishTime;
    alert.xrpCountLabel.text = xrp;
    alert.shouxuLabel.text = shouxu;
    alert.shijiLabel.text = shiji;
    alert.guzhiLabel.text = guzhi;
    alert.noteLabel.text = note;
    alert.leftLabel.text = leftTtopText;
    alert.leftBomLabel.text = leftTbomText;
    alert.rightLabel.text = rightTopText;
    alert.rightBomLabel.text = rightBomText;
    [controller.view addSubview:alert];
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    alert.bgview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    alert.bgview.alpha = 0;
    /**
     *  usingSpringWithDamping：0-1 数值越小，弹簧振动效果越明显
     *  initialSpringVelocity ：数值越大，一开始移动速度越快
     */
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        alert.bgview.transform = transform;
        alert.bgview.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}


@end
