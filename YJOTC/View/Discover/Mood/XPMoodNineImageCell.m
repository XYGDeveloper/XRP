//
//  XPMoodNineImageCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMoodNineImageCell.h"
#import "XPMoodCellLayout.h"
#import "UIView+RoundCorner.h"

@interface XPMoodNineImageCell ()

@property (nonatomic, strong) UIImageView *oneImageView;
@property (nonatomic, strong) UIImageView *twoImageView;
@property (nonatomic, strong) UIImageView *threeImageView;
@property (nonatomic, strong) UIImageView *fourImageView;
@property (nonatomic, strong) UIImageView *fiveImageView;
@property (nonatomic, strong) UIImageView *sixImageView;
@property (nonatomic, strong) UIImageView *sevenImageView;
@property (nonatomic, strong) UIImageView *eightImageView;
@property (nonatomic, strong) UIImageView *nineImageView;

@property (nonatomic, strong) NSArray<UIImageView *> *imageViews;

@end

@implementation XPMoodNineImageCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _oneImageView = [self createImageView];
        _twoImageView = [self createImageView];
        _threeImageView = [self createImageView];
        _fourImageView = [self createImageView];
        _fiveImageView = [self createImageView];
        _sixImageView = [self createImageView];
        _sevenImageView = [self createImageView];
        _eightImageView = [self createImageView];
        _nineImageView = [self createImageView];
        
        [self.containerView addSubview:_oneImageView];
        [self.containerView addSubview:_twoImageView];
        [self.containerView addSubview:_threeImageView];
        [self.containerView addSubview:_fourImageView];
        [self.containerView addSubview:_fiveImageView];
        [self.containerView addSubview:_sixImageView];
        [self.containerView addSubview:_sevenImageView];
        [self.containerView addSubview:_eightImageView];
        [self.containerView addSubview:_nineImageView];
        
        self.imageViews = @[_oneImageView, _twoImageView, _threeImageView, _fourImageView, _fiveImageView, _sixImageView, _sevenImageView, _eightImageView, _nineImageView];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.image = nil;
        obj.layer.mask = nil;
    }];
}

#pragma mark - Public

- (void)configureCellWithModel:(YWDynamicModel *)model layout:(XPMoodCellLayout *)layout {
    [super configureCellWithModel:model layout:layout];
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < model.attachments.count) {
            NSString *URLString = model.attachments[idx];
            [obj setImageURL:[NSURL URLWithString:URLString]];
        }
    }];
    
    [self hideImagesOfNeedHideByNumberOfImages:model.numberOfImages];
    
    switch (model.numberOfImages) {
        case 1: {
            [self layoutBiggerImagesWithLayout:layout.biggerImageViewLayout];
            break;
        }
        case 2: {
            [self layoutTwoImagesWithLayout:layout.twoImageViewLayout];
            break;
        }
        case 3: {
            [self layoutThreeImagesWithLayout:layout.threeImageViewLayout];
            break;
        }
        case 4: {
            [self layoutFourImagesWithLayout:layout.fourImageViewLayout];
            break;
        }
        case 5: {
            [self layoutFiveImagesWithLayout:layout.fiveImageViewLayout];
            break;
        }
        case 6: {
            [self layoutSixImagesWithLayout:layout.sixImageViewLayout];
            break;
        }
        case 7: {
            [self layoutSevenImagesWithLayout:layout.sevenImageViewLayout];
            break;
        }
            
        case 8: {
            [self layoutEightImagesWithLayout:layout.eightImageViewLayout];
            break;
        }
        
        case 9: {
            [self layoutNineImagesWithLayout:layout.nineImageViewLayout];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private

- (void)hideImagesOfNeedHideByNumberOfImages:(NSInteger)numberOfImages {
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = NO;
    }];
    
    NSArray<UIImageView *> *imagesOfNeedHide = [self.imageViews subarrayWithRange:NSMakeRange(numberOfImages, 9 - numberOfImages)];
    [imagesOfNeedHide enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
}

- (void)layoutNineImagesWithLayout:(XPMoodCellNineLayout *)layout {
    self.oneImageView.frame = layout.imageView1Frame;
    self.twoImageView.frame = layout.imageView2Frame;
    self.threeImageView.frame = layout.imageView3Frame;
    self.fourImageView.frame = layout.imageView4Frame;
    self.fiveImageView.frame = layout.imageView5Frame;
    self.sixImageView.frame = layout.imageView6Frame;
    self.sevenImageView.frame = layout.imageView7Frame;
    self.eightImageView.frame = layout.imageView8Frame;
    self.nineImageView.frame = layout.imageView9Frame;
    
    [self.oneImageView roundLeftCornersRadius:8.];
    [self.fourImageView roundLeftCornersRadius:8.];
    [self.sevenImageView roundLeftCornersRadius:8.];
    
    [self.threeImageView roundRightCornersRadius:8.];
    [self.sixImageView roundRightCornersRadius:8.];
    [self.nineImageView roundRightCornersRadius:8.];
}

- (void)layoutEightImagesWithLayout:(XPMoodCellEightLayout *)layout {
    self.oneImageView.frame = layout.imageView1Frame;
    self.twoImageView.frame = layout.imageView2Frame;
    self.threeImageView.frame = layout.imageView3Frame;
    self.fourImageView.frame = layout.imageView4Frame;
    self.fiveImageView.frame = layout.imageView5Frame;
    self.sixImageView.frame = layout.imageView6Frame;
    self.sevenImageView.frame = layout.imageView7Frame;
    self.eightImageView.frame = layout.imageView8Frame;
    
    [self.oneImageView roundLeftCornersRadius:8.];
    [self.fourImageView roundLeftCornersRadius:8.];
    [self.sixImageView roundLeftCornersRadius:8.];
    
    [self.threeImageView roundRightCornersRadius:8.];
    [self.fiveImageView roundRightCornersRadius:8.];
    [self.eightImageView roundRightCornersRadius:8.];
}

- (void)layoutSevenImagesWithLayout:(XPMoodCellSevenLayout *)layout {
    self.oneImageView.frame = layout.imageView1Frame;
    self.twoImageView.frame = layout.imageView2Frame;
    self.threeImageView.frame = layout.imageView3Frame;
    self.fourImageView.frame = layout.imageView4Frame;
    self.fiveImageView.frame = layout.imageView5Frame;
    self.sixImageView.frame = layout.imageView6Frame;
    self.sevenImageView.frame = layout.imageView7Frame;
    
    [self.oneImageView roundLeftCornersRadius:8.];
    [self.threeImageView roundLeftCornersRadius:8.];
    [self.fiveImageView roundLeftCornersRadius:8.];
    
    [self.twoImageView roundRightCornersRadius:8.];
    [self.fourImageView roundRightCornersRadius:8.];
    [self.sevenImageView roundRightCornersRadius:8.];
}

- (void)layoutSixImagesWithLayout:(XPMoodCellSixLayout *)layout {
    self.oneImageView.frame = layout.imageView1Frame;
    self.twoImageView.frame = layout.imageView2Frame;
    self.threeImageView.frame = layout.imageView3Frame;
    self.fourImageView.frame = layout.imageView4Frame;
    self.fiveImageView.frame = layout.imageView5Frame;
    self.sixImageView.frame = layout.imageView6Frame;
    
    [self.oneImageView roundLeftCornersRadius:8.];
    [self.fourImageView roundLeftCornersRadius:8.];
    
    [self.threeImageView roundRightCornersRadius:8.];
    [self.sixImageView roundRightCornersRadius:8.];
}

- (void)layoutFiveImagesWithLayout:(XPMoodCellFiveLayout *)layout {
    self.oneImageView.frame = layout.imageView1Frame;
    self.twoImageView.frame = layout.imageView2Frame;
    self.threeImageView.frame = layout.imageView3Frame;
    self.fourImageView.frame = layout.imageView4Frame;
    self.fiveImageView.frame = layout.imageView5Frame;
    
    [self.oneImageView roundLeftCornersRadius:8.];
    [self.threeImageView roundLeftCornersRadius:8.];
    [self.twoImageView roundRightCornersRadius:8.];
    [self.fiveImageView roundRightCornersRadius:8.];
}

- (void)layoutFourImagesWithLayout:(XPMoodCellFourLayout *)layout {
    self.oneImageView.frame = layout.imageView1Frame;
    self.twoImageView.frame = layout.imageView2Frame;
    self.threeImageView.frame = layout.imageView3Frame;
    self.fourImageView.frame = layout.imageView4Frame;
    
    [self.oneImageView roundLeftCornersRadius:8.];
    [self.threeImageView roundLeftCornersRadius:8.];
    [self.twoImageView roundRightCornersRadius:8.];
    [self.fourImageView roundRightCornersRadius:8.];
}

- (void)layoutThreeImagesWithLayout:(XPMoodCellThreeLayout *)layout {
    self.oneImageView.frame = layout.imageView1Frame;
    self.twoImageView.frame = layout.imageView2Frame;
    self.threeImageView.frame = layout.imageView3Frame;
    
    [self.oneImageView roundLeftCornersRadius:8.];
    [self.twoImageView roundRightCornersRadius:8.];
    [self.threeImageView roundRightCornersRadius:8.];
}


- (void)layoutTwoImagesWithLayout:(XPMoodCellTwoLayout *)layout {
    self.oneImageView.frame = layout.imageView1Frame;
    self.twoImageView.frame = layout.imageView2Frame;
    
    [self.oneImageView roundLeftCornersRadius:8.];
    [self.twoImageView roundRightCornersRadius:8.];
}

- (void)layoutBiggerImagesWithLayout:(XPMoodCellBiggerLayout *)layout {
    self.oneImageView.frame = layout.biggerImageViewFrame;
    [self.oneImageView roundCorners:UIRectCornerAllCorners radius:8.];
}

- (UIImageView *)createImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = kColorFromStr(@"F4F4F4");
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
    [imageView addGestureRecognizer:tapGestureRecognizer];
    
    return imageView;
}

#pragma mark - Actions

- (void)tapImageAction:(UITapGestureRecognizer *)gestureRecognizer {
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    NSInteger index = [self.imageViews indexOfObject:imageView];
    if ([self.imageCellDelegate respondsToSelector:@selector(moodImageCell:index:image:attachments:)]) {
        [self.imageCellDelegate moodImageCell:self index:index image:imageView.image attachments:self.model.attachments];
    }
}

@end
