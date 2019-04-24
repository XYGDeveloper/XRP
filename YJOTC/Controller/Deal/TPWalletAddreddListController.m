
//
//  TPWalletAddreddListController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletAddreddListController.h"
#import "TPWalletAddressListCell.h"
#import "TPWalletAddressAddController.h"

@interface TPWalletAddreddListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation TPWalletAddreddListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    
    [self setupUI];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self loadData];

}

-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = _currencyID;
    kShowHud;
    __weak typeof(self)weakSelf = self;

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/getAddressList"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
        kHideHud;
        if (success) {
            NSArray *data = [responseObj ksObjectForKey:kData];
            [self.dataArray removeAllObjects];
            
            if (data.count == 0 ) {
                //                [self showTips:kLocat(@"OTC_buylist_noorder")];
                
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"W_NOAddress") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                    [[EmptyManager sharedManager] removeEmptyFromView:weakSelf.view];
                }];
                [self.tableView reloadData];

                return ;
            }
            
            
            for (NSDictionary*dic in data) {
                [self.dataArray addObject:dic];
            }
            if (self.dataArray.count == 0) {
                [self showTips:kLocat(@"W_NOAddress")];
            }
            [self.tableView reloadData];
 
        }else{
//            [self showTips:kLocat(@"W_NOAddress")];
            
            if ([[responseObj ksObjectForKey:kCode] integerValue] == 10001) {
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"W_NOAddress") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
                    [weakSelf loadData];
                    [[EmptyManager sharedManager] removeEmptyFromView:weakSelf.view];
                }];
                [self.dataArray removeAllObjects];

                [self.tableView reloadData];
            }
            
        }
    }];

}
-(void)setupUI
{
    self.title = kLocat(@"W_addressBook");
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight ) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletAddressListCell" bundle:nil] forCellReuseIdentifier:@"TPWalletAddressListCell"];
    [self addRightBarButtonWithFirstImage:kImageFromStr(@"di_icon_tianj") action:@selector(addAction)];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPWalletAddressListCell";
    TPWalletAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.editButton.tag = indexPath.section;
    cell.deleteButton.tag = indexPath.section;

    [cell.editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.addressLabel.text = self.dataArray[indexPath.section][@"qianbao_url"];
    
    if ([self.dataArray[indexPath.section][@"names"] isKindOfClass:[NSNull class]]) {
        cell.tagLabel.text = @"";
    }else{
        cell.tagLabel.text = self.dataArray[indexPath.section][@"names"];
    }
    cell.addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;

    
    return cell;
}

-(void)addAction
{
    TPWalletAddressAddController *vc = [TPWalletAddressAddController new];
    vc.currencyID = _currencyID;
    vc.isXrp = _isXrp;
    vc.isEOS = _isEOS;

    kNavPush(vc);
}
-(void)editAction:(UIButton *)button
{
    TPWalletAddressAddController *vc = [TPWalletAddressAddController new];
    vc.dateDic = self.dataArray[button.tag];
    vc.currencyID = _currencyID;
    vc.isXrp = _isXrp;
    vc.isEOS = _isEOS;
    kNavPush(vc);
}
-(void)deleteAction:(UIButton *)button
{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:kLocat(@"W_suertodeletethisaddress") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:kLocat(@"W_suertodeletethisaddress")];
    [hogan addAttribute:NSFontAttributeName value:PFRegularFont(12) range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#E84D4D") range:NSMakeRange(0, [[hogan string] length])];
    [alertController setValue:hogan forKey:@"attributedTitle"];
    
    UIAlertAction *desAction = [UIAlertAction actionWithTitle:kLocat(@"W_confirmdelete") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"currency_id"] = _currencyID;
        param[@"id"] = self.dataArray[button.tag][@"id"];
        
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/deleteAddress"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [self showTips:[responseObj ksObjectForKey:kMessage]];
                
                
                [self loadData];
                
//                [self.dataArray removeObjectAtIndex:button.tag];
//                
//                [self.tableView reloadData];
                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    kNavPop;
//                });
            }else{
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [desAction setValue:kColorFromStr(@"#11B1ED") forKey:@"_titleTextColor"];
    [cancelAction setValue:kColorFromStr(@"#11B1ED") forKey:@"_titleTextColor"];
    
    [alertController addAction:desAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.callBackBlock(self.dataArray[indexPath.section]);
    
    kNavPop;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60 + 28;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}




@end
