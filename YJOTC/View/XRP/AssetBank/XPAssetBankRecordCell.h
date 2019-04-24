//
//  XPAssetBankRecordCell.h
//  YJOTC
//
//  Created by Roy on 2018/12/21.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPAssetBankRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property(nonatomic,strong)NSDictionary *dic;


@end


