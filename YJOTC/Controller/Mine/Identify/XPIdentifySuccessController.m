
//
//  XPIdentifySuccessController.m
//  YJOTC
//
//  Created by 周勇 on 2019/1/11.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPIdentifySuccessController.h"

@interface XPIdentifySuccessController ()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



@end

@implementation XPIdentifySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = kLocat(@"s_shimingrenzheng");
    [self setupUI];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)setupUI
{
    _tipsLabel.text = kLocat(@"s_shimrenzhengtips");
    _titleL.text = kLocat(@"s_yourinfomation");
    _name.text = kLocat(@"k_popview_list_countname");
    _type.text = kLocat(@"s_typeofcard");
    _num.text = kLocat(@"s_cardnumber");
    _time.text = kLocat(@"s_authtime");

    
    _nameLabel.text = kUserInfo.userName;
    if ([_dataDic[@"member"][@"cardtype"] integerValue] == 1) {
        _typeLabel.text = kLocat(@"s_idcard");
    }else if ([_dataDic[@"member"][@"cardtype"] integerValue] == 2){
        _typeLabel.text = kLocat(@"s_passport");
    }else{
        _typeLabel.text = kLocat(@"s_drivinglicence");
    }
    _numLabel.text = _dataDic[@"member"][@"idcard"];
    _timeLabel.text = _dataDic[@"member"][@"verify_time"];
    
    
}

-(void)loadData
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@""] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            
            
        }
    }];
}


@end
