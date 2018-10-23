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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
