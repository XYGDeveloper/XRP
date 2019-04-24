//
//  XPGetLogListApi.m
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPGetLogListApi.h"
#import "XPGetLogModel.h"
@interface XPGetLogListApi()
@property (nonatomic,strong)NSString *key;
@property (nonatomic,strong)NSString *token_id;
@property (nonatomic,strong)NSString *type;

@end

@implementation XPGetLogListApi
//
- (instancetype)initWithKey:(NSString *)token token_id:(NSString *)token_id type:(NSString *)type{
    self = [super init];
    if (self) {
        self.key = token;
        self.token_id = token_id;
        self.type = type;
    }
    return self;
}

- (void)refresh {
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else{//泰文
        lang = @"zh-tw";
    }
    NSDictionary *params = @{
                             @"key":self.key ?: @"",
                             @"token_id":self.token_id ?: @"",
                             @"type":self.type ?: @"",
                             @"language":lang ?: @"zh-tw",
                             };
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else{//泰文
        lang = @"zh-tw";
    }
    NSDictionary *params = @{
                             @"key":self.key ?: @"",
                             @"token_id":self.token_id ?: @"",
                             @"type":self.type ?: @"",
                             @"language":lang ?: @"zh-tw",
                             };
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/api/boss/bouns_log");
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *array = [XPGetLogModel mj_objectArrayWithKeyValuesArray:responseObject];
    return array;
}

@end
