//
//  BaseViewController.h
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <UShareUI/UShareUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, assign) IBOutlet UIView *headerView;

@property (nonatomic, strong) MBProgressHUD *hud;

- (void)alert:(NSString *)message callback:(void (^)(void))finishcallback;
- (void)alert:(NSString *)message;

- (void)show:(NSString *)message;
- (void)dismiss:(void (^)(void))callback;
- (void)dismiss;

- (NSString *)getDateStringWithTimeStr:(NSString *)str;
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType;

- (void)nav2miniapp:(NSString *)userName;


- (void)countdown:(UIButton *)codeBtn;

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
