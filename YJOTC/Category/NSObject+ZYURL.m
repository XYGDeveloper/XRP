//
//  NSObject+ZYURL.m
//  ywshop
//
//  Creat
//

#import "NSObject+ZYURL.h"

@implementation NSObject (ZYURL)

- (NSURL *)ks_URL {
    
    NSString *url = (NSString *)self;
    /******  网络url  ******/
    if ([url containsString:@"http://"] || [url containsString:@"https://"]) {
        return [NSURL URLWithString:url];
    }
    /******  文件url  ******/
    return [NSURL fileURLWithPath:url];
}

@end
