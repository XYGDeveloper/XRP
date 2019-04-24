//
//  XPNewsCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPNewsCell.h"
#import "XPNewsModel.h"
#import "UIView+Animation.h"

@interface XPNewsCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation XPNewsCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.containerView addShadow];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.timeLabel.text = nil;
    self.picImageView.image = nil;
    self.titleLabel.text = nil;
    self.contentLabel.text = nil;
}


#pragma mark - Setters

- (void)setModel:(XPNewsModel *)model {
    _model = model;
    self.timeLabel.text = model.add_time;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    [self.picImageView setImageWithURL:[NSURL URLWithString:model.art_pic] options:YYWebImageOptionShowNetworkActivity];
}

@end
