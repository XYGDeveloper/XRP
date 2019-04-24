//
//  XPMoodViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMoodViewController.h"
#import "HBBaseTableViewDataSource.h"
#import "YWDynamicModel+Request.h"
#import "XPMoodCellLayout.h"
#import "XPMoodBasicCell.h"
#import "XPMoodNineImageCell.h"

@interface XPMoodViewController () <UITableViewDataSource, UITableViewDelegate, XPMoodImageCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HBBaseTableViewDataSource *tableViewDataSource;

@property (nonatomic, strong) XPMoodCellLayout *cellLayout;
@property (nonatomic, strong) NSArray<YWDynamicModel *> *models;

@end

@implementation XPMoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self _registerCellClasses];
  
//    self.tableViewDataSource = [[HBBaseTableViewDataSource alloc] initWithItems:@[self.demoModel] cellIdentifier:@"XPMoodBasicCell" cellConfigureBlock:^(XPMoodBasicCell  *_Nonnull cell, YWDynamicModel  *_Nonnull model) {
//        XPMoodCellLayout *layout = [[XPMoodCellLayout alloc] initWithDynamicModel:self.demoModel];
//        [cell configureCellWithModel:model layout:layout];
//    }];
//    self.tableView.dataSource = self.tableViewDataSource;
    
//    [YWDynamicModel requestDynamicModelsWithPage:1 pageSize:10 success:^(NSArray<YWDynamicModel *> * _Nonnull models, YWNetworkResultModel * _Nonnull obj) {
//
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
    
    [self _demoData];
}

#pragma mark - Private

- (void)_registerCellClasses {
    
    [self.tableView registerClass:XPMoodBasicCell.class forCellReuseIdentifier:@"XPMoodBasicCell"];
    [self.tableView registerClass:XPMoodNineImageCell.class forCellReuseIdentifier:@"XPMoodNineImageCell"];
    
}

- (void)_demoData {
    
    
   NSArray *attachments = @[@"https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=8000a165df1b0ef473e89e5eedc551a1/b151f8198618367afe76969623738bd4b21ce5fa.jpg", @"https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=8000a165df1b0ef473e89e5eedc551a1/b151f8198618367afe76969623738bd4b21ce5fa.jpg", @"https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a284ee4bc595d143c576e22343f18296/0b7b02087bf40ad182fac5ab5a2c11dfa9ecce58.jpg", @"https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=8000a165df1b0ef473e89e5eedc551a1/b151f8198618367afe76969623738bd4b21ce5fa.jpg", @"https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=8000a165df1b0ef473e89e5eedc551a1/b151f8198618367afe76969623738bd4b21ce5fa.jpg", @"https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=8000a165df1b0ef473e89e5eedc551a1/b151f8198618367afe76969623738bd4b21ce5fa.jpg", @"https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a284ee4bc595d143c576e22343f18296/0b7b02087bf40ad182fac5ab5a2c11dfa9ecce58.jpg", @"https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=8000a165df1b0ef473e89e5eedc551a1/b151f8198618367afe76969623738bd4b21ce5fa.jpg", @"https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a284ee4bc595d143c576e22343f18296/0b7b02087bf40ad182fac5ab5a2c11dfa9ecce58.jpg"];
    
    YWDynamicModel *demoModel = [YWDynamicModel new];
    demoModel.content = @"A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!";
    demoModel.username = @"LiBingbing";
    demoModel.add_time = @"2018-12-07 15:27:16";
    
    YWDynamicModel *demoModel1 = [YWDynamicModel new];
    demoModel1.content = @"A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!";
    demoModel1.username = @"LiBingbing";
    demoModel1.add_time = @"2018-12-07 15:27:16";
    demoModel1.attachments = [attachments.mutableCopy subarrayWithRange:NSMakeRange(0, 1)];
    
    YWDynamicModel *demoModel2 = [YWDynamicModel new];
    demoModel2.content = @"A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!";
    demoModel2.username = @"LiBingbing";
    demoModel2.add_time = @"2018-12-07 15:27:16";
    demoModel2.attachments = [attachments.mutableCopy subarrayWithRange:NSMakeRange(0, 2)];
    
    YWDynamicModel *demoModel3 = [YWDynamicModel new];
    demoModel3.content = @"A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!";
    demoModel3.username = @"LiBingbing";
    demoModel3.add_time = @"2018-12-07 15:27:16";
    demoModel3.attachments = [attachments.mutableCopy subarrayWithRange:NSMakeRange(0, 3)];
    
    YWDynamicModel *demoModel4 = [YWDynamicModel new];
    demoModel4.content = @"A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!";
    demoModel4.username = @"LiBingbing";
    demoModel4.add_time = @"2018-12-07 15:27:16";
    demoModel4.attachments = [attachments.mutableCopy subarrayWithRange:NSMakeRange(0, 4)];
    
    YWDynamicModel *demoModel5 = [YWDynamicModel new];
    demoModel5.content = @"A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!";
    demoModel5.username = @"LiBingbing";
    demoModel5.add_time = @"2018-12-07 15:27:16";
    demoModel5.attachments = [attachments.mutableCopy subarrayWithRange:NSMakeRange(0, 5)];
    
    YWDynamicModel *demoModel6 = [YWDynamicModel new];
    demoModel6.content = @"A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!";
    demoModel6.username = @"LiBingbing";
    demoModel6.add_time = @"2018-12-07 15:27:16";
    demoModel6.attachments = [attachments.mutableCopy subarrayWithRange:NSMakeRange(0, 6)];
    
    YWDynamicModel *demoModel7 = [YWDynamicModel new];
    demoModel7.content = @"A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!";
    demoModel7.username = @"LiBingbing";
    demoModel7.add_time = @"2018-12-07 15:27:16";
    demoModel7.attachments = [attachments.mutableCopy subarrayWithRange:NSMakeRange(0, 7)];
    
    YWDynamicModel *demoModel8 = [YWDynamicModel new];
    demoModel8.content = @"A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!";
    demoModel8.username = @"LiBingbing";
    demoModel8.add_time = @"2018-12-07 15:27:16";
    demoModel8.attachments = [attachments.mutableCopy subarrayWithRange:NSMakeRange(0, 8)];
    
    YWDynamicModel *demoModel9 = [YWDynamicModel new];
    demoModel9.content = @"A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!A huge thanks to everyone who went to theaters and gave support to The Meg. Number 1 in the world!!!!";
    demoModel9.username = @"LiBingbing";
    demoModel9.add_time = @"2018-12-07 15:27:16";
    demoModel9.attachments = attachments;
    
    self.models = @[demoModel, demoModel1, demoModel2, demoModel3, demoModel4, demoModel5, demoModel6, demoModel7, demoModel8, demoModel9, demoModel9];
}

- (YWDynamicModel *)modelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.models.count) {
        return self.models[indexPath.row];
    }
    
    return nil;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWDynamicModel *model = [self modelAtIndexPath:indexPath];
    switch (model.kind) {
        case YWDynamicModelKindText: {
            XPMoodBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPMoodBasicCell"];
            return cell;
            break;
        }
        case YWDynamicModelKindImage: {
            XPMoodNineImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPMoodNineImageCell" forIndexPath:indexPath];
            cell.imageCellDelegate = self;
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)aCell forRowAtIndexPath:(NSIndexPath *)indexPath {
    YWDynamicModel *model = [self modelAtIndexPath:indexPath];
    XPMoodCellLayout *layout = [[XPMoodCellLayout alloc] initWithDynamicModel:model];
    switch (model.kind) {
        case YWDynamicModelKindText: {
            XPMoodBasicCell *cell = (XPMoodBasicCell *)aCell;
            [cell configureCellWithModel:model layout:layout];
            break;
        }
       
        case YWDynamicModelKindImage: {
            XPMoodNineImageCell *cell = (XPMoodNineImageCell *)aCell;
            [cell configureCellWithModel:model layout:layout];
            break;
        }
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWDynamicModel *model = [self modelAtIndexPath:indexPath];
    XPMoodCellLayout *layout = [[XPMoodCellLayout alloc] initWithDynamicModel:model];
    return layout.height;
}

#pragma mark - XPMoodImageCellDelegate

- (void)moodImageCell:(XPMoodNineImageCell *)cell index:(NSInteger)index image:(UIImage *)image attachments:(NSArray<NSString *> *)attachments {
    
}

#pragma mark - Public

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Discover" bundle:nil] instantiateViewControllerWithIdentifier:@"XPMoodViewController"];
}

@end
