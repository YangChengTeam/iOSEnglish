//
//  CacheUtils.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/23.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "CacheHelper.h"
#import <YYCache/YYCache.h>

#define CURRENT_USER_KEY @"current_user_key"


@interface CacheHelper()

@property (nonatomic, strong) YYDiskCache *diskCache;

@end

@implementation CacheHelper

static CacheHelper* instance = nil;

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    instance.diskCache = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:@"english"]];
    return instance;
}


- (void)setCurrentUser:(NSDictionary *)user {
    [self.diskCache setObject:user forKey:CURRENT_USER_KEY];
}

- (NSDictionary *)getCurrentUser {
    return (NSDictionary *)[self.diskCache objectForKey:CURRENT_USER_KEY];
}


@end
