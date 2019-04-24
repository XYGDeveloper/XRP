//
//  XPCollectionHeaderReusableView.h
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
@class outterModel;

@interface XPCollectionHeaderReusableView : UICollectionReusableView

- (void)refreshWithModel:(outterModel *)model;

@end
