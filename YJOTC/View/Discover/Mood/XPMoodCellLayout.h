//
//  XPMoodCellLayout.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPMoodCellBiggerLayout : NSObject

@property (nonatomic, assign) CGRect biggerImageViewFrame;

@end

@interface XPMoodCellTwoLayout : NSObject

@property (nonatomic, assign) CGRect imageView1Frame;
@property (nonatomic, assign) CGRect imageView2Frame;

@end

@interface XPMoodCellThreeLayout : NSObject

@property (nonatomic, assign) CGRect imageView1Frame;
@property (nonatomic, assign) CGRect imageView2Frame;
@property (nonatomic, assign) CGRect imageView3Frame;

@end

@interface XPMoodCellFourLayout : NSObject

@property (nonatomic, assign) CGRect imageView1Frame;
@property (nonatomic, assign) CGRect imageView2Frame;
@property (nonatomic, assign) CGRect imageView3Frame;
@property (nonatomic, assign) CGRect imageView4Frame;

@end

@interface XPMoodCellFiveLayout : NSObject

@property (nonatomic, assign) CGRect imageView1Frame;
@property (nonatomic, assign) CGRect imageView2Frame;
@property (nonatomic, assign) CGRect imageView3Frame;
@property (nonatomic, assign) CGRect imageView4Frame;
@property (nonatomic, assign) CGRect imageView5Frame;

@end

@interface XPMoodCellSixLayout : NSObject

@property (nonatomic, assign) CGRect imageView1Frame;
@property (nonatomic, assign) CGRect imageView2Frame;
@property (nonatomic, assign) CGRect imageView3Frame;
@property (nonatomic, assign) CGRect imageView4Frame;
@property (nonatomic, assign) CGRect imageView5Frame;
@property (nonatomic, assign) CGRect imageView6Frame;

@end

@interface XPMoodCellSevenLayout : NSObject

@property (nonatomic, assign) CGRect imageView1Frame;
@property (nonatomic, assign) CGRect imageView2Frame;
@property (nonatomic, assign) CGRect imageView3Frame;
@property (nonatomic, assign) CGRect imageView4Frame;
@property (nonatomic, assign) CGRect imageView5Frame;
@property (nonatomic, assign) CGRect imageView6Frame;
@property (nonatomic, assign) CGRect imageView7Frame;

@end

@interface XPMoodCellEightLayout : NSObject

@property (nonatomic, assign) CGRect imageView1Frame;
@property (nonatomic, assign) CGRect imageView2Frame;
@property (nonatomic, assign) CGRect imageView3Frame;
@property (nonatomic, assign) CGRect imageView4Frame;
@property (nonatomic, assign) CGRect imageView5Frame;
@property (nonatomic, assign) CGRect imageView6Frame;
@property (nonatomic, assign) CGRect imageView7Frame;
@property (nonatomic, assign) CGRect imageView8Frame;

@end

@interface XPMoodCellNineLayout : NSObject

@property (nonatomic, assign) CGRect imageView1Frame;
@property (nonatomic, assign) CGRect imageView2Frame;
@property (nonatomic, assign) CGRect imageView3Frame;
@property (nonatomic, assign) CGRect imageView4Frame;
@property (nonatomic, assign) CGRect imageView5Frame;
@property (nonatomic, assign) CGRect imageView6Frame;
@property (nonatomic, assign) CGRect imageView7Frame;
@property (nonatomic, assign) CGRect imageView8Frame;
@property (nonatomic, assign) CGRect imageView9Frame;

@end

@interface XPMoodCellBasicLayout : NSObject

@property (nonatomic, assign) CGRect avatarImageViewFrame;
@property (nonatomic, assign) CGRect containerViewFrame;
@property (nonatomic, assign) CGRect nicknameLabelFrame;
@property (nonatomic, assign) CGRect followButtonFrame;
@property (nonatomic, assign) CGRect messageTextViewFrame;
@property (nonatomic, assign) CGRect dateLabelFrame;
@property (nonatomic, assign) CGRect likeButtonFrame;
@property (nonatomic, assign) CGRect commentButtonFrame;


- (instancetype)initWithAvatarImageViewFrame:(CGRect)anAvatarImageViewFrame
                          containerViewFrame:(CGRect)aContainerViewFrame
                          nicknameLabelFrame:(CGRect)aNicknameLabelFrame
                           followButtonFrame:(CGRect)aFollowButtonFrame
                        messageTextViewFrame:(CGRect)aMessageTextViewFrame
                              dateLabelFrame:(CGRect)aDateLabelFrame
                             likeButtonFrame:(CGRect)aLikeButtonFrame
                          commentButtonFrame:(CGRect)aCommentButtonFrame;

@end

@class YWDynamicModel;

@interface XPMoodCellLayout : NSObject

@property (nonatomic, strong) XPMoodCellBasicLayout *basicLayout;
@property (nonatomic, strong) XPMoodCellBiggerLayout *biggerImageViewLayout;
@property (nonatomic, strong) XPMoodCellTwoLayout *twoImageViewLayout;
@property (nonatomic, strong) XPMoodCellThreeLayout *threeImageViewLayout;
@property (nonatomic, strong) XPMoodCellFourLayout *fourImageViewLayout;
@property (nonatomic, strong) XPMoodCellFiveLayout *fiveImageViewLayout;
@property (nonatomic, strong) XPMoodCellSixLayout *sixImageViewLayout;
@property (nonatomic, strong) XPMoodCellSevenLayout *sevenImageViewLayout;
@property (nonatomic, strong) XPMoodCellEightLayout *eightImageViewLayout;
@property (nonatomic, strong) XPMoodCellNineLayout *nineImageViewLayout;

- (instancetype)initWithDynamicModel:(YWDynamicModel *)model;

@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
