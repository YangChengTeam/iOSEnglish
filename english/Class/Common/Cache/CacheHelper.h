//
//  CacheUtils.h
//  leqisdk
//
//  Created by zhangkai on 2018/1/23.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MAIN_KEY @"main_key"


@interface CacheHelper : NSObject

+ (_Nullable instancetype)shareInstance;

- (void)setCurrentUser:(NSDictionary *)user;
- (NSMutableDictionary *)getCurrentUser;

- (void)setUserName:(NSString *)username;
- (NSString *)getUserName;

- (void)setGrade:(NSString *)grade;
- (NSString *)getGrade;

@end
