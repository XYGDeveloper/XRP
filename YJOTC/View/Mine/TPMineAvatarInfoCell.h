//
//  TPMineAvatarInfoCell.h
//  YJOTC
//
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPMineAvatarInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *modButton;


@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *dismissButton;


@end
