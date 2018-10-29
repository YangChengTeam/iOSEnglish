//
//  ForgotViewController.m
//  english
//
//  Created by zhangkai on 2018/10/22.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "ForgotViewController.h"

@interface ForgotViewController ()<UITextFieldDelegate>

@end

@implementation ForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userView.layer.borderColor = UIColorFromHex(0xeeeeee).CGColor;
    self.userView.layer.borderWidth = 1;
    self.userView.layer.cornerRadius = 2;
    
    self.passwordView.layer.borderColor = UIColorFromHex(0xeeeeee).CGColor;
    self.passwordView.layer.borderWidth = 1;
    self.passwordView.layer.cornerRadius = 2;
    
    self.codeView.layer.borderColor = UIColorFromHex(0xeeeeee).CGColor;
    self.codeView.layer.borderWidth = 1;
    self.codeView.layer.cornerRadius = 2;
    
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.shadowOffset = CGSizeMake(0, 5);
    self.submitBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.submitBtn.layer.shadowOpacity = 0.3;
    self.submitBtn.layer.masksToBounds = NO;
    
    self.passwordTf.delegate = self;
    
    NSString *username = [[CacheHelper shareInstance] getUserName];
    if(username){
        self.userTf.text = username;
    }
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(endInput:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (IBAction)sendCode:(id)sender {
    NSLog(@"%@", @"sendCode");
    
    NSString *username = self.userTf.text;
    if(username.length == 0 ){
        [self alert:@"手机号不能为空"];
        return;
    }
    [[CacheHelper shareInstance] setUserName:username];
    [self show:@"发送中..."];
    [self countdown: self.codeBtn];
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:FORGOT_SEND_CODE_URL params:@{
                                                          @"mobile":username
                                                          } callback:^(NSDictionary *data) {
                                                              [weakSelf dismiss];
                                                              if([data[@"code"] integerValue] == 1){
                                                                  [weakSelf.view makeToast:@"短信已成功发送，请注意查收" duration:2.0     position:CSToastPositionCenter];
                                                              } else {
                                                                  [weakSelf alert:data[@"msg"]];
                                                              }
                                                          }];
}

- (IBAction)submit:(id)sender {
    NSLog(@"%@", @"submit");
    
    NSString *username = self.userTf.text;
    NSString *password = self.passwordTf.text;
    NSString *code = self.codeTf.text;
    
    if(username.length == 0 ){
        [self alert:@"手机号不能为空"];
        return;
    }
    
    if(password.length == 0){
        [self alert:@"密码不能为空"];
        return;
    }
    
    if(code.length == 0){
        [self alert:@"验证不能为空"];
        return;
    }
    [self show:@"更改中..."];
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:FORGOT_URL params:@{
                                                @"mobile": username,
                                                @"pwd": password,
                                                @"code": code
                                                } callback:^(NSDictionary *data) {
                                                    [weakSelf dismiss];
                                                    if([data[@"code"] integerValue] == 1){
                                                        mAppDelegate._userInfo = data[@"data"][@"info"];
                                                        [[CacheHelper shareInstance] setCurrentUser:data[@"data"][@"info"]];
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLoginSuccess object:nil];
                                                        
                                                        [weakSelf alert:@"修改成功" callback:^{
                                                            [weakSelf.navigationController popViewControllerAnimated:YES];
                                                        }];
                                                    }else {
                                                        [weakSelf alert:data[@"msg"]];
                                                    }
                                                }];
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
