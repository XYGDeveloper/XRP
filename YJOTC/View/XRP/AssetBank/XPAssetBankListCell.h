//
//  XPAssetBankListCell.h
//  YJOTC
//
//  Created by Roy on 2018/12/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPAssetBankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XPAssetBankListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *timaLabel;

//@property(nonatomic,strong)NSDictionary *dataDic;

@property(nonatomic,strong)XPAssetBankModel *model;


@end

NS_ASSUME_NONNULL_END
