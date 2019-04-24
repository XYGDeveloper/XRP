//
//  XPBossActivityCancelCell.h
//  YJOTC
//
//  Created by 周勇 on 2019/1/11.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface XPBossActivityCancelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property(nonatomic,strong)NSDictionary *dataDic;


@end


