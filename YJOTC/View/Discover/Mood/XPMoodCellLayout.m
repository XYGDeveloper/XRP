//
//  XPMoodCellLayout.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMoodCellLayout.h"
#import "YWDynamicModel.h"
#import "NSString+XPR.h"

@implementation XPMoodCellBiggerLayout

@end

@implementation XPMoodCellTwoLayout

@end

@implementation XPMoodCellThreeLayout

@end

@implementation XPMoodCellFourLayout

@end

@implementation XPMoodCellFiveLayout

@end

@implementation XPMoodCellSixLayout

@end

@implementation XPMoodCellSevenLayout

@end

@implementation XPMoodCellEightLayout

@end

@implementation XPMoodCellNineLayout

@end


@implementation XPMoodCellBasicLayout

#pragma mark - Lifecycle

- (instancetype)initWithAvatarImageViewFrame:(CGRect)anAvatarImageViewFrame
                          containerViewFrame:(CGRect)aContainerViewFrame
                          nicknameLabelFrame:(CGRect)aNicknameLabelFrame
                           followButtonFrame:(CGRect)aFollowButtonFrame
                        messageTextViewFrame:(CGRect)aMessageTextViewFrame
                              dateLabelFrame:(CGRect)aDateLabelFrame
                             likeButtonFrame:(CGRect)aLikeButtonFrame
                          commentButtonFrame:(CGRect)aCommentButtonFrame {
    self = [super init];
    if (self) {
        self.avatarImageViewFrame = anAvatarImageViewFrame;
        self.containerViewFrame = aContainerViewFrame;
        self.nicknameLabelFrame = aNicknameLabelFrame;
        self.followButtonFrame = aFollowButtonFrame;
        self.messageTextViewFrame = aMessageTextViewFrame;
        self.dateLabelFrame = aDateLabelFrame;
        self.likeButtonFrame = aLikeButtonFrame;
        self.commentButtonFrame = aCommentButtonFrame;
    }
    return self;
}

@end



@implementation XPMoodCellLayout

#pragma mark - Lifecycle

- (instancetype)initWithDynamicModel:(YWDynamicModel *)model {
    self = [super init];
    if (self) {
        
        CGFloat containerViewWidth = kScreenW - (13 + 13);
        CGRect avatarImageViewFrame = CGRectMake(10., 15., 48., 48.);
        CGRect nicknameLabelFrame = CGRectMake(65., 18., containerViewWidth - 65. - 60. - 4., 20.);
        CGRect followButtonFrame = CGRectMake(CGRectGetMaxX(nicknameLabelFrame) + 4., 15., 50., 20.);
        CGFloat messageTextViewWidth = containerViewWidth - 65. - 19.;
        CGFloat messageTextViewHeight = [model.content getTextHeightWithFont:[UIFont systemFontOfSize:12.] width:messageTextViewWidth];
        CGRect messageTextViewFrame = CGRectMake(CGRectGetMinX(nicknameLabelFrame), CGRectGetMaxY(nicknameLabelFrame) + 8., messageTextViewWidth, messageTextViewHeight);
        
        CGFloat maxContentHeight = MAX(CGRectGetMaxY(avatarImageViewFrame), CGRectGetMaxY(messageTextViewFrame));
        CGFloat halfOfcontainerViewWidth = (containerViewWidth - 22. - 8) / 2.;
        
        [self _calculateImageFramesByNumberOfImages:model.attachments.count y:maxContentHeight containerWidth:containerViewWidth];
        CGFloat imageTotalHeight = [self _getImageTotalHeightByNumberOfImages:model.attachments.count];
        
        CGRect dateLabelFrame = CGRectMake(11., maxContentHeight + 20. + imageTotalHeight, halfOfcontainerViewWidth, 17.);
        CGRect likeButtonFrame = CGRectMake(CGRectGetMaxX(dateLabelFrame) + 8., CGRectGetMinY(dateLabelFrame), (halfOfcontainerViewWidth - 4) / 2., 17.);
        CGRect commentButtonFrame = CGRectMake(CGRectGetMaxX(likeButtonFrame) + 4., CGRectGetMinY(dateLabelFrame), (halfOfcontainerViewWidth - 4) / 2., 17.);
        CGRect containerViewFrame = CGRectMake(13., 0., containerViewWidth, CGRectGetMaxY(dateLabelFrame) + 20.);
        
        
        self.height = ceil(CGRectGetMaxY(containerViewFrame) + 15.);
        
        self.basicLayout = [[XPMoodCellBasicLayout alloc] initWithAvatarImageViewFrame:avatarImageViewFrame
                                                                    containerViewFrame:containerViewFrame
                                                                    nicknameLabelFrame:nicknameLabelFrame
                                                                     followButtonFrame:followButtonFrame
                                                                  messageTextViewFrame:messageTextViewFrame
                                                                        dateLabelFrame:dateLabelFrame
                                                                       likeButtonFrame:likeButtonFrame
                                                                    commentButtonFrame:commentButtonFrame];
    }
    return self;
}

#pragma mark - Private

- (void)_calculateImageFramesByNumberOfImages:(NSInteger)numberOfImages y:(CGFloat)y containerWidth:(CGFloat)containerWidth {
    
    CGFloat availableWidth = containerWidth - 10. * 2;
    switch (numberOfImages) {
            
        case 1: {
            self.biggerImageViewLayout = [XPMoodCellBiggerLayout new];
            self.biggerImageViewLayout.biggerImageViewFrame = CGRectMake(10., y + 10., availableWidth, 210. * kScreenWidthRatio);
            
            break;
        }
            
        case 2: {
            self.twoImageViewLayout = [XPMoodCellTwoLayout new];
            CGFloat width = (availableWidth - 10.) / 2.;
            CGRect imageView1Frame = CGRectMake(10., y + 10., width, 210. * kScreenWidthRatio);
            CGRect imageView2Frame = CGRectMake(CGRectGetMaxX(imageView1Frame) + 10., y + 10., width, 210. * kScreenWidthRatio);
            
            self.twoImageViewLayout.imageView1Frame = imageView1Frame;
            self.twoImageViewLayout.imageView2Frame = imageView2Frame;
            break;
        }
            
        case 3: {
            self.threeImageViewLayout = [XPMoodCellThreeLayout new];
            CGFloat width = (availableWidth - 10.) / 2.;
            CGRect imageView1Frame = CGRectMake(10., y + 10., width, 210. * kScreenWidthRatio);
            CGRect imageView2Frame = CGRectMake(CGRectGetMaxX(imageView1Frame) + 10., y + 10., width, 100 * kScreenWidthRatio);
            CGRect imageView3Frame = CGRectMake(CGRectGetMaxX(imageView1Frame) + 10., CGRectGetMaxY(imageView2Frame) + 10., width, 100 * kScreenWidthRatio);
            
            self.threeImageViewLayout.imageView1Frame = imageView1Frame;
            self.threeImageViewLayout.imageView2Frame = imageView2Frame;
            self.threeImageViewLayout.imageView3Frame = imageView3Frame;
            
            break;
        }
            
        case 4: {
            self.fourImageViewLayout = [XPMoodCellFourLayout new];
            CGFloat width = (availableWidth - 10.) / 2.;
            CGRect imageView1Frame = CGRectMake(10., y + 10., width, 110. * kScreenWidthRatio);
            CGRect imageView2Frame = CGRectMake(CGRectGetMaxX(imageView1Frame) + 10., y + 10., width, 110 * kScreenWidthRatio);
            CGRect imageView3Frame = CGRectMake(10., CGRectGetMaxY(imageView2Frame) + 10., width, 110 * kScreenWidthRatio);
            CGRect imageView4Frame = CGRectMake(CGRectGetMaxX(imageView1Frame) + 10., CGRectGetMaxY(imageView2Frame) + 10., width, 110 * kScreenWidthRatio);
            
            self.fourImageViewLayout.imageView1Frame = imageView1Frame;
            self.fourImageViewLayout.imageView2Frame = imageView2Frame;
            self.fourImageViewLayout.imageView3Frame = imageView3Frame;
            self.fourImageViewLayout.imageView4Frame = imageView4Frame;
            
            break;
        }
            
        case 5: {
            self.fiveImageViewLayout = [XPMoodCellFiveLayout new];
            CGFloat widthOfTwo = (availableWidth - 10.) / 2.;
            CGRect imageView1Frame = CGRectMake(10., y + 10., widthOfTwo, 110. * kScreenWidthRatio);
            CGRect imageView2Frame = CGRectMake(CGRectGetMaxX(imageView1Frame) + 10., y + 10., widthOfTwo, 110 * kScreenWidthRatio);
            
            
            CGFloat widthOfThree = (availableWidth - 10. - 10.) / 3.;
            CGRect imageView3Frame = CGRectMake(10., CGRectGetMaxY(imageView2Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView4Frame = CGRectMake(CGRectGetMaxX(imageView3Frame) + 10., CGRectGetMaxY(imageView1Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            
            CGRect imageView5Frame = CGRectMake(CGRectGetMaxX(imageView4Frame) + 10., CGRectGetMaxY(imageView1Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            
            self.fiveImageViewLayout.imageView1Frame = imageView1Frame;
            self.fiveImageViewLayout.imageView2Frame = imageView2Frame;
            self.fiveImageViewLayout.imageView3Frame = imageView3Frame;
            self.fiveImageViewLayout.imageView4Frame = imageView4Frame;
            self.fiveImageViewLayout.imageView5Frame = imageView5Frame;
            
            break;
        }
            
        case 6: {
            self.sixImageViewLayout = [XPMoodCellSixLayout new];
            CGFloat widthOfThree = (availableWidth - 10. - 10.) / 3.;
            CGRect imageView1Frame = CGRectMake(10., y + 10., widthOfThree, 110. * kScreenWidthRatio);
            CGRect imageView2Frame = CGRectMake(CGRectGetMaxX(imageView1Frame) + 10., y + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView3Frame = CGRectMake(CGRectGetMaxX(imageView2Frame) + 10., y + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView4Frame = CGRectMake(10., CGRectGetMaxY(imageView1Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView5Frame = CGRectMake(CGRectGetMaxX(imageView4Frame) + 10., CGRectGetMaxY(imageView1Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView6Frame = CGRectMake(CGRectGetMaxX(imageView5Frame) + 10., CGRectGetMaxY(imageView1Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            
            self.sixImageViewLayout.imageView1Frame = imageView1Frame;
            self.sixImageViewLayout.imageView2Frame = imageView2Frame;
            self.sixImageViewLayout.imageView3Frame = imageView3Frame;
            self.sixImageViewLayout.imageView4Frame = imageView4Frame;
            self.sixImageViewLayout.imageView5Frame = imageView5Frame;
            self.sixImageViewLayout.imageView6Frame = imageView6Frame;
            
            break;
        }
            
        case 7: {
            self.sevenImageViewLayout = [XPMoodCellSevenLayout new];
            CGFloat widthOfTwo = (availableWidth - 10.) / 2.;
            CGRect imageView1Frame = CGRectMake(10., y + 10., widthOfTwo, 110. * kScreenWidthRatio);
            CGRect imageView2Frame = CGRectMake(CGRectGetMaxX(imageView1Frame) + 10., y + 10., widthOfTwo, 110 * kScreenWidthRatio);
    
            CGRect imageView3Frame = CGRectMake(10., CGRectGetMaxY(imageView1Frame) + 10., widthOfTwo, 110 * kScreenWidthRatio);
            CGRect imageView4Frame = CGRectMake(CGRectGetMaxX(imageView3Frame) + 10., CGRectGetMaxY(imageView1Frame) + 10., widthOfTwo, 110 * kScreenWidthRatio);
            
            CGFloat widthOfThree = (availableWidth - 10. - 10.) / 3.;
            CGRect imageView5Frame = CGRectMake(10., CGRectGetMaxY(imageView4Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView6Frame = CGRectMake(CGRectGetMaxX(imageView5Frame) + 10., CGRectGetMaxY(imageView4Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView7Frame = CGRectMake(CGRectGetMaxX(imageView6Frame) + 10., CGRectGetMaxY(imageView4Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            
            self.sevenImageViewLayout.imageView1Frame = imageView1Frame;
            self.sevenImageViewLayout.imageView2Frame = imageView2Frame;
            self.sevenImageViewLayout.imageView3Frame = imageView3Frame;
            self.sevenImageViewLayout.imageView4Frame = imageView4Frame;
            self.sevenImageViewLayout.imageView5Frame = imageView5Frame;
            self.sevenImageViewLayout.imageView6Frame = imageView6Frame;
            self.sevenImageViewLayout.imageView7Frame = imageView7Frame;
            
            break;
        }
            
        case 8: {
            self.eightImageViewLayout = [XPMoodCellEightLayout new];
            CGFloat widthOfThree = (availableWidth - 10. - 10.) / 3.;
            CGRect imageView1Frame = CGRectMake(10., y + 10., widthOfThree, 110. * kScreenWidthRatio);
            CGRect imageView2Frame = CGRectMake(CGRectGetMaxX(imageView1Frame) + 10., y + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView3Frame = CGRectMake(CGRectGetMaxX(imageView2Frame) + 10., y + 10., widthOfThree, 110 * kScreenWidthRatio);
            
            CGFloat widthOfTwo = (availableWidth - 10.) / 2.;
            CGRect imageView4Frame = CGRectMake(10., CGRectGetMaxY(imageView1Frame) + 10., widthOfTwo, 110 * kScreenWidthRatio);
            CGRect imageView5Frame = CGRectMake(CGRectGetMaxX(imageView4Frame) + 10., CGRectGetMaxY(imageView1Frame) + 10., widthOfTwo, 110 * kScreenWidthRatio);
            
            CGRect imageView6Frame = CGRectMake(10., CGRectGetMaxY(imageView4Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView7Frame = CGRectMake(CGRectGetMaxX(imageView6Frame) + 10., CGRectGetMaxY(imageView4Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView8Frame = CGRectMake(CGRectGetMaxX(imageView7Frame) + 10., CGRectGetMaxY(imageView4Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            
            self.eightImageViewLayout.imageView1Frame = imageView1Frame;
            self.eightImageViewLayout.imageView2Frame = imageView2Frame;
            self.eightImageViewLayout.imageView3Frame = imageView3Frame;
            self.eightImageViewLayout.imageView4Frame = imageView4Frame;
            self.eightImageViewLayout.imageView5Frame = imageView5Frame;
            self.eightImageViewLayout.imageView6Frame = imageView6Frame;
            self.eightImageViewLayout.imageView7Frame = imageView7Frame;
            self.eightImageViewLayout.imageView8Frame = imageView8Frame;
            
            break;
        }
            
        case 9: {
            self.nineImageViewLayout = [XPMoodCellNineLayout new];
            CGFloat widthOfThree = (availableWidth - 10. - 10.) / 3.;
            CGRect imageView1Frame = CGRectMake(10., y + 10., widthOfThree, 110. * kScreenWidthRatio);
            CGRect imageView2Frame = CGRectMake(CGRectGetMaxX(imageView1Frame) + 10., y + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView3Frame = CGRectMake(CGRectGetMaxX(imageView2Frame) + 10., y + 10., widthOfThree, 110 * kScreenWidthRatio);
            
            CGRect imageView4Frame = CGRectMake(10., CGRectGetMaxY(imageView1Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView5Frame = CGRectMake(CGRectGetMaxX(imageView4Frame) + 10., CGRectGetMaxY(imageView1Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView6Frame = CGRectMake(CGRectGetMaxX(imageView5Frame) + 10., CGRectGetMaxY(imageView1Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            
            CGRect imageView7Frame = CGRectMake(10., CGRectGetMaxY(imageView4Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView8Frame = CGRectMake(CGRectGetMaxX(imageView7Frame) + 10., CGRectGetMaxY(imageView4Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            CGRect imageView9Frame = CGRectMake(CGRectGetMaxX(imageView8Frame) + 10., CGRectGetMaxY(imageView4Frame) + 10., widthOfThree, 110 * kScreenWidthRatio);
            
            self.nineImageViewLayout.imageView1Frame = imageView1Frame;
            self.nineImageViewLayout.imageView2Frame = imageView2Frame;
            self.nineImageViewLayout.imageView3Frame = imageView3Frame;
            self.nineImageViewLayout.imageView4Frame = imageView4Frame;
            self.nineImageViewLayout.imageView5Frame = imageView5Frame;
            self.nineImageViewLayout.imageView6Frame = imageView6Frame;
            self.nineImageViewLayout.imageView7Frame = imageView7Frame;
            self.nineImageViewLayout.imageView8Frame = imageView8Frame;
            self.nineImageViewLayout.imageView9Frame = imageView9Frame;
            
            break;
        }
            
        default:
            
            break;
    }
}

- (CGFloat)_getImageTotalHeightByNumberOfImages:(NSInteger)numberOfImages {
    CGFloat imageTotalHeight = 0;
    
    switch (numberOfImages) {
            
        case 1:
        case 2:
        case 3: {
            imageTotalHeight = 210. * kScreenWidthRatio + 10.;
            break;
        }
            
        case 4:
        case 5:
        case 6: {
            imageTotalHeight = 110 * kScreenWidthRatio + 10 + 110 * kScreenWidthRatio + 10.;
            break;
        }
            
        case 7:
        case 8:
        case 9: {
            imageTotalHeight = 110 * kScreenWidthRatio + 10 + 110 * kScreenWidthRatio + 10 + 110 * kScreenWidthRatio + 10.;
            break;
        }
            
        default:
            imageTotalHeight = 0;
            break;
    }
    return imageTotalHeight;
}

@end
