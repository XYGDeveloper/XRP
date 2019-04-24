//
//  XPCommunityZTCollectionViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^toVotes)(void);

@class innerModel;
@interface XPCommunityZTCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *piaoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *piaoContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (nonatomic,strong)toVotes votes;

- (void)refreshWithModel:(innerModel *)model;

- (void)refreshWithVotesModel:(innerModel *)model;


@end

NS_ASSUME_NONNULL_END
