//
//  AppDelegate+ZY.h
//  jys
//
//  Copyright © 2017年 前海数交所. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (ZY)

-(void)initIQKeyboard;

- (void)networkDidLogin:(NSNotification *)notification;

//- (void)configShareSDK;

-(void)successPay;

-(void)failedPay;

-(void)cancelPay;

-(void)autoLoginAction;

//-(void)EMLoginAction;

//- (void)add3DTouchItems:(UIApplication *)application;

@end
