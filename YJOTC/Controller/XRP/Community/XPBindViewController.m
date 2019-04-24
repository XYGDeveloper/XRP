//
//  XPBindViewController.m
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPBindViewController.h"
#import "XPBindHeaderTableViewCell.h"
#import "XPReveInfoTableViewCell.h"
#import "XPReveButtonTableViewCell.h"
#import "XPsearchResultTableViewCell.h"
#import "XPSearchSecftionHeaderTableViewCell.h"
#import "WarmAlertView.h"
#import "XPApplyModel.h"
#import "XPCommunityDetailViewController.h"
#import "XPJHMemberViewController.h"
@interface XPBindViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)XPBindHeaderTableViewCell *header;
@property (nonatomic,strong)XPReveButtonTableViewCell *footer;
@property (nonatomic,strong)XPApplyModel *model;

@end

@implementation XPBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorFromStr(@"#F4F4F4");
    self.tableview.backgroundColor = kColorFromStr(@"#F4F4F4");

    [self.tableview registerNib:[UINib nibWithNibName:@"XPsearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPsearchResultTableViewCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:@"XPReveInfoTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPReveInfoTableViewCell class])];
    self.header =  [[[NSBundle mainBundle] loadNibNamed:@"XPBindHeaderTableViewCell" owner:self options:nil] lastObject];
    self.footer =  [[[NSBundle mainBundle] loadNibNamed:@"XPReveButtonTableViewCell" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = self.header;
    self.tableview.tableFooterView = self.footer;
    __weak typeof(self)weakSelf = self;
//    self.footer.backgroundColor = kRedColor;
    self.footer.sure = ^{
        [WarmAlertView AlertWith:kLocat(@"C_community_search_alert_sure_title") detail:kLocat(@"C_community_search_alert_sure_detail") leffButton:kLocat(@"C_community_search_alert_cancel") rightButton:kLocat(@"C_community_search_alert_sure") controller:weakSelf cancelAction:^{
        } sureAction:^{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"key"] = kUserInfo.token;
            param[@"token_id"] = @(kUserInfo.uid);
            [weakSelf.view showHUD];
            [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/BossPlan/activation_confirm"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
                [weakSelf.view hideHUD];
                NSLog(@"%@",responseObj);
                if (success) {
                    [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
                    kNavPushSafe([XPCommunityDetailViewController new]);
                }else{
                    [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
                }
            }];
        }];
    };
    self.footer.reset = ^{
        [WarmAlertView AlertWith:kLocat(@"C_community_search_alert_reset_title") detail:kLocat(@"C_community_search_alert_reset_detail") leffButton:kLocat(@"C_community_search_alert_cancel") rightButton:kLocat(@"C_community_search_alert_sure") controller:weakSelf cancelAction:^{
            
        } sureAction:^{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"key"] = kUserInfo.token;
            param[@"token_id"] = @(kUserInfo.uid);
            [weakSelf.view showHUD];
            [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/BossPlan/activation_cancel"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
                [weakSelf.view hideHUD];
                NSLog(@"%@",responseObj);
                if (success) {
                    [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
                }
            }];
        }];
    };
    
    self.footer.tose = ^{
        XPJHMemberViewController *vc = [XPJHMemberViewController new];
        vc.memberID = [NSString stringWithFormat:@"%ld",(long)kUserInfo.uid];
        kNavPushSafe(vc);
    };
    [self loaddata];
}

- (void)loaddata{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/BossPlan/apply_info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        if (success) {
            self.model = [XPApplyModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            self.header.headimg.image = [UIImage imageNamed:@"warmimg"];
            if ([self.model.parent.status isEqualToString:@"1"]) {
                self.header.titleLabel.text = kLocat(@"C_community_search_current_wait_reveed");
                if (!self.model.audit.status) {
                    self.footer.firstButton.hidden = YES;
                    [self.footer.firstButton setTitle:kLocat(@"s_checkbyself") forState:UIControlStateNormal];
                    self.title = kLocat(@"C_community_search_current_wait_tosure");
                }else{
                    self.footer.firstButton.hidden = NO;
                    self.title = kLocat(@"C_community_search_current_wait_reveed");
                }
            }else if ([self.model.parent.status isEqualToString:@"2"]){
                self.header.titleLabel.text = kLocat(@"C_community_search_current_wait_tosure");
                self.title = kLocat(@"C_community_search_current_wait_tosure");
            }else{
                self.header.titleLabel.text = kLocat(@"C_community_search_current_wait_sured");
                self.title = kLocat(@"C_community_search_current_wait_sured");
            }
            self.header.detaiLabel.text = kLocat(@"C_community_search_current_wait_detail");
            [self.tableview reloadData];
            
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.model.audit.status) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.model.audit.status) {
        XPsearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPsearchResultTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithapplyModel:self.model.parent];
        return cell;
    }else{
        if (indexPath.section == 0) {
            XPsearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPsearchResultTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWithapplyModel:self.model.parent];
            return cell;
        }else{
            XPReveInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPReveInfoTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWithModel:self.model.audit];
            return cell;
        }
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.model.audit.status) {
        return 90;
    }else{
        if (indexPath.section == 0) {
            return 90;
        }else{
            return 95;
        }
        
    }
   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        if (!self.model.audit.status) {
            return [self createHeadview:kLocat(@"C_community_search_current_youinviter")];
        }else{
            if (section == 0) {
                return [self createHeadview:kLocat(@"C_community_search_current_youinviter")];
            }else{
                return [self createHeadview:kLocat(@"C_community_search_current_reveinfo")];
            }
        }
       
    }else{
        if (!self.model.audit.status) {
            return [self createHeadview:kLocat(@"C_community_search_current_youinviter")];
        }else{
            if (section == 0) {
                return [self createHeadview:kLocat(@"C_community_search_current_youinviter")];
            }else{
                return [self createHeadview:kLocat(@"C_community_search_current_reveinfo")];
            }
        }
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
        return 35;
    }else{
        return 35;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (UIView *)createHeadview:(NSString *)title{
    UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 35)];
    content.backgroundColor = kColorFromStr(@"#F4F4F4");
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = kColorFromStr(@"#066B98");
    [content addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(content.mas_centerY);
        make.left.mas_equalTo(13);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = kColorFromStr(@"#222222");
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [content addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(content.mas_centerY);
        make.left.mas_equalTo(leftView.mas_right).mas_equalTo(10);
    }];
    return content;
}


@end
