//
//  TPWalletExchangeDetailView.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPWalletExchangeDetailView : UIView

@property (weak, nonatomic) IBOutlet UILabel *accountLAbel;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftCuLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightCuLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *realLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMArgin1;


@property (weak, nonatomic) IBOutlet UILabel *tips;

@property(nonatomic,strong)NSDictionary *dataDic;


@end
