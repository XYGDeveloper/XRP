//
//  TPWalletAccountDetailController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletAccountDetailController.h"

@interface TPWalletAccountDetailController ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *to;

@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;

@property (weak, nonatomic) IBOutlet UILabel *tips;

@property (weak, nonatomic) IBOutlet UITextView *remarkTV;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hashLabel;
@property (weak, nonatomic) IBOutlet UILabel *hashLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagValue;

@end

@implementation TPWalletAccountDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    [self loadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"book_id"] = _dic[@"book_id"];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/AccountBook/info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",[responseObj ksObjectForKey:kData]);
        if (success) {
            NSDictionary *dataDic = [responseObj ksObjectForKey:kData];
            
            NSInteger type = [dataDic[@"type"] integerValue];//0 充币   1提币
            if (type == 0) {
                _toLabel.text = [NSString stringWithFormat:@"%@ %@ %@",kLocat(@"W_My"),_dic[@"from_name"],kLocat(@"W_Wallet")];
                _fromLabel.text = dataDic[@"address"];
//                self.hashLabel.text = @"HXID";
//                self.hashLabelValue.text = @"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
                
                if ([dataDic[@"currency_name"] isEqualToString:@"XRP"]) {
                    _tagLabel.text = kLocat(@"hz_book_wallets");
                    _tagValue.text = [NSString stringWithFormat:@"%d",[dataDic[@"tag"] intValue]];
                }else if ([dataDic[@"currency_name"] isEqualToString:@"EOS"]){
                    _tagLabel.text = @"memo";
                    _tagValue.text = [NSString stringWithFormat:@"%d",[dataDic[@"tag"] intValue]];
                }
                
                
            }else{
                _fromLabel.text = [NSString stringWithFormat:@"%@ %@ %@",kLocat(@"W_My"),_dic[@"from_name"],kLocat(@"W_Wallet")];
                _toLabel.text = dataDic[@"address"];
                self.hashLabel.text = @"TXID";
//                self.hashLabelValue.text = dataDic[@"ti_id"];
                if (isNull(dataDic[@"ti_id"])) {
                    self.hashLabelValue.text = @"";
                }else{
                    self.hashLabelValue.text = dataDic[@"ti_id"];
                }
                
                if ([dataDic[@"currency_name"] isEqualToString:@"XRP"]) {
                    _tagLabel.text = kLocat(@"hz_book_wallets");
                    _tagValue.text = [NSString stringWithFormat:@"%d",[dataDic[@"tag"] intValue]];
                }else if ([dataDic[@"currency_name"] isEqualToString:@"EOS"]){
                    _tagLabel.text = @"memo";
                    _tagValue.text = [NSString stringWithFormat:@"%d",[dataDic[@"tag"] intValue]];
                }
            }
            
            _feeLabel.text = [NSString stringWithFormat:@"%@%@%@",kLocat(@"OTC_post_fee"),dataDic[@"fee"],_dic[@"from_name"]];

            if ([dataDic[@"remarks"] isKindOfClass:[NSNull class]]) {
                _remarkTV.text = @"";
            }else{
                _remarkTV.text = dataDic[@"remarks"];
            }
            
            int status = [dataDic[@"status"] intValue];
            if (status == -1) {
                _statusLabel.text = kLocat(@"W_cancelled");
            }else if (status == 0){
                _statusLabel.text = kLocat(@"W_checking");
                _statusLabel.textColor = kColorFromStr(@"#E06920");
            }else{
                _statusLabel.text = kLocat(@"OTC_order_done");
                _statusLabel.textColor = kNaviColor;
            }
            
        }
    }];
    
    
}

-(void)setupUI
{
    self.title = kLocat(@"W_Detail");
    self.view.backgroundColor = kTableColor;
    _topMargin.constant = kNavigationBarHeight + 25 * kScreenHeightRatio;
    
    _nameLabel.textColor = kLightGrayColor;
    _nameLabel.font = PFRegularFont(16);
    
    _volumeLabel.textColor = kLightGrayColor;
    _volumeLabel.font = PFRegularFont(14);
    //#4C9EE4 已完成     #E06920 審核中
    _statusLabel.textColor = kLightGrayColor;
    _statusLabel.font = PFRegularFont(14);
    
    _to.textColor = kColorFromStr(@"#EA6E44");
    _to.font = PFRegularFont(14);
    
    _from.textColor = kColorFromStr(@"#EA6E44");
    _from.font = PFRegularFont(14);
    
    _toLabel.textColor = kLightGrayColor;
    _toLabel.font = PFRegularFont(14);
    
    _fromLabel.textColor = kLightGrayColor;
    _fromLabel.font = PFRegularFont(14);
    
    _tips.textColor = kLightGrayColor;
    _tips.font = PFRegularFont(16);
    
    _timeLabel.textColor = kLightGrayColor;
    _timeLabel.font = PFRegularFont(14);
    
    _feeLabel.textColor = kLightGrayColor;
    _feeLabel.font = PFRegularFont(14);
    
    _remarkTV.textColor = kLightGrayColor;
    _remarkTV.font = PFRegularFont(12);
    _remarkTV.backgroundColor = kClearColor;
    kViewBorderRadius(_remarkTV, 0, 0.5, kColorFromStr(@"#44474F"));
    _remarkTV.editable = NO;
    
    _from.text = kLocat(@"Z_from");
    _to.text = kLocat(@"Z_to");
    _tips.text = kLocat(@"W_leaveword");
    
    
    
    [_icon setImageWithURL:[NSURL URLWithString:_dic[@"currency_logo"]] placeholder:nil];
    
    NSInteger type = [_dic[@"type"] integerValue];
    if (type == 5) {//5:充币 6:提币
//        _toLabel.text = [NSString stringWithFormat:@"我的%@錢包",_dic[@""]];

        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"W_receive"),_dic[@"from_name"]];

        _toLabel.text = [NSString stringWithFormat:@"%@ %@ %@",kLocat(@"W_My"),_dic[@"from_name"],kLocat(@"W_Wallet")];
        _fromLabel.text = _dic[@"address"];
        
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"W_Send"),_dic[@"from_name"]];
        _fromLabel.text = [NSString stringWithFormat:@"%@ %@ %@",kLocat(@"W_My"),_dic[@"from_name"],kLocat(@"W_Wallet")];
                _toLabel.text = _dic[@"address"];
    }
    _volumeLabel.text = [NSString stringWithFormat:@"%@ %@",_dic[@"number"],_dic[@"from_name"]];


    int status = [_dic[@"status"] intValue];
    if (status == -1) {
        _statusLabel.text = kLocat(@"W_cancelled");
    }else if (status == 0){
        _statusLabel.text = kLocat(@"W_checking");
        _statusLabel.textColor = kColorFromStr(@"#E06920");
    }else{
        _statusLabel.text = kLocat(@"OTC_order_done");
        _statusLabel.textColor = kNaviColor;
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"%@：%@",kLocat(@"W_dealtime"),_dic[@"add_time"]];
    _feeLabel.text = [NSString stringWithFormat:@"%@%@%@",kLocat(@"OTC_post_fee"),_dic[@"fee"],_dic[@"from_name"]];
    
    
  
//
    _feeLabel.text = [NSString stringWithFormat:@"%@%@%@",kLocat(@"OTC_post_fee"),_dic[@"fee"],_dic[@"from_name"]];
//
    
    
    
    _remarkTV.text = _dic[@"remark"];
    
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.fromLabel addGestureRecognizer:touch];
    
    UILongPressGestureRecognizer *touch1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap1:)];
    [self.toLabel addGestureRecognizer:touch1];
  
    UILongPressGestureRecognizer *touch2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap2:)];
    [self.tagValue addGestureRecognizer:touch2];
    
    UILongPressGestureRecognizer *touch3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap3:)];
    [self.hashLabelValue addGestureRecognizer:touch3];
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    [self showTips:kLocat(@"hz_copyscuess")];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.fromLabel.text;
}

- (void)handleTap1:(UITapGestureRecognizer *)tap{
    [self showTips:kLocat(@"hz_copyscuess")];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.toLabel.text;
}

- (void)handleTap2:(UITapGestureRecognizer *)tap{
    [self showTips:kLocat(@"hz_copyscuess")];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.tagValue.text;
}

- (void)handleTap3:(UITapGestureRecognizer *)tap{
    [self showTips:kLocat(@"hz_copyscuess")];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.hashLabelValue.text;
}

@end
