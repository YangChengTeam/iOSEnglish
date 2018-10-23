//
//  ShareInfo.m
//  english
//
//  Created by zhangkai on 2018/10/13.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "ShareInfo.h"

@implementation ShareInfo

- (instancetype)init {
    if([super init]){
        self.title = @"说说英语APP上线啦！随时随地想学就学";
        self.url = @"http://mp.weixin.qq.com/s/JepGpluow-Zf6VhI0wMJEA";
        self.desp = @"说说英语自营首款APP学英语软件上线了，涵盖市面所有主流英语教材，配套各种版本教科书（完全免费），让你随时随地就能通过手机打开书本，进行学习，单词记忆。还有各种趣味方式助你学英语。";
    }
    return self;
}

@end
