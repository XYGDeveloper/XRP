//
//  XPZhuanZhangConfirmView.h
//  YJOTC
//
//  Created by Roy on 2018/12/19.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBlcok) (UIButton *sureButton);
typedef void(^scaleBlcok) (UIButton *scaleButton);
@interface XPZhuanZhangConfirmView : UIView


@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UILabel *payway;
@property (weak, nonatomic) IBOutlet UILabel *paywayLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
//
@property (weak, nonatomic) IBOutlet UILabel *mingxiLabel;
@property (weak, nonatomic) IBOutlet UILabel *mywalletLabelContent;
@property (weak, nonatomic) IBOutlet UILabel *rbContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *scaleButton;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

/**  点提交的回调  */
@property(nonatomic,copy)ConfirmBlcok callBackBlock;
@property(nonatomic,copy)scaleBlcok scaleBlocks;


@end


