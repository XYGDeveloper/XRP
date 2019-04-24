//
//  TPWalletSendMidCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPWalletSendMidCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIButton *addressButton;

@property (weak, nonatomic) IBOutlet UITextField *addTF;

@property (weak, nonatomic) IBOutlet UITextField *tagTF;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property(nonatomic,assign)BOOL isXRP;
@property(nonatomic,assign)BOOL isEOS;

@property (weak, nonatomic) IBOutlet UITextField *xrpTF;
@property (weak, nonatomic) IBOutlet UILabel *xrpLine;


@end
