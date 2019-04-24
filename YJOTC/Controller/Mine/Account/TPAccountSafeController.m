//
//  TPAccountSafeController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPAccountSafeController.h"
#import "TPMineCommenCell.h"
#import "TPResetPWDController.h"
#import "XPMineDescCell.h"
#import "XPAccountPwdController.h"


@interface TPAccountSafeController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *itemArray;


@end

@implementation TPAccountSafeController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

}


-(void)setupUI
{
    if (_type == TPAccountSafeControllerTypeLoginPWD) {
        self.navigationItem.title = kLocat(@"k_ModifyLoginsetViewController_title");
    }else if (_type == TPAccountSafeControllerTypeSafe){
        self.navigationItem.title = kLocat(@"A_accountsecurity");
    }else{
        self.navigationItem.title = kLocat(@"A_securitysetting");
    }
    
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
    
    
    _tableView.backgroundColor = kTableColor;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"XPMineDescCell" bundle:nil] forCellReuseIdentifier:@"XPMineDescCell"];

    [_tableView registerNib:[UINib nibWithNibName:@"TPMineCommenCell" bundle:nil] forCellReuseIdentifier:@"TPMineCommenCell"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == TPAccountSafeControllerTypeMain) {
        static NSString *rid = @"TPMineCommenCell";
        TPMineCommenCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.itemLabelLetfMargin.constant = 43;
        cell.itemIcon.hidden = YES;
        cell.itemLabel.text = self.itemArray[indexPath.row];
        cell.arrow.hidden = NO;
        cell.lineView.backgroundColor = kGrayLineColor;
        if (indexPath.row > 1) {
            cell.descLabel.hidden = YES;
        }else{
            cell.descLabel.hidden = NO;
            cell.descLabel.text = @"當前綁定：136****@163.com";
        }
        cell.lineView.hidden = indexPath.row == self.itemArray.count - 1;

        return cell;
    }else if (_type == TPAccountSafeControllerTypeLoginPWD){
        
        static NSString *rid = @"XPMineDescCell";
        XPMineDescCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        //目前只是用就旧登录密码修改
        cell.icon.image = kImageFromStr(@"user_icon_pasd");
        cell.itemLabel.text = kLocat(@"M_userOldPWD");
        cell.descLabel.text = kLocat(@"M_UserOldPWDTips");
        return cell;
        
        
        if (self.itemArray.count == 3) {
            if (indexPath.row == 0) {//手機號碼
                cell.icon.image = kImageFromStr(@"user_icon_info");
                cell.descLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"M_user"),kUserInfo.securityphone];
                cell.itemLabel.text = kLocat(@"M_MSGVerify");
            }else if (indexPath.row == 1){
                cell.icon.image = kImageFromStr(@"user_icon_mail");
                cell.descLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"M_user"),kUserInfo.securityEmail];
                cell.itemLabel.text = kLocat(@"M_eMailVerify");
            }else{
                cell.icon.image = kImageFromStr(@"user_icon_pasd");
                cell.itemLabel.text = kLocat(@"M_userOldPWD");
                cell.descLabel.text = kLocat(@"M_UserOldPWDTips");
            }
        }else{
            if (indexPath.row == 0){
                if (kUserInfo.securityphone.length > 2) {
                    cell.icon.image = kImageFromStr(@"user_icon_info");
                    cell.descLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"M_user"),kUserInfo.securityphone];
                    cell.itemLabel.text = kLocat(@"M_MSGVerify");
                }else{//郵箱
                    cell.icon.image = kImageFromStr(@"user_icon_mail");
                    cell.descLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"M_user"),kUserInfo.securityEmail];
                    cell.itemLabel.text = kLocat(@"M_eMailVerify");
                }

            }else{
                cell.icon.image = kImageFromStr(@"user_icon_pasd");
                cell.itemLabel.text = kLocat(@"M_userOldPWD");
                cell.descLabel.text = kLocat(@"M_UserOldPWDTips");
            }

        }   
        
        cell.line.hidden = indexPath.row == self.itemArray.count - 1;

        return cell;
    }else{
        static NSString *rid = @"TPMineCommenCell";
        TPMineCommenCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.itemLabelLetfMargin.constant = 43;
        cell.itemIcon.hidden = YES;
        cell.itemLabel.text = self.itemArray[indexPath.row];
        cell.arrow.hidden = NO;
        cell.lineView.backgroundColor = kGrayLineColor;
        if (indexPath.row > 0) {
            cell.descLabel.hidden = YES;
        }else{
            cell.descLabel.hidden = NO;
            cell.descLabel.text = @"當前綁定：136****@163.com";
        }
        cell.lineView.hidden = indexPath.row == self.itemArray.count - 1;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_type == TPAccountSafeControllerTypeLoginPWD) {
        XPAccountPwdController *vc = [XPAccountPwdController new];
        vc.type = XPAccountPwdControllerTypeLoginOldPWD;
        kNavPush(vc);
        return;
        if (self.itemArray.count == 3) {
            if (indexPath.row == 0) {
                XPAccountPwdController *vc = [XPAccountPwdController new];
                vc.type = XPAccountPwdControllerTypeLoginPhone;
                kNavPush(vc);
            }else if (indexPath.row == 1){
                XPAccountPwdController *vc = [XPAccountPwdController new];
                vc.type = XPAccountPwdControllerTypeLoginEmail;
                kNavPush(vc);
            }else{
                XPAccountPwdController *vc = [XPAccountPwdController new];
                vc.type = XPAccountPwdControllerTypeLoginOldPWD;
                kNavPush(vc);
            }
        }else{
            if (indexPath.row == 0) {
                if (kUserInfo.securityphone.length > 2) {
                    XPAccountPwdController *vc = [XPAccountPwdController new];
                    vc.type = XPAccountPwdControllerTypeLoginPhone;
                    kNavPush(vc);
                }else{
                    XPAccountPwdController *vc = [XPAccountPwdController new];
                    vc.type = XPAccountPwdControllerTypeLoginEmail;
                    kNavPush(vc);
                }
            }else{
                XPAccountPwdController *vc = [XPAccountPwdController new];
                vc.type = XPAccountPwdControllerTypeLoginOldPWD;
                kNavPush(vc);
            }
        }
    }
    

    return;
    
    
    if (_type == TPAccountSafeControllerTypeMain) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
        }else if (indexPath.row == 2){
            TPAccountSafeController *vc = [TPAccountSafeController new];
            vc.type = TPAccountSafeControllerTypeLoginPWD;
            kNavPush(vc);
        }else if (indexPath.row == 3){
            
        }else if (indexPath.row == 4){
            TPAccountSafeController *vc = [TPAccountSafeController new];
            vc.type = TPAccountSafeControllerTypeSafe;
            kNavPush(vc);
        }
        
        
    }else if (_type == TPAccountSafeControllerTypeLoginPWD){
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
        }
    }else{
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
        }
    }
    
    
    return;
    
    TPResetPWDController *vc = [TPResetPWDController new];
    if (indexPath.row == 0) {//登录密码
        vc.TPResetPWDType = TPResetPWDTypeLogin;
    }else if (indexPath.row == 1){//交易密码
        vc.TPResetPWDType = TPResetPWDTypeTransaction;
    }else{
        return;
    }
    kNavPush(vc);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



-(NSArray *)itemArray
{
    if (_itemArray == nil) {
        
        if (_type == TPAccountSafeControllerTypeMain) {
            _itemArray = @[@"更換綁定手機",@"更換綁定郵箱",@"更改登錄密碼",@"更改支付密碼",@"賬戶安全"];
        }else if (_type == TPAccountSafeControllerTypeLoginPWD){
            NSMutableArray *arr = [NSMutableArray array];
            if (kUserInfo.securityphone.length > 2) {
                [arr addObject:kLocat(@"M_MSGVerify")];
            }
            if (kUserInfo.securityEmail.length > 0) {
                [arr addObject:kLocat(@"M_eMailVerify")];
            }
            [arr addObject:kLocat(@"M_UserOldPWD")];
//            _itemArray = arr.copy;
            _itemArray = @[kLocat(@"M_UserOldPWD")];
        }else{
            _itemArray = @[@"绑定密保邮箱",@"设置安全问题"];
        }
        
    }
    return _itemArray;
}


@end
