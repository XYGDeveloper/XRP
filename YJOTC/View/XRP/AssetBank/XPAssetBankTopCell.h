//
//  XPAssetBankTopCell.h
//  YJOTC
//
//  Created by Roy on 2018/12/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPAssetBankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XPAssetBankTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descLabel1;

@property (weak, nonatomic) IBOutlet UILabel *descLabel2;

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel1;

@property (weak, nonatomic) IBOutlet UILabel *signLabel;


@property (weak, nonatomic) IBOutlet UILabel *manLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *day;

@property(nonatomic,copy)XPAssetBankModel * model;



@end

NS_ASSUME_NONNULL_END
