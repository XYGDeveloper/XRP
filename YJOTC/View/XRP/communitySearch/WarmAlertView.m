//
//  WarmAlertView.m
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "WarmAlertView.h"
@interface WarmAlertView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@end

@implementation WarmAlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.bgview.layer.cornerRadius = 4;
    self.bgview.layer.masksToBounds = YES;
}

+ (void)AlertWith:(NSString *)title detail:(NSString *)detail leffButton:(NSString *)leffButton rightButton:(NSString *)rightButton controller:(UIViewController *)controller cancelAction:(cancelEvent)cancel sureAction:(sureEvent)sure{
    
    WarmAlertView *alert = [[NSBundle mainBundle]loadNibNamed:@"WarmAlertView" owner:nil options:nil][0];
    alert.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    alert.titleLabel.text = title;
    alert.detailLabel.text = detail;
    alert.sure = sure;
    alert.cancel = cancel;
    [alert.cancelButton setTitle:leffButton forState:UIControlStateNormal];
    [alert.sureButton setTitle:rightButton forState:UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    alert.bgview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    alert.bgview.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        alert.bgview.transform = transform;
        alert.bgview.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}


- (IBAction)cancelAction:(id)sender {
    if (self.cancel) {
        self.cancel();
    }
    [self removeFromSuperview];
    
}


- (IBAction)sureAction:(id)sender {
    
    if (self.sure) {
        self.sure();
    }
    [self removeFromSuperview];

    
}








@end
