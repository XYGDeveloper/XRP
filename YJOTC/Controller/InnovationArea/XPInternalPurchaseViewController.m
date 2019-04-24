//
//  XPInternalPurchaseViewController.m
//  YJOTC
//
//  Created by l on 2019/4/3.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPInternalPurchaseViewController.h"
#import "XPExchangeHeaderTableViewCell.h"
#import "XPInternaPurchaseTableViewCell.h"
#import "XPInnovationExchangeFootTableViewCell.h"
#import "XPInnovacationGACListViewController.h"
#import "XPExchangeInnocationModel.h"
#import "TPWalletSendKeyboardView.h"
#import "XPGACInnerPurchModel.h"
#import "XPFreezeListViewController.h"
#import "XPInnovacationGACListViewController.h"
@interface XPInternalPurchaseViewController ()<UITextFieldDelegate,TPWalletSendKeyboardViewDelegate>
@property (nonatomic,strong)XPExchangeHeaderTableViewCell *header;
@property (nonatomic,strong)XPInnovationExchangeFootTableViewCell *footer;
@property (nonatomic,strong)XPExchangeInnocationModel *model1;
@property (nonatomic,assign)BOOL isHaveDian;
@property (nonatomic,strong)XPGACInnerPurchModel *model;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviHeight;
@end

@implementation XPInternalPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviHeight.constant = kNavigationBarHeight;
    self.title = kLocat(@"XPInternalPurchaseViewController_title");
    self.view.backgroundColor = kColorFromStr(@"#F4F4F4");
    [self addRightBarButtonItemWithTitle:kLocat(@"XPInternalPurchaseViewController_recorder") titleColor:kColorFromStr(@"#FFFFFF") action:@selector(recorder)];
    [self.tableview registerNib:[UINib nibWithNibName:@"XPExchangeHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPExchangeHeaderTableViewCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:@"XPInternaPurchaseTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPInternaPurchaseTableViewCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:@"XPInnovationExchangeFootTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPInnovationExchangeFootTableViewCell class])];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}


- (void)loadData{
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"InternalBuy/index"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        if (success) {
            XPGACInnerPurchModel *model = [XPGACInnerPurchModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kResult]];
            self.model = model;
            [self.tableview reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.header.countLabel.text = @"";
                [self.header.countLabel becomeFirstResponder];
            });
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


- (void)exchange{
    
    if ([self.header.countLabel.text floatValue] <= 0.00 || self.header.countLabel.text.length  <= 0) {
        [kKeyWindow showWarning:kLocat(@"XPInnovacationExchangeViewController_fasongucount_placehoder")];
        return;
    }
    [self.header.countLabel resignFirstResponder];
    NSLog(@"1111111111222222");
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    [kKeyWindow addSubview:bgView];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(kScreenW - 40 - 12, kStatusBarHeight, 40, 40) title:nil titleColor:kColorFromStr(@"#4C9EE4") font:PFRegularFont(14) titleAlignment:1];
    [bgView addSubview:cancelButton];
    [cancelButton setImage:kImageFromStr(@"jies_icon_yinc") forState:UIControlStateNormal];
    
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        [sender.superview removeFromSuperview];
    }];
    
    CGFloat h = 45 + 60*4 *kScreenHeightRatio;
    TPWalletSendKeyboardView *keyBoardView = [[TPWalletSendKeyboardView alloc] initWithFrame:kRectMake(0, kScreenH - h, kScreenW, h)];
    keyBoardView.delegate = self;
    [bgView addSubview:keyBoardView];
    keyBoardView.showPayView = YES;
}

-(void)didClickConfirmButtonWith:(TPWalletSendKeyboardView *)keyboardView toSubmit:(BOOL)toSubmit
{
    
    if (keyboardView.payTF.text.length == 0) {
        [kKeyWindow showWarning:kLocat(@"k_popview_list_counter_pwd_placehoder")];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"from_num"] = self.header.countLabel.text;
    param[@"pwd"] = [keyboardView.payTF.text md5String];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"InternalBuy/to_buy"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            kLOG(@"操作成功");
            [keyboardView.superview removeFromSuperview];
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                XPInnovacationGACListViewController *list = [XPInnovacationGACListViewController new];
                list.isInner = YES;
                kNavPush(list);
            });
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

- (void)recorder{
    XPInnovacationGACListViewController *inner = [XPInnovacationGACListViewController new];
    inner.isInner = YES;
    kNavPush(inner);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.header = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPExchangeHeaderTableViewCell class])];
        self.header.selectionStyle = UITableViewCellSelectionStyleNone;
        self.header.countLabel.delegate = self;
        [self.header.countLabel addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
        self.header.currencyLabel.text = self.model.from_name;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [self.header.countLabel becomeFirstResponder];
        //        });
        self.header.limitLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"XPInnovacationExchangeViewController_left"),self.model.from_user_num];
        return self.header;
    }else if (indexPath.section == 1){
        XPInternaPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPInternaPurchaseTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithMOdel:self.model];
        return cell;
    }else{
        self.footer = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPInnovationExchangeFootTableViewCell class])];
        self.footer.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.footer.senderButton addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
        self.footer.currencyLabel.text = self.model.to_currency;
        double f = ([self.header.countLabel.text doubleValue] *[self.model.ratio doubleValue])/1.0;
        NSLog(@"----------------------%f",f);
        self.footer.countLabel.text = [NSString stringWithFormat:@"%f",f];
        //        self.footer.countLabel.text = self.model.to_cny;
        return self.footer;
    }
}

-(void)textField1TextChange:(UITextField *)textField{
    if ([self.header.countLabel.text doubleValue] > [self.model.from_user_num doubleValue]) {
        [self.header.countLabel resignFirstResponder];
        //        self.header.countLabel.text = self.model.from_user_num;
        [self showTips:kLocat(@"XPInnovacationExchangeViewController_morethan")];
        return;
    }
    
    //    if ([self.header.countLabel.text isEqualToString:@""]) {
    //        self.header.countLabel.text = self.model.from_user_num;
    //    }
    
    double f = ([self.header.countLabel.text doubleValue] *[self.model.ratio doubleValue])/1.0;
    NSLog(@"----------------------%f",f);
    self.footer.countLabel.text = [NSString stringWithFormat:@"%f",f];
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 245;
    }else if (indexPath.section == 1){
        return 166;
    }else{
        return 280;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}




/**
 *  textField的代理方法，监听textField的文字改变
 *  textField.text是当前输入字符之前的textField中的text
 *
 *  @param textField textField
 *  @param range     当前光标的位置
 *  @param string    当前输入的字符
 *
 *  @return 是否允许改变
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length >= 6) {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}


@end
