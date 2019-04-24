//
//  XPOTCBuyListCellCell.h
//  YJOTC
//
//  Created by Roy on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPOTCBuyListCellCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *way1;

@property (weak, nonatomic) IBOutlet UIImageView *way2;
@property (weak, nonatomic) IBOutlet UIImageView *way3;

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
/**  是否是个人商户页  */
@property(nonatomic,assign)BOOL isProfile;

@property(nonatomic,strong)TPOTCOrderModel *model;


@end

NS_ASSUME_NONNULL_END
