//
//  TPNewerDrawCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPQuotationModel.h"

@interface TPNewerDrawCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *trendLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineView;


@property(nonatomic,strong)TPQuotationModel *model;


@property(nonatomic,strong)NSDictionary *dic;




@end
