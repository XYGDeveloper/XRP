//
//  TPOTCBuyOrderDetailView.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPOTCBuyOrderDetailView : UIView

@property (weak, nonatomic) IBOutlet UITextField *topTF;

@property (weak, nonatomic) IBOutlet UITextField *bottomTF;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UILabel *lineView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UILabel *remark;

@property (weak, nonatomic) IBOutlet UITextView *remarkTV;


@property(nonatomic,strong)TPOTCOrderModel *model;


- (IBAction)hideAction:(id)sender;


@end
