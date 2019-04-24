//
//  XPMoodBasicCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMoodBasicCell.h"
#import "XPMoodCellLayout.h"
#import "YWDynamicModel.h"
#import "UIView+Animation.h"
#import "XPShrinkAnimatedView.h"

@interface XPMoodBasicCell () <UIGestureRecognizerDelegate>

@end

@implementation XPMoodBasicCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _commonInit];
    }
    return self;
}


#pragma mark - Public

- (void)configureCellWithModel:(YWDynamicModel *)model layout:(XPMoodCellLayout *)layout {
    
    self.model = model;
    self.messageLabel.text = model.content;
    self.dateLabel.text = model.add_time;
    self.nicknameLabel.text = model.username;
    
    self.containerView.frame = layout.basicLayout.containerViewFrame;
    self.avatarImageView.frame = layout.basicLayout.avatarImageViewFrame;
    self.nicknameLabel.frame = layout.basicLayout.nicknameLabelFrame;
    self.followButton.frame = layout.basicLayout.followButtonFrame;
    self.messageLabel.frame = layout.basicLayout.messageTextViewFrame;
    self.dateLabel.frame = layout.basicLayout.dateLabelFrame;
    self.likeButton.frame = layout.basicLayout.likeButtonFrame;
    self.commentButton.frame = layout.basicLayout.commentButtonFrame;
}


#pragma mark - Private

- (void)_commonInit {
    
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.avatarImageView];
    [self.containerView addSubview:self.nicknameLabel];
    [self.containerView addSubview:self.followButton];
    [self.containerView addSubview:self.messageLabel];
    [self.containerView addSubview:self.dateLabel];
    [self.containerView addSubview:self.likeButton];
    [self.containerView addSubview:self.commentButton];
    self.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - Setters && Getters

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [XPShrinkAnimatedView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        [_containerView addShadow];
        _containerView.layer.cornerRadius = 8.;
    }
    
    return _containerView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., 48., 48.)];
        _avatarImageView.layer.cornerRadius = 24.;
        _avatarImageView.backgroundColor = kColorFromStr(@"F4F4F4");
    }
    
    return _avatarImageView;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.textColor = kColorFromStr(@"222222");
        _nicknameLabel.font = [UIFont systemFontOfSize:16.];
    }
    
    return _nicknameLabel;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 50., 20.)];
        _followButton.layer.cornerRadius = 3.;
        _followButton.backgroundColor = kColorFromStr(@"#3284CA");
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:12.];
        [_followButton setTitle:@"follow" forState:UIControlStateNormal];
        [_followButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _followButton;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.textColor = kColorFromStr(@"#666666");
        _messageLabel.font = [UIFont systemFontOfSize:12.];
        _messageLabel.numberOfLines = 0;
    }
    
    return _messageLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.textColor = kColorFromStr(@"#999999");
        _dateLabel.font = [UIFont systemFontOfSize:12.];
    }
    
    return _dateLabel;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton new];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:12.];
        [_likeButton setTitleColor:kColorFromStr(@"#999999") forState:UIControlStateNormal];
        [_likeButton setTitle:@"1000" forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton new];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:12.];
        [_commentButton setTitleColor:kColorFromStr(@"#999999") forState:UIControlStateNormal];
        [_commentButton setTitle:@"1000" forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

#pragma mark - Actions

- (void)tappedAction:(UITapGestureRecognizer *)recognizer {
    
}

- (void)followAction:(UIButton *)button {
    
}

- (void)commentAction:(UIButton *)button {
    
}

- (void)likeAction:(UIButton *)button {
    
}

@end
