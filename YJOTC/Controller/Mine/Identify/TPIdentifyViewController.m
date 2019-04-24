//
//  TPIdentifyViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPIdentifyViewController.h"
#import "TPIdentifyCell.h"

@interface TPIdentifyViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UITextField *typeTF;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *numberTF;

@property(nonatomic,strong)NSArray *cardTypeArr;
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,copy)NSString *temSelectedItem;
@property(nonatomic,strong)UIPickerView *pickerView;

@property(nonatomic,strong) UIView *infoView;

@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *statusLabel;




@end

@implementation TPIdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cardTypeArr = @[@"身份證",@"護照",@"港澳通行證"];//1身份證，2護照，3駕駛證

    self.title = @"實名認證";

    if (_type) {
        [self createIdentifyView];
    }else{
        [self setupUI];
    }
    
    
}

-(void)setupUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"YWCircleSpaceListCell" bundle:nil] forCellReuseIdentifier:@"YWCircleSpaceListCell"];
    _tableView.backgroundColor = kColorFromStr(@"#111419");
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [_tableView registerNib:[UINib nibWithNibName:@"TPIdentifyCell" bundle:nil] forCellReuseIdentifier:@"TPIdentifyCell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 50)];
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(12, 20, kScreenW - 24, 45) title:@"下一步" titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    kViewBorderRadius(button, 22.5, 0, kRedColor);
    [button setBackgroundImage:kImageFromStr(@"loin_btn_loin") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    button.SG_eventTimeInterval = 3;
    [footerView addSubview:button];
    _tableView.tableFooterView = footerView;
    
    
}
-(void)createIdentifyView
{
    self.view.backgroundColor = kColorFromStr(@"#111419");
    
    
    // 1：身份證 2：護照 3：港澳通行證
    NSString *identifyStr;
    
    if (_identifyType == 1) {
        identifyStr = @"中國大陸身份證";
    }else if (_identifyType == 2){
        identifyStr = @"護照";
    }else{
        identifyStr = @"港澳通行證";
    }
    
    
    UIView *topView = [[UIView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight+10, kScreenW, 57)];
    [self.view addSubview:topView];
    topView.backgroundColor = kColorFromStr(@"1E1F22");
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:kRectMake(12, 0, 22, 17)];
    icon.image = kImageFromStr(@"shenfen_icon1");
    [topView addSubview:icon];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:kRectMake(icon.right + 3, 0, 200, 16) text:identifyStr font:PFRegularFont(14) textColor:kColorFromStr(@"#CDD2E3") textAlignment:0 adjustsFont:YES];
    [topView addSubview:typeLabel];
    [icon alignVertical];
    [typeLabel alignVertical];
    
    UIButton *acButton = [[UIButton alloc]initWithFrame:kRectMake(0, 0, 24+27, 30) title:@"收起" titleColor:kColorFromStr(@"#11B1ED") font:PFRegularFont(14) titleAlignment:0];
    [topView addSubview:acButton];
    [acButton setTitle:@"展開" forState:UIControlStateSelected];
    
    
    [acButton alignVertical];
    acButton.right = kScreenW;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.height - 0.5, kScreenW, 0.5)];
    lineView.backgroundColor = self.view.backgroundColor;
    [topView addSubview:lineView];

    
    
    
    UIView *infoView = [[UIView alloc] initWithFrame:kRectMake(0, topView.bottom, kScreenW, 144)];
    infoView.backgroundColor = topView.backgroundColor;
    [self.view addSubview:infoView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:kRectMake(12, 37, 48, 48)];
    [infoView addSubview:imageView];
    imageView.image = kImageFromStr(@"shenfen_icon2");
                       
                       
    
    UILabel *midLabel = [[UILabel alloc] initWithFrame:kRectMake(imageView.right + 10, imageView.y + 4, 250, 16) text:[NSString stringWithFormat:@"證件類型：%@",identifyStr] font:PFRegularFont(14) textColor:kColorFromStr(@"#CDD2E3") textAlignment:0 adjustsFont:1];
    [infoView addSubview:midLabel];
    
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:kRectMake(midLabel.x, 0, 200, 13) text:@"狀態：已驗證" font:PFRegularFont(12) textColor:kColorFromStr(@"#8D95AA") textAlignment:0 adjustsFont:1];
    [infoView addSubview:statusLabel];
    statusLabel.bottom = imageView.bottom;
    
    _statusLabel = statusLabel;
    _icon = imageView;
    _typeLabel = midLabel;
    
    _infoView = infoView;

    __weak typeof(self)weakSelf = self;
    
    [acButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
        
        if (sender.isSelected) {
            weakSelf.infoView.alpha = 1;
            
//            [UIView animateWithDuration:0.25 animations:^{
//                weakSelf.infoView.frame = kRectMake(0, sender.superview.bottom, kScreenW, 144);
//                _statusLabel.height = 13;
//                _typeLabel.height = 16;
//                _icon.height = 48;
//            }];
            
        }else{
            weakSelf.infoView.alpha = 0;
//            [UIView animateWithDuration:0.25 animations:^{
//                weakSelf.infoView.frame = kRectMake(0, sender.superview.bottom, kScreenW, 0);
//                _statusLabel.height = 0;
//                _typeLabel.height = 0;
//                _icon.height = 0;
//            }];
        }
        sender.selected = !sender.isSelected;
    }];
    
}






-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPIdentifyCell";
    TPIdentifyCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.tf.userInteractionEnabled = indexPath.row;
    cell.arrow.hidden = indexPath.row;
    if (indexPath.row == 0) {
        cell.itemLabel.text = @"请选择证件类型";
        if (_typeTF.text.length > 1) {
            cell.tf.text = _typeTF.text;
        }
        
        _typeTF = cell.tf;

    }else if (indexPath.row == 1){
        cell.itemLabel.text = @"真實姓名";
        _nameTF = cell.tf;
//        cell.tf.placeholder = @"與證件證上姓名保持一致";
        cell.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString: @"與證件證上姓名保持一致" attributes:@{NSForegroundColorAttributeName: kColorFromStr(@"#999999")}];
    }else{
        cell.itemLabel.text = @"證件號碼";
        _numberTF = cell.tf;
//        cell.tf.placeholder = @"請輸入證件號碼";
        cell.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"請輸入證件號碼" attributes:@{NSForegroundColorAttributeName: kColorFromStr(@"#999999")}];
    }
        
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showPickViewWithTag:indexPath.row];
    }
}
//性别..
-(void)showPickViewWithTag:(NSInteger )tag
{
    self.coverView.hidden = NO;
    UIView *bgView = [[UIView alloc]initWithFrame:kRectMake(0, kScreenH, kScreenW, 220)];
    [self.coverView addSubview:bgView];
    bgView.tag = 100;
    
    UIView *titleView = [[UIView alloc]initWithFrame:kRectMake(0, 0 , kScreenW, 45)];
    [bgView addSubview:titleView];
    titleView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    
    [titleView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        
    }]];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:kRectMake(kMargin, 0, 40, titleView.height)];
    [titleView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0.85 green:0.72 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = PFRegularFont(14);
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelButton addTarget:self action:@selector(hidePickView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *confirmlButton = [[UIButton alloc]initWithFrame:kRectMake(kMargin, 0, 60, titleView.height)];
    [titleView addSubview:confirmlButton];
    confirmlButton.right = kScreenW - kMargin;
    
    [confirmlButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmlButton setTitleColor:[UIColor colorWithRed:0.85 green:0.72 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
    confirmlButton.titleLabel.font = PFRegularFont(14);
    confirmlButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmlButton.tag = tag;
    [confirmlButton addTarget:self action:@selector(confirmChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_pickerView) {
        [_pickerView removeAllSubviews];
        [_pickerView removeFromSuperview];
        _pickerView = nil;
    }
    _pickerView = [[UIPickerView alloc]initWithFrame:kRectMake(0, 45, kScreenW, 175)];
    _pickerView.tag = tag;
    _pickerView.backgroundColor = kWhiteColor;
    [bgView addSubview:_pickerView];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    //        _addressTF.text = self.bankArray.firstObject.bankname;
    [UIView animateWithDuration:0.25 animations:^{
        bgView.frame = kRectMake(0, kScreenH - 220, kScreenW, 220);
    }];
    
    
}
-(void)hidePickView
{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView *view in self.coverView.subviews) {
            view.frame = kRectMake(0, kScreenH, kScreenW, 220);
        }
        
    } completion:^(BOOL finished) {
        [self.coverView removeAllSubviews];
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
    _temSelectedItem = nil;
}
-(void)confirmChooseAction:(UIButton *)button
{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView *view in self.coverView.subviews) {
            view.frame = kRectMake(0, kScreenH, kScreenW, 220);
        }
        
    } completion:^(BOOL finished) {
        [self.coverView removeAllSubviews];
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
    switch (button.tag) {
        case 0:
        {
            if (_temSelectedItem == nil) {
                _temSelectedItem = self.cardTypeArr.firstObject;
            }
            
            
            _typeTF.text = _temSelectedItem;
            
            [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
       
        default:
            break;
    }
    
    _temSelectedItem = nil;
}

#pragma mark - 选择器
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 0:
        {
            return self.cardTypeArr.count;
        }
            break;
        default:
            return 100;
            break;
    }
}
- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str1 = nil;
    
    switch (pickerView.tag) {
            
        case 0:
        {
            str1 = self.cardTypeArr[row];
        }
            break;
            
        default:
            
            break;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
    [str addAttribute:NSForegroundColorAttributeName
                value:k323232Color
                range:NSMakeRange(0, [str1 length])];
    [str addAttribute:NSFontAttributeName
                value:PFRegularFont(18)
                range:NSMakeRange(0, [str1 length])];
    return str.mutableCopy;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 0:
        {
            _temSelectedItem = self.cardTypeArr[row];
        }
            break;

        default:
            break;
    }
}

-(void)nextAction
{
    [self hideKeyBoard];
//    [self showStatusWithSuccess:NO tips:@"有问题"];
//    return;
//
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
 
    if (_typeTF.text.length == 0) {
        [self showTips:@"請選擇證件類型"];
        return;
    }
    if (_nameTF.text.length == 0) {
        [self showTips:@"請填寫真實姓名"];
        return;
    }
    if (_numberTF.text.length == 0) {
        [self showTips:@"請輸入證件號碼"];
        return;
    }
    
    if ([_typeTF.text isEqualToString:@"身份證"]) {
        param[@"cardtype"] = @"1";
    }else if([_typeTF.text isEqualToString:@"護照"]){
        param[@"cardtype"] = @"2";
    }else{
        param[@"cardtype"] = @"3";
    }
    param[@"real_name"] = _nameTF.text;
    param[@"number"] = _numberTF.text;
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Set/simple_verify"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showStatusWithSuccess:YES tips:@"驗證成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
            });
        }else{
           
            [self showStatusWithSuccess:NO tips:[responseObj ksObjectForKey:kMessage]];
        }
    }];

}

-(void)showStatusWithSuccess:(BOOL)success tips:(NSString *)tips
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    [kKeyWindow addSubview:bgView];
    bgView.backgroundColor = [kColorFromStr(@"#0F1012") colorWithAlphaComponent:0.5];
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(0, 200 *kScreenHeightRatio, 300 * kScreenWidthRatio, 180 * kScreenWidthRatio)];
    [bgView addSubview:midView];
    [midView alignHorizontal];
    midView.backgroundColor = kColorFromStr(@"#F4F4F4");
    
    UIImage *img ;
    
    if (success) {
        img = kImageFromStr(@"ren_icon1");
        
    }else{
        img = kImageFromStr(@"ren_icon2");
    }
    
    UIImageView *icon = [[UIImageView alloc]initWithImage:img];
    
    [midView addSubview:icon];
    [icon alignHorizontal];
    icon.y = 40 * kScreenWidthRatio;
    
    NSString *tipsStr = tips;;
//    if (success) {
//        tipsStr = @"驗證成功";
//    }else{
//        tipsStr = @"驗證失敗";
//    }
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 126 *kScreenWidthRatio, midView.width-20, 16) text:tipsStr font:PFRegularFont(14) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:tipsLabel];
    [tipsLabel alignHorizontal];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [bgView removeFromSuperview];
    });
    
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


-(UIView *)coverView
{
    if (_coverView == nil) {
        _coverView = [[UIView alloc]initWithFrame:kScreenBounds];
        [kKeyWindow addSubview:_coverView];
        _coverView.userInteractionEnabled = YES;
        _coverView.hidden = YES;
        [ _coverView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePickView)]];
        
    }
    return _coverView;
}


@end
