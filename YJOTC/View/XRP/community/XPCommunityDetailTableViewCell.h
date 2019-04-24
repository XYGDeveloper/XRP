//
//  XPCommunityDetailTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPCommunityDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagIcon;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@end

NS_ASSUME_NONNULL_END
