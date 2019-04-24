//
//  XPGetFridendListApi.m
//  YJOTC
//
//  Created by l on 2019/1/5.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPGetFridendListApi.h"
#import "XPFridendModel.h"
@interface XPGetFridendListApi()
@property (nonatomic,strong)NSString *key;
@property (nonatomic,strong)NSString *token_id;
@end

@implementation XPGetFridendListApi

- (instancetype)initWithKey:(NSString *)token
                   token_id:(NSString *)token_id
{
    self = [super init];
    if (self) {
        self.key = token;
        self.token_id = token_id;
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
                             @"language":lang ?: @"zh-tw",
                             };
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/api/account/my_friend_list");
    return command;
}

- (id)reformData:(id)responseObject {
    XPFridendModel *model = [XPFridendModel mj_objectWithKeyValues:responseObject];
    return model;
}
@end
