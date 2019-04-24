//
//  TPWalletSendToBCBController.m
//  YJOTC
//
//  Created by Roy on 2018/12/6.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletSendToBCBController.h"
#import "TPWalletSendKeyboardView.h"

@interface TPWalletSendToBCBController ()
//<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TPWalletSendKeyboardViewDelegate,NTESVerifyCodeManagerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,copy)NSString *verifyStr;


@property (weak, nonatomic) IBOutlet UIButton *bottomButton;


@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *xlxq;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *title1Label;

@property (weak, nonatomic) IBOutlet UILabel *title2Label;

@property (weak, nonatomic) IBOutlet UITextField *currencyTF;
@property (weak, nonatomic) IBOutlet UITextField *volumeTF;

@property (weak, nonatomic) IBOutlet UILabel *aviLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;



@end

@implementation TPWalletSendToBCBController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)setupUI
{
    self.navigationItem.title = @"轉到信鏈星球";
    
    _xlxq.textColor = k222222Color;
    _xlxq.font = PFRegularFont(16);
    
    _accountLabel.font = PFRegularFont(14);
    _accountLabel.textColor = k222222Color;
    
    _title1Label.textColor = k666666Color;
    _title1Label.font =PFRegularFont(16);
    _title2Label.textColor = k666666Color;
    _title2Label.font =PFRegularFont(16);
    
    _aviLabel.textColor = k999999Color;
    _aviLabel.font = PFRegularFont(12);
    
    _tipsLabel.textColor = kColorFromStr(@"#E1545A");
    _tipsLabel.font = PFRegularFont(12);
    
    _bottomButton.titleLabel.font = PFRegularFont(16);
    kViewBorderRadius(_bottomButton, 8, 0, kRedColor);
    
    [_bottomButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#6189C5")] forState:UIControlStateNormal];
    [_bottomButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#93A3B6")] forState:UIControlStateDisabled];
    [_bottomButton setTitleColor:kColorFromStr(@"#C0CFE0") forState:UIControlStateDisabled];
    [_bottomButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _bottomButton.enabled = NO;
    [_bottomButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];

    return;
    
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    _tableView.backgroundColor = kTableColor;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletVolumeCell" bundle:nil] forCellReuseIdentifier:@"TPWalletVolumeCell"];
    UIView *footerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 84 + 45)];
    footerView.backgroundColor = kWhiteColor;
    _tableView.tableFooterView = footerView;
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:kRectMake(12, 70, kScreenW - 24, 45) title:@"發送" titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [footerView addSubview:sendButton];
    [sendButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#6189C5")] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#93A3B6")] forState:UIControlStateDisabled];
    [sendButton setTitleColor:kColorFromStr(@"#C0CFE0") forState:UIControlStateDisabled];
    [sendButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sendButton.enabled = NO;
    
    _bottomButton = sendButton;
    kViewBorderRadius(sendButton,8, 0, kRedColor);
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UITextView *tv = [[UITextView alloc] initWithFrame:kRectMake(12, 0, kScreenW - 24, 55)];
    tv.textColor = kColorFromStr(@"#E1545A");
    tv.font = PFRegularFont(12);
//    tv.text = [NSString stringWithFormat:@"*請確認您正在發送到壹個%@地址，發送到其他類型的地址將會造成資產永久丟失",_model.currency_name];
    [footerView addSubview:tv];
    tv.backgroundColor = kClearColor;
    tv.userInteractionEnabled = NO;
}


@end
