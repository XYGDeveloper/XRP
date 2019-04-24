//
//  XPInnocationExcangeTableViewCell.h
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPExchangeInnocationModel;

@interface XPInnocationExcangeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *letCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *letBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
- (void)refreshWithModel:(XPExchangeInnocationModel *)model;

@end
