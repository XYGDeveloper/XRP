//
//  TPWalletListCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPWalletCurrencyModel.h"

@interface TPWalletListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;

@property(nonatomic,strong)TPWalletCurrencyModel *model;


@end
