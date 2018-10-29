//
//  VipViewController.m
//  english
//
//  Created by zhangkai on 2018/10/22.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "VipViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VipViewController ()

@property (nonatomic, assign) IBOutlet UILabel *usernameLbl;
@property (nonatomic, assign) IBOutlet UIImageView *avatarImageView;

@property (nonatomic, assign) IBOutlet UIImageView *vipTagImageView;
@property (nonatomic, assign) IBOutlet UILabel *vipTagLbl;

@end

@implementation VipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderWidth = 0;
    
    self.vipDespLabel.text = @"1、会员即开即用，有些机型 购买会员后，需退出软件重新启动方能使用会员功能。\n2、会员使用起始日以购买为准。\n3、会员一经购买不能退费" ;
    
    self.usernameLbl.text = mAppDelegate._userInfo[@"nick_name"];
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:mAppDelegate._userInfo[@"face"]]
                            placeholderImage:[UIImage imageNamed:@"default_big_avatar"]];
    
    
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
