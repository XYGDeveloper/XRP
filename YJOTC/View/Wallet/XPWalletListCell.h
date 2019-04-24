//
//  XPWalletListCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPWalletCurrencyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XPWalletListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;

@property(nonatomic,strong)TPWalletCurrencyModel *model;

@end

NS_ASSUME_NONNULL_END
