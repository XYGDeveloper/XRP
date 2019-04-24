//
//  HBCurrentEntrustContaineeTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCurrentEntrustContaineeTableViewController.h"
#import "HBCurrentEntrustCell.h"
#import "YWAlert.h"
#import "YTTradeUserOrderModel+Request.h"
#import "YTData_listModel.h"
#import "HBCurrentEntrustViewController.h"

static CGFloat const kEmptyCellHeight = 140.;

@interface HBCurrentEntrustContaineeTableViewController ()

@property (nonatomic, assign) BOOL isFetchInProgress;
@property (nonatomic, assign, readonly) BOOL isEmpty;

@end

@implementation HBCurrentEntrustContaineeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self.tableView registerNib:[UINib nibWithNibName:@"HBCurrentEntrustCell" bundle:nil] forCellReuseIdentifier:@"HBCurrentEntrustCell"];
 
}


#pragma mark - TableVeiwDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEmpty) {
        return kEmptyCellHeight;
    }
    return kCellHeight;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isEmpty) {
        return 1;
    }
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isEmpty) {
        return [tableView dequeueReusableCellWithIdentifier:@"HBCurrentEntrustEmptyCell" forIndexPath:indexPath];
    }
    
    HBCurrentEntrustCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBCurrentEntrustCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.model = self.orders[indexPath.row];
    cell.cancelBlock = ^(YTTradeUserOrderModel *model) {
        [weakSelf _showDeleteAlertWithModel:model];
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)_showDeleteAlertWithModel:(YTTradeUserOrderModel *)model {
    [YWAlert alertWithTitle:kLocat(@"C_Tip") message:kLocat(@"C_TipDetail") sureAction:^{
        [model cancelTradeOrdersWithSuccess:^(YWNetworkResultModel * _Nonnull obj) {
            [self showTips:obj.message];
            if ([obj succeeded]) {
                [self _deleteModel:model];
            }
        } failure:^(NSError * _Nonnull error) {
            [self showTips:error.localizedDescription];
        }];
        
        [self _deleteModel:model];
    } cancelAction:nil inViewController:self];
}

- (void)_deleteModel:(YTTradeUserOrderModel *)model {
    
    NSMutableArray *array = self.orders.mutableCopy;
    [array removeObject:model];
    self.orders = array.copy;
}

#pragma mark - Setters & Getters
- (void)setOrders:(NSArray<YTTradeUserOrderModel *> *)orders {
    _orders = orders;
    
    [self.tableView reloadData];
}

- (BOOL)isEmpty {
    return self.orders.count == 0;
}

#pragma mark - Public

- (CGFloat)getHeight {
    if (self.isEmpty) {
        return kEmptyCellHeight;
    }
    return [HBCurrentEntrustContaineeTableViewController getHeightWithModels:self.orders];
}

static CGFloat const kCellHeight = 179;
+ (CGFloat)getHeightWithModels:(NSArray<YTTradeUserOrderModel *> *)models {
    return models.count * kCellHeight;
}
@end
