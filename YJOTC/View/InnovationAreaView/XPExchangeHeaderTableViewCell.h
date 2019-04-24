//
//  XPExchangeHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPExchangeInnocationModel;

@interface XPExchangeHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *currencyLabel;
@property (weak, nonatomic) IBOutlet UITextField *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *chuzhangLabel;
@property (weak, nonatomic) IBOutlet UILabel *countNameLabel;

- (void)refreshWithModel:(XPExchangeInnocationModel *)model;

@end
