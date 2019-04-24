//
//  XPAccountSetPwdCell.h
//  YJOTC
//
//  Created by Roy on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XPAccountSetPwdCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UITextField *TF;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomC;

@property(nonatomic,assign)BOOL showCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;


@end



