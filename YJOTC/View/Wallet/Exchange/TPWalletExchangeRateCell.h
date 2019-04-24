//
//  TPWalletExchangeRateCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPWalletExchangeRateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *exchangeInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightPriceLabel;



@end
