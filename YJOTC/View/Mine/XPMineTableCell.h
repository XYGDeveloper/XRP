//
//  XPMineTableCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class XPMineTableCell;

@protocol XPMineTableCellTapDelegate <NSObject>

-(void)xPMineTableCell:(XPMineTableCell *)cell didTapIndex:(NSInteger)index;

@end

@interface XPMineTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UIImageView *icon3;
@property (weak, nonatomic) IBOutlet UIImageView *icon4;
@property (weak, nonatomic) IBOutlet UIImageView *icon5;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label5;

@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@property (weak, nonatomic) IBOutlet UIButton *button4;

@property (weak, nonatomic) IBOutlet UILabel *line5;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrow5;
-(void)setDataWithIcons:(NSArray *)icons titles:(NSArray *)titles;

@property(nonatomic,weak)id<XPMineTableCellTapDelegate> delegate;


/**  是否包含實名認證  */
@property(nonatomic,assign)BOOL isAuth;


@end

NS_ASSUME_NONNULL_END
