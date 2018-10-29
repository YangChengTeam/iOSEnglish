//
//  ModifyFieldViewController.m
//  english
//
//  Created by zhangkai on 2018/10/25.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "ModifyFieldViewController.h"
#import "AFNetworking/AFNetworking.h"

@interface ModifyFieldViewController ()

@end

@implementation ModifyFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.shadowOffset = CGSizeMake(0, 5);
    self.submitBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.submitBtn.layer.shadowOpacity = 0.3;
    self.submitBtn.layer.masksToBounds = NO;
    
    self.titleLbl.text = self.info[@"title"];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 20)];
    self.fieldTF.leftView = paddingView;
    self.fieldTF.leftViewMode = UITextFieldViewModeAlways;
    
    if([self.info[@"type"] isEqualToString:@"0"]){
        self.fieldTF.text = mAppDelegate._userInfo[@"nick_name"];
    } else if([self.info[@"type"] isEqualToString:@"1"]){
       self.fieldTF.text = mAppDelegate._userInfo[@"school"];
    }
    
}

- (IBAction)submit:(id)sender {
    NSString *textField = self.fieldTF.text;
    NSDictionary *params = nil;
    
    if([self.info[@"type"] isEqualToString:@"0"]){
        if(textField.length < 2){
            [self alert:@"姓名不能少于2个字符"];
            return;
        }
        params = @{
                   @"user_id": mAppDelegate._userInfo[@"id"],
                   @"face": @"",
                   @"nick_name": textField,
                   @"school": @""
                   };
    } else if([self.info[@"type"] isEqualToString:@"1"]){
        if(textField.length < 5){
            [self alert:@"学校不能少于5个字符"];
            return;
        }
        params = @{
                   @"user_id": mAppDelegate._userInfo[@"id"],
                   @"face": @"",
                   @"nick_name": @"",
                   @"school": textField
                   };
    }
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [self show:@"正在提交..."];
    [NetUtils postWithUrl:UPD_URL params:params callback:^(NSDictionary *data) {
        [weakSelf dismiss];
        if([data[@"code"] integerValue] == 1){
            [weakSelf alert:@"修改成功" callback:^{
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:mAppDelegate._userInfo];
                if([self.info[@"type"] isEqualToString:@"0"]){
                    userInfo[@"nick_name"] = textField;
                } else if([self.info[@"type"] isEqualToString:@"1"]){
                    userInfo[@"school"] = textField;
                }
                mAppDelegate._userInfo = userInfo;
                [[CacheHelper shareInstance] setCurrentUser:userInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLoginSuccess object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [weakSelf alert:data[@"msg"]];
        }
    } error:nil reqencryt:NO iszip:YES resencryt:YES];
    
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
