//
//  TPCurrencyPanKouCell.h
//  YJOTC
//
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPCurrencyPanKouCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyVolumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellVolumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sellLabel;

@property (weak, nonatomic) IBOutlet UILabel *sellPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *buyPriceLabel;



@end
