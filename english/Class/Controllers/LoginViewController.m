//
//  LoginViewController.m
//  english
//
//  Created by zhangkai on 2018/10/13.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

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
    
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.shadowOffset = CGSizeMake(0, 5);
    self.loginBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.loginBtn.layer.shadowOpacity = 0.3;
    self.loginBtn.layer.masksToBounds = NO;
    
    self.passwordTf.delegate = self;
    
}

- (IBAction)nav2login:(id)sender {
    [self login];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self login];
    return [textField resignFirstResponder];
}

- (void)login {
    NSString *username = self.userTf.text;
    NSString *password = self.passwordTf.text;
    if(username.length == 0 || password.length == 0){
        [self alert:@"手机号或密码不能为空"];
        return;
    }
    [self.view endEditing:YES];
    [self show:@"登录中..."];
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:LOGIN_URL params:@{
                                             @"user_name":username,
                                             @"pwd":password
                                             } callback:^(NSDictionary *data) {
                                                 [weakSelf dismiss];
                                                 if([data[@"code"] integerValue] == 1){
                                                     mAppDelegate._userInfo = data[@"data"][@"info"];
                                                     [[CacheHelper shareInstance] setCurrentUser:data[@"data"][@"info"]];
                                                [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLoginSuccess object:nil];
                                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                                 } else {
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
