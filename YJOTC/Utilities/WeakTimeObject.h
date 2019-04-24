//
//  WeakTimeObject.h
//  timer
//
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakTimeObject : NSObject

+ (NSTimer *)weakScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)sel userInfo:(id)userInfo repeats:(BOOL)isRepeats;

@end
