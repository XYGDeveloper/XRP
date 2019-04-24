//
//  XPVotesTableViewCell.h
//  YJOTC
//
//  Created by l on 2019/1/5.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYStepper.h"

@interface XPVotesTableViewCell : UITableViewCell

@property (nonatomic,strong)HYStepper *stepper;
@property (nonatomic,strong)UILabel *desLabel;

@end
