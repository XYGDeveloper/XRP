//
//  XPMoodBasicCell.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPMoodBasicCell, YWDynamicModel;
@protocol XPMoodBasicCellDelegate <NSObject>

- (void)moodBasicCell:(XPMoodBasicCell *)cell likedForModel:(YWDynamicModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN
@class  YWDynamicModel, XPMoodCellLayout;
@interface XPMoodBasicCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, weak) id<XPMoodBasicCellDelegate> delegate;

@property (nonatomic, strong) YWDynamicModel *model;

- (void)configureCellWithModel:(YWDynamicModel *)model layout:(XPMoodCellLayout *)layout;

@end

NS_ASSUME_NONNULL_END
