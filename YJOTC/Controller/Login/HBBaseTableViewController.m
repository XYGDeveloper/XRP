//
//  HBBaseTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"
#import "HBLoginTableViewController.h"

@interface HBBaseTableViewController ()

@end

@implementation HBBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initBackButton];

    self.tableView.backgroundColor = kWhiteColor;
    [self initBackButton];
}
-(void)initBackButton
{
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.hidesBackButton = YES;
    }else{
        [self addLeftBarButtonWithImage:kImageFromStr(@"fanhui_icon") action:@selector(backAction)];
    }
}

-(void)showTips:(NSString *)msg
{
    
    if (msg == nil || msg.length == 0) {
        return;
    }
    
    //mbprogress
    [self.view showWarning:msg];
    
}

//返回事件
-(void)backAction
{
    if (self.navigationController.viewControllers.count == 1) {
        kDismiss;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)gotoLoginVC
{
    UIViewController *vc = [HBLoginTableViewController fromStoryboard];
    [self presentViewController:vc animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)setStatusBarColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

@end
