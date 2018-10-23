//
//  SettingViewController.m
//  english
//
//  Created by zhangkai on 2018/10/13.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "SettingViewController.h"
#import <SDWebImage/SDImageCache.h>

@interface SettingViewController ()

@property (nonatomic, assign) IBOutlet UIView *itemView;
@property (nonatomic, assign) IBOutlet UIButton *logoutBtn;
@property (nonatomic, assign) IBOutlet UILabel *cacheLbl;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(mAppDelegate._userInfo){
        self.logoutBtn.layer.cornerRadius = 5;
        self.logoutBtn.layer.shadowOffset = CGSizeMake(0, 5);
        self.logoutBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        self.logoutBtn.layer.shadowOpacity = 0.3;
        self.logoutBtn.layer.masksToBounds = NO;
    } else {
        self.logoutBtn.hidden = YES;
    }
    
    self.itemView.layer.cornerRadius = 5;
    self.itemView.layer.masksToBounds = NO;
    
    self.cacheLbl.text = [self getSize];
}

- (IBAction)logout:(id)sender {
    mAppDelegate._userInfo = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLoginSuccess object:nil];
    [[CacheHelper shareInstance] setCurrentUser:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getSize {
    NSUInteger tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *clearCacheName;
    if (tmpSize >= 1024*1024*1024) {
        clearCacheName = [NSString stringWithFormat:@"%0.2fG",tmpSize /(1024.f*1024.f*1024.f)];
    }else if (tmpSize >= 1024*1024) {
        clearCacheName = [NSString stringWithFormat:@"%0.2fM",tmpSize /(1024.f*1024.f)];
    }else{
        clearCacheName = [NSString stringWithFormat:@"%0.2fK",tmpSize / 1024.f];
    }
    return clearCacheName;
}

- (IBAction)clear:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        weakSelf.cacheLbl.text = @"0.00K";
        [weakSelf.view makeToast:@"清理成功" duration:1.0 position:CSToastPositionCenter];
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
