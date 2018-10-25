//
//  ContactViewController.m
//  english
//
//  Created by zhangkai on 2018/10/22.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "ContactViewController.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>

@interface ContactViewController ()

@property (nonatomic, assign) IBOutlet UITextView *contentTf;
@property (nonatomic, assign) IBOutlet UIButton *submitBtn;
@property (nonatomic, assign) IBOutlet UIButton *callBtn;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentTf.layer.cornerRadius = 5;
    self.contentTf.layer.masksToBounds = NO;
    self.contentTf.placeholder = @"请输入你的意见和建设";
    self.contentTf.textContainerInset = UIEdgeInsetsMake( 10, 5, 10, 5);

    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.shadowOffset = CGSizeMake(0, 5);
    self.submitBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.submitBtn.layer.shadowOpacity = 0.3;
    self.submitBtn.layer.masksToBounds = NO;
}

- (IBAction)submit:(id)sender {
    NSString *content = self.contentTf.text;
    if(content.length < 5){
        [self alert:@"反馈意见不能少于5个字符"];
        return;
    }
    NSString *user_id = @"";
    if(mAppDelegate._userInfo){
        user_id = mAppDelegate._userInfo[@"id"];
    }
    [self show:@"正在提交..."];
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:POST_MESSAGE_URL params:@{
                                                    @"user_id" : user_id,
                                                    @"content" :content
                                                    } callback:^(NSDictionary *data) {
                                                        [weakSelf dismiss];
                                                       
                                                        if([data[@"code"] integerValue] == 1){
                                                            [weakSelf alert:@"提交成功" callback:^{
                                                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                                            }];
                                                        } else {
                                                             [weakSelf alert:@"提交失败，请重试"];
                                                        }
                                                        
    }];
}

- (IBAction)call:(id)sender {
    NSLog(@"tel://15926287915");
    @try {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"tel://15926287915"]];
    }@catch(NSException *error){
        [self alert:@"不支持模拟器"];
    }
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
