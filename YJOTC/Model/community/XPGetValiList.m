//
//  XPGetValiList.m
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPGetValiList.h"
#import "XPGetValiModel.h"
@interface XPGetValiList()
@property (nonatomic,strong)NSString *key;
@property (nonatomic,strong)NSString *token_id;
@end
@implementation XPGetValiList

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
    NSDictionary *params = @{
                             @"key":self.key ?: @"",
                             @"token_id":self.token_id ?: @"",
                             };
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{
                             @"key":self.key ?: @"",
                             @"token_id":self.token_id ?: @"",
                             };
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/api/BossPlan/active_step_list");
    return command;
}

- (id)reformData:(id)responseObject {
    XPGetValiModel *model = [XPGetValiModel mj_objectWithKeyValues:responseObject];
    return model;
}

@end
