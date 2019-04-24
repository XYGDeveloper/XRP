//
//  XPCommunityHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPCommunityLeHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nikeDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsfirLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipSecLabel;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@property(nonatomic,strong)NSDictionary *dataDic;


@end

NS_ASSUME_NONNULL_END
