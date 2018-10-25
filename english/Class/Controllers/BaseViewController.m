//
//  BaseViewController.m
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareInfo.h"
#import <WechatOpenSDK/WxApi.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromHex(0xE6F1FB);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSInteger height = 64;
    if(isPhoneX){
        height = 88;
    }
    [self.headerView  mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
}

- (void)alert:(NSString *)message callback:(void (^)(void))finishcallback {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:message                                    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(finishcallback){
            finishcallback();
        }
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alert:(NSString *)message {
    [self alert:message callback:^{
        
    }
     ];
}

- (void)show:(NSString *)message {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.font = [UIFont systemFontOfSize: 14];
    self.hud.label.text = message;
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(weakSelf.hud){
                [weakSelf.hud hideAnimated:YES];
            }
        });
    });
}

- (void)dismiss:(void (^)(void))callback {
    __weak typeof(self) weakSelf = self;
   dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        if(callback){
            callback();
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(weakSelf.hud){
                [weakSelf.hud hideAnimated:YES];
                weakSelf.hud = nil;
            }
        });
    });
}

- (void)dismiss {
    [self dismiss:nil];
}


// 转换时间戳
- (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time= [str doubleValue];
    NSDate *detailDate= [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    __weak typeof(self) weakSelf = self;
    [weakSelf show:@""];
    [NetUtils postWithUrl:SHARE_URL params:nil
                 callback:^(NSDictionary *data) {
                     [weakSelf dismiss];
                     if([data[@"code"] integerValue] == 1){
                         ShareInfo *shareInfo = [ShareInfo yy_modelWithDictionary:data[@"data"][@"info"]];
                         UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

                         UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareInfo.title descr:shareInfo.desp thumImage:[UIImage imageNamed:@"AppIcon"]];
                         shareObject.webpageUrl = shareInfo.url;
                         messageObject.shareObject = shareObject;
                         [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                             if (error) {
                                 [weakSelf.view makeToast:@"分享失败" duration:2.0     position:CSToastPositionCenter];
                             } else{
                                 [weakSelf.view makeToast:@"分享成功" duration:2.0     position:CSToastPositionCenter];
                             }
                         }];
                     }
                 }];
}

- (IBAction)nav2word:(id)sender {
    NSString *title = @"单词宝典";
    [self performSegueWithIdentifier:@"books" sender:title];
}

- (IBAction)nav2task:(id)sender {
    [self nav2miniapp:@"gh_5732adc868b8"];
}

- (IBAction)nav2tool:(id)sender {
    [self nav2miniapp:@"gh_8aa3ea375bde"];
}

- (IBAction)nav2phonetic:(id)sender {
    [self nav2miniapp:@"gh_e46e21f44c08"];
}

- (void)nav2miniapp:(NSString *)userName {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.path = @"pages/index/index";
    launchMiniProgramReq.type = 0;
    launchMiniProgramReq.userName = userName;
    [WXApi sendReq:launchMiniProgramReq];
}

- (IBAction)nav2read:(id)sender {
    NSString *title = @"课本点读";
    [self performSegueWithIdentifier:@"books" sender:title];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
