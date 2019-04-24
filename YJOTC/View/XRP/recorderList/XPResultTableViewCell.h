//
//  XPResultTableViewCell.h
//  YJOTC
//
//  Created by l on 2019/1/3.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^tobind)(void);

@class XPSearchResultModel;

@interface XPResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
@property (weak, nonatomic) IBOutlet UILabel *inviteCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@property (nonatomic,strong)tobind bind;

- (void)refreshWithjijuoModel:(XPSearchResultModel *)model;
- (void)refreshWithjijuoModel1:(XPSearchResultModel *)model;

@end
