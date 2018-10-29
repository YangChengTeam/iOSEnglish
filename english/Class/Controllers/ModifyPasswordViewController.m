//
//  ModifyPasswordViewController.m
//  english
//
//  Created by zhangkai on 2018/10/25.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()

@property (nonatomic, assign) IBOutlet UITextField *oldPasswordTf;

@property (nonatomic, assign) IBOutlet UITextField *fnewPasswordTf;
@property (nonatomic, assign) IBOutlet UITextField *againPasswordTf;

@property (nonatomic, assign) IBOutlet UIButton *submitBtn;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.shadowOffset = CGSizeMake(0, 5);
    self.submitBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.submitBtn.layer.shadowOpacity = 0.3;
    self.submitBtn.layer.masksToBounds = NO;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 20)];
    self.oldPasswordTf.leftView = paddingView;
    self.oldPasswordTf.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 20)];
    self.fnewPasswordTf.leftView = paddingView2;
    self.fnewPasswordTf.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 20)];
    self.againPasswordTf.leftView = paddingView3;
    self.againPasswordTf.leftViewMode = UITextFieldViewModeAlways;
}

- (IBAction)submit:(id)sender {
    NSString *oldPass = self.oldPasswordTf.text;
    NSString *newPass = self.fnewPasswordTf.text;
    NSString *againPass = self.againPasswordTf.text;
    
    if(oldPass.length < 6 || newPass.length < 6 || againPass.length < 6){
        [self alert:@"密码长度不能少于6位"];
        return;
    }
    
    if(![newPass isEqualToString:againPass]){
        [self alert:@"两次输入密码不致"];
        return;
    }
    [self.view endEditing:YES];
    [self show:@"正在修改"];
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:UPD_PWD_URL params:@{
                                               @"user_id": mAppDelegate._userInfo[@"id"],
                                               @"pwd": oldPass,
                                               @"new_pwd": newPass
                                               } callback:^(NSDictionary *data) {
                                                   [weakSelf dismiss];
                                                   if([data[@"code"] integerValue] == 1){
                                                   NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:mAppDelegate._userInfo];
                                                   userInfo[@"pwd"] = newPass;
                                                   mAppDelegate._userInfo = userInfo;
                                                   [[CacheHelper shareInstance] setCurrentUser:userInfo];
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLoginSuccess object:nil];
                                                       [weakSelf alert:@"修改成功" callback:^{
                                                           [weakSelf.navigationController popViewControllerAnimated:YES];
                                                       }];
                                                
                                                   } else {
                                                       [self alert:data[@"msg"]];
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
