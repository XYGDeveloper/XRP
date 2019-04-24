//
//  UpdateVersionManager.h
//  UUC
//
//  Created by Roy on 2018/11/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UpdateVersionManager : NSObject

+ (instancetype)sharedUpdate;

- (void)versionControl;

@end


