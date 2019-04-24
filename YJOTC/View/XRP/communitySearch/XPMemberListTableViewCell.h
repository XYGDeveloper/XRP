//
//  XPMemberListTableViewCell.h
//  YJOTC
//
//  Created by l on 2019/1/5.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

@class membersModel;

@interface XPMemberListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accounterLabel;


@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgview;

- (void)refreshWithModel:(membersModel *)model;



@end

