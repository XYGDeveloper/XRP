//
//  XPSearchHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPSearchHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accounterLabel;
@property (weak, nonatomic) IBOutlet UITextField *accounterContent;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UITextField *idContent;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@end

NS_ASSUME_NONNULL_END
