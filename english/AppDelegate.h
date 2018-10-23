//
//  AppDelegate.h
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSArray *_dataSource;  //新闻推荐
@property (strong, nonatomic) NSDictionary *_userInfo;
@end

