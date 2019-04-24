//
//  XPCommunityTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/24.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPCommunityIndexModel;

@interface XPCommunityTableViewCell : UITableViewCell

- (void)refreshWithModel:(XPCommunityIndexModel *)model;

@end

