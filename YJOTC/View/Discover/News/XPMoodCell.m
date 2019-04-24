//
//  XPMoodCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMoodCell.h"
#import "NSString+XPR.h"
#import "YWDynamicModel.h"

@interface XPMoodCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation XPMoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.containerView addShadow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

static CGFloat const kBottomStackHeight = 27.;
static CGFloat const kBottomPad = 20.;
static CGFloat const kContentToTopPad = 45.;
static CGFloat const kAvatarHeight = 48.;
static CGFloat const kAvatarToTopPad = 15.;
static CGFloat const kContainerBottomPad = 16.;

+ (CGFloat)heightOfModel:(YWDynamicModel *)model {
    NSString *content = @"A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!";
    CGFloat contentWidth = kScreenW - (13 + 65 + 20 + 13);
    CGFloat height = [content getTextHeightWithFont:[UIFont systemFontOfSize:12.] width:contentWidth];
    CGFloat contentToTopHeight = height + kContentToTopPad;
    CGFloat avatarToTopHeight = kAvatarToTopPad + kAvatarHeight;
    CGFloat maxHeight = MAX(contentToTopHeight, avatarToTopHeight);
    return ceilf(maxHeight + 12 + kBottomStackHeight + kBottomPad + kContainerBottomPad) ;
}

@end
