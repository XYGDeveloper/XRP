//
//  LocalizableLanguageManager.h
//  YJOTC
//
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CHINESESimlple @"zh-Hans"
#define CHINESETradition @"zh-Hant"
#define ENGLISH @"en"


#define LocalizedString(key) [[LocalizableLanguageManager bundle] localizedStringForKey:(key) value:@"" table:nil]
#define kLocat(key) LocalizedString(key)


@interface LocalizableLanguageManager : NSObject

+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言


-(void)resetRootViewController;

@end
