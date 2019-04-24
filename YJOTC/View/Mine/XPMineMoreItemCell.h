//
//  XPMineMoreItemCell.h
//  YJOTC
//
//  Created by Roy on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface XPMineMoreItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet YLButton *button0;

@property (weak, nonatomic) IBOutlet YLButton *button1;
@property (weak, nonatomic) IBOutlet YLButton *button2;
@property (weak, nonatomic) IBOutlet YLButton *button3;

-(void)configureItemInfoWithTitleArray:(NSArray *)titles icons:(NSArray *)icons;

@end


