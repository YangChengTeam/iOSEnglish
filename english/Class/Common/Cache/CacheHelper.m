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
#define USER_NAME_KEY @"user_name_key"
#define GRADE_KEY @"grade_key"


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

- (void)setUserName:(NSString *)username {
    [self.diskCache setObject:username forKey:USER_NAME_KEY];
}

- (NSString *)getUserName {
    return (NSString *)[self.diskCache objectForKey:USER_NAME_KEY];
}

- (void)setGrade:(NSString *)grade {
    [self.diskCache setObject:grade forKey:GRADE_KEY];
}

- (NSString *)getGrade {
    return (NSString *)[self.diskCache objectForKey:GRADE_KEY];
}

@end
