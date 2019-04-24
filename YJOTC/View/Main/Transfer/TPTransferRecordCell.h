//
//  TPTransferRecordCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPTransferRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *receiveAccountLabel;

@property (weak, nonatomic) IBOutlet UILabel *beforeVolumeLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sendIDLabel;

@property (weak, nonatomic) IBOutlet UILabel *receiveIDLabel;

@property(nonatomic,strong)NSDictionary *dateDic;



@end

NS_ASSUME_NONNULL_END
