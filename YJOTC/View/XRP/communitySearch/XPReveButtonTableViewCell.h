//
//  XPReveButtonTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^tosure)(void);
typedef void (^toreset)(void);
typedef void (^toself)(void);

@interface XPReveButtonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *sedButton;
@property (weak, nonatomic) IBOutlet UIButton *seButton;
@property (nonatomic,strong)tosure sure;
@property (nonatomic,strong)toreset reset;
@property (nonatomic,strong)toself tose;
@end
