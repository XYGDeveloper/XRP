//
//  ConfirmInputView.h
//  YJOTC
//
//  Created by l on 2019/1/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConfirmBlcok) (UIButton *sureButton);

@interface ConfirmInputView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *kkLabel;
@property (weak, nonatomic) IBOutlet UITextField *kkTextfield;
@property (weak, nonatomic) IBOutlet UILabel *rbKKLabel;
@property (weak, nonatomic) IBOutlet UILabel *rbkkContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;




@property(nonatomic,copy)ConfirmBlcok callBackBlock;

@end
