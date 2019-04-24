//
//  XPInternaPurchaseTableViewCell.h
//  YJOTC
//
//  Created by l on 2019/4/3.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XPGACInnerPurchModel;
@interface XPInternaPurchaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *innerPauseLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabelCurrencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabelCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *LeveleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepMiddleLabel;

- (void)refreshWithMOdel:(XPGACInnerPurchModel *)model;

@end

NS_ASSUME_NONNULL_END
