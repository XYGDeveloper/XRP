//
//  TPWalletExchangeRecordCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"


@interface TPWalletExchangeRecordCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *desCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property(nonatomic,strong)NSDictionary *dataDic;


@end
