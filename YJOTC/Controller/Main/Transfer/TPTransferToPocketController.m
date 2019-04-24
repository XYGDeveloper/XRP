//
//  TPTransferToPocketController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPTransferToPocketController.h"
#import "TPTransferToPocketEndController.h"

@interface TPTransferToPocketController ()

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger second;

@property(nonatomic,strong)UIButton *confirmButton;

@property(nonatomic,strong)UITextField *accountTF;


@end

@implementation TPTransferToPocketController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];



}

-(void)setupUI
{
    self.title = @"轉到口袋賬戶";
    self.view.backgroundColor = k111419Color;
    
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:kRectMake(0, 40 + kNavigationBarHeight, 60, 60)];
    
    [self.view addSubview:avatar];
    [avatar alignHorizontal];
    avatar.image = kImageFromStr(@"toux_icon");
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(0, avatar.bottom + 74 *kScreenHeightRatio, kScreenW, 45)];
    midView.backgroundColor = kColorFromStr(@"#1E1F22");
    [self.view addSubview:midView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, 0, 65, midView.height) text:@"對方賬號" font:PFRegularFont(16) textColor:kLightGrayColor textAlignment:0 adjustsFont:YES];
    [midView addSubview:label];
    
    UITextField *accountTF = [[UITextField alloc] initWithFrame:kRectMake(90, 0, kScreenW - 90 - 12, midView.height)];
    [midView addSubview:accountTF];
    accountTF.placeholder = @"請輸入口袋賬號";
    kTextFieldPlaceHoldColor(accountTF, kColorFromStr(@"#707589"));
    accountTF.textColor = kLightGrayColor;
    accountTF.font = PFRegularFont(16);
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:kRectMake(12, midView.bottom + 20, kScreenW - 24, 45) title:@"下一步" titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [self.view addSubview:nextButton];
//    nextButton.backgroundColor = kColorFromStr(@"#11B1ED");
    [nextButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#11B1ED")] forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    kViewBorderRadius(nextButton, 8, 0, kRedColor);

    
    _accountTF = accountTF;
}
-(void)nextAction
{
    [self hideKeyBoard];
    if (_accountTF.text.length == 0) {
        [self showTips:@"請輸入口袋賬號"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"email"] = _accountTF.text;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Transfer/koudai_check"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            
            [self showConfirmViewWith:dic[@"account"] name:dic[@"realName"] success:YES];
        }else{
            [self showConfirmViewWith:_accountTF.text name:[responseObj ksObjectForKey:kMessage] success:NO];
        }
    }];
    
 
}

-(void)showConfirmViewWith:(NSString *)memberID name:(NSString *)name success:(BOOL)success
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:.64];
    [kKeyWindow addSubview:bgView];
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(25, 178 *kScreenHeightRatio, kScreenW - 50, 250)];
    [bgView addSubview:midView];
    midView.backgroundColor = kColorFromStr(@"#F4F4F4");

    UILabel *title = [[UILabel alloc] initWithFrame:kRectMake(0, 30, midView.width, 18) text:@"確認對方賬戶信息" font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:title];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:kRectMake(0, 65, 48, 48)];
    [midView addSubview:icon];
    [icon alignHorizontal];
    if (success) {
        icon.image = kImageFromStr(@"tishi_icon2");
    }else{
        icon.image = kImageFromStr(@"tishi_icon1");
    }
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:kRectMake(39, 133, midView.width - 80, 15) text:[NSString stringWithFormat:@"對方賬戶：%@",memberID] font:PFRegularFont(14) textColor:k323232Color textAlignment:0 adjustsFont:YES];
    [midView addSubview:accountLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:kRectMake(39, 165, midView.width - 80, 14) text:@"" font:PFRegularFont(14) textColor:k323232Color textAlignment:0 adjustsFont:YES];
    [midView addSubview:nameLabel];
    if (success) {
        nameLabel.text = [NSString stringWithFormat:@"真實姓名：%@",name];
    }else{
        nameLabel.text = name;
    }
    __weak typeof(self)weakSelf = self;

    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 205, midView.width/2, 45) title:@"取消" titleColor:kColorFromStr(@"#9BBBEB") font:PFRegularFont(14) titleAlignment:0];
    [midView addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#434A5D");
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
        [weakSelf.timer invalidate];
        [sender.superview.superview removeFromSuperview];
    }];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:kRectMake(midView.width/2, 205, cancelButton.width, 45) title:@"确定" titleColor:kWhiteColor font:PFRegularFont(14) titleAlignment:1];
    [midView addSubview:confirmButton];
    _confirmButton = confirmButton;
    confirmButton.backgroundColor = kColorFromStr(@"#11B1ED");
    if (success == NO) {
        [confirmButton setTitleColor:kColorFromStr(@"#D3D3D3") forState:UIControlStateNormal];
        [confirmButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
            [sender.superview.superview removeFromSuperview];
        }];
    }else{
        confirmButton.userInteractionEnabled = NO;

        _second = 5;
        self.timer = [WeakTimeObject weakScheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [_confirmButton setTitle:[NSString stringWithFormat:@"確定(%ldS)",(long)_second] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:kColorFromStr(@"#E4E4E4") forState:UIControlStateNormal];
        _confirmButton.backgroundColor = kColorFromStr(@"#656B7B");
        
        [confirmButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
            [weakSelf.timer invalidate];
            [sender.superview.superview removeFromSuperview];
            TPTransferToPocketEndController *vc = [TPTransferToPocketEndController new];
            vc.account = memberID;
            kNavPushSafe(vc);
            
        }];
    }
}


-(void)countDown
{
    _second --;
    if (_second == 0) {
        _confirmButton.userInteractionEnabled = YES;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _confirmButton.backgroundColor = kColorFromStr(@"#11B1ED");
        
        _second = 5;
        [_timer invalidate];
        _timer = nil;
    }else{
        _confirmButton.userInteractionEnabled = NO;
        [_confirmButton setTitle:[NSString stringWithFormat:@"確定(%ldS)",(long)_second] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:kColorFromStr(@"#E4E4E4") forState:UIControlStateNormal];
        _confirmButton.backgroundColor = kColorFromStr(@"#656B7B");
    }
}

-(void)dealloc
{
    kLOG(@"==");
    [_timer invalidate];
    _timer = nil;
    
}


@end
