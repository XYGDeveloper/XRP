//
//  XPsearchResultTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^tobind)(void);

@class XPSearchResultModel;
@class parentModel;
@class membersModel;
@class XPCommunityPrentModel;
@class XPCommunityUserModel;

@interface XPsearchResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *invitecode;

@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIImageView *headimg;
@property (weak, nonatomic) IBOutlet UILabel *nikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *jhuoButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong)tobind bind;
- (void)refreshWithModel:(XPSearchResultModel *)model;
- (void)refreshWithapplyModel:(parentModel *)model;
//激活
- (void)refreshWithjijuoModel:(XPSearchResultModel *)model;

- (void)refreshWithjijuoModel1:(membersModel *)model;

- (void)refreshWithjijuoModel2:(XPCommunityPrentModel *)model;
- (void)refreshWithjijuoModel3:(XPCommunityUserModel *)model;
- (void)refreshWithjijuoModel4:(XPSearchResultModel *)model;

@end

NS_ASSUME_NONNULL_END
