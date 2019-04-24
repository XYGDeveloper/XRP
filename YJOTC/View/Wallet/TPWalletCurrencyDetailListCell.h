//
//  TPWalletCurrencyDetailListCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPWalletCurrencyDetailListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**  账本数据  */
@property(nonatomic,strong)NSDictionary *accountDic;

/**  资产详情数据  */
@property(nonatomic,strong)NSDictionary *dataDic;


@end
