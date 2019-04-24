//
//  YWDynamicModel.m
//  ywshop
//
//  Created by 周勇 on 2017/10/26.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWDynamicModel.h"

@interface YWDynamicModel ()

//@property (nonatomic, assign, readwrite) YWDynamicModelKind kind;

@end

@implementation YWDynamicModel

- (YWDynamicModelKind)kind {
    
   return self.attachments.count > 0 ? YWDynamicModelKindImage :  YWDynamicModelKindText;
    
//    return [self.attachments count];
}

- (NSInteger)numberOfImages {
    return [self.attachments count];
}

@end
