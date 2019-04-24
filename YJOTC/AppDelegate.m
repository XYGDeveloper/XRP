//
//  AppDelegate.m
//  YJOTC
//
//  com.qhszzc.YJOTC

#import "AppDelegate.h"
#import "YJTabBarController.h"
#import "AppDelegate+ZY.h"
#import "TPNewsDrawerController.h"
#import "UpdateVersionManager.h"



@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [LocalizableLanguageManager initUserLanguage];
    
    [LocalizableLanguageManager setUserlanguage:ENGLISH];
    if ([kUserDefaults boolForKey:@"isTradition"]) {
        [LocalizableLanguageManager setUserlanguage:CHINESETradition];
    }else{
        [LocalizableLanguageManager setUserlanguage:ENGLISH];
    }
    

    [self initIQKeyboard];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    
    YJTabBarController *tabVC = [[YJTabBarController alloc] init];
    
    self.window.rootViewController = tabVC;
    
    [self.window makeKeyAndVisible];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[UpdateVersionManager sharedUpdate] versionControl];
//    });
    
    return YES;
}

/**  强制使用系统键盘  */
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        return NO;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    UIViewController *vc = [kKeyWindow visibleViewController];
    
    if ([vc isKindOfClass:[TPNewsDrawerController class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kTPNewsDrawerControllerDidAppear" object:nil];
    }
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    if (self.isForceLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }else if (self.isForcePortrait){
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
