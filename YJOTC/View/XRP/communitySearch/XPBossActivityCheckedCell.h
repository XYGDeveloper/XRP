//
//  XPBossActivityCheckedCell.h
//  YJOTC
//
//  Created by 周勇 on 2019/1/11.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPBossActivityCheckedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;


@property (weak, nonatomic) IBOutlet UILabel *votesLabel;


@property (weak, nonatomic) IBOutlet UILabel *checkAccoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkerLabe;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
/**  激活记录dic  */
@property(nonatomic,strong)NSDictionary *dataDic;

/**  我的社员共用此cell  */
@property(nonatomic,assign)BOOL isMyMember;
/**  我的社员dic  */
@property(nonatomic,strong)NSDictionary *memberDic;



@end

NS_ASSUME_NONNULL_END
