//
//  MyViewController.m
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "MyViewController.h"
#import "SettingHeaderTableViewCell.h"
#import "SettingItemTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import <UShareUI/UShareUI.h>
#import <STPopup/STPopup.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>


@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, SettingItemTableViewCellDelegate, SettingHeaderTableViewCellDelegate>

@property (nonatomic, assign) IBOutlet UITableView *settingTableView;


@end

static NSString *headerViewIdentifier=@"headerViewIdentifier";
static NSString *settingViewIdentifier=@"settingViewIdentifier";

@implementation MyViewController {
    NSArray *_dataSource;
    STPopupController *_popupController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logined:)
                                                 name:kNotiLoginSuccess
                                               object:nil];
    
    // tableiView 初始设置
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    self.settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.settingTableView.backgroundColor = UIColorFromHex(0xeeeeee);
    [self.settingTableView registerNib:[UINib nibWithNibName:@"SettingHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:headerViewIdentifier];
    [self.settingTableView registerNib:[UINib nibWithNibName:@"SettingItemTableViewCell" bundle:nil] forCellReuseIdentifier:settingViewIdentifier];
    
    self.settingTableView.bounces = NO;
    self.settingTableView.showsVerticalScrollIndicator = NO;
    
    _dataSource = @[@{@"icon": @"setting_vip", @"title":@"开通会员"},
                    @{@"icon": @"setting_order", @"title":@"我的订单"},
                    @{@"icon": @"setting_qq", @"title":@"小学/中学英语QQ交流群"},
                    @{@"icon": @"setting_wx", @"title":@"关注微信公众号"},
                    @{@"icon": @"setting_tel", @"title":@"在线客服"},
                    @{@"icon": @"setting_share", @"title":@"好友分享"},
                    @{@"icon": @"setting_market", @"title":@"应用市场点评有礼"},
                    @{@"icon": @"setting_setting", @"title":@"系统设置"}
                    ];
    
    
}

- (void)logined:(NSNotification *)notify {
    [self.settingTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *identifier = settingViewIdentifier;
    if(row == 0){
        identifier = headerViewIdentifier;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if(row != 0){
        SettingItemTableViewCell *settingCell = (SettingItemTableViewCell *)cell;
        NSDictionary *itemInfo = _dataSource[row*2 - 2];
        settingCell.titleLbl.text = itemInfo[@"title"];
        settingCell.iconImageView.image = [UIImage imageNamed:itemInfo[@"icon"]];
        settingCell.item1Btn.tag = row*2 - 2;
        settingCell.delegate = self;
        if(row < _dataSource.count){
            settingCell.item2Btn.tag = row*2 - 1;
            NSDictionary *itemInfo2 = _dataSource[row*2 - 1];
            settingCell.titleLbl2.text = itemInfo2[@"title"];
            settingCell.iconImageView2.image = [UIImage imageNamed:itemInfo2[@"icon"]];
        }
    } else {
         SettingHeaderTableViewCell *settingHeaderCell = (SettingHeaderTableViewCell *)cell;
        if(mAppDelegate._userInfo){
            NSLog(@"%@", mAppDelegate._userInfo);
            [settingHeaderCell.avatarImageView sd_setImageWithURL:mAppDelegate._userInfo[@"face"]];
            settingHeaderCell.nameLbl.text = mAppDelegate._userInfo[@"nick_name"];
        } else {
            settingHeaderCell.nameLbl.text = @"登录/注册";
            settingHeaderCell.avatarImageView.image = [UIImage imageNamed:@"default_big_avatar"];
        }
         settingHeaderCell.delegate = self;
    }
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self->_dataSource ? (self->_dataSource.count/2+(_dataSource.count%2?1:0)) + 1 : 0;
    return count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 101;
    if(indexPath.row == 0){
        if(isPhone5 || isRetina){
            height = 148;
        } else  {
            height = 160;
        }
    } else {
        if(isPhone5 || isRetina){
            height = 95;
        }
    }
    return height;
}

- (void)itemClick:(id)sender {
    NSInteger tag = ((UIButton*)sender).tag;
    switch (tag) {
        case 0:
            if(mAppDelegate._userInfo){
                if([mAppDelegate._userInfo[@"vip"] integerValue] == 1){
                    [self performSegueWithIdentifier:@"vip" sender:nil];
                } else {
                    
                }
            }else {
                [self performSegueWithIdentifier:@"login" sender:nil];
            }
            break;
        case 2: {
            UIViewController *qqViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"qq"];
            qqViewController.contentSizeInPopup = CGSizeMake(SCREEN_WIDTH - 120, 120);
            _popupController = [[STPopupController alloc] initWithRootViewController:qqViewController];
            _popupController.cornerRadius = 5.0f;
            [_popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(closePopup)]];
             _popupController.navigationBarHidden = YES;
            [_popupController presentInViewController:self];
        }
            break;
        case 4:
            [self performSegueWithIdentifier:@"contact" sender:nil];
            break;
        case 6: {
            NSURL * url = [NSURL URLWithString:@"http://itunes.apple.com/cn/app/id1438699431?mt=8"];
            if([[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }
        }
       break;
        default:
            break;
    }
}

- (void)closePopup {
    [_popupController dismiss];
}

- (void)itemClick2:(id)sender {
    NSInteger tag = ((UIButton*)sender).tag;
    __weak typeof(self) weakSelf = self;
    switch (tag) {
        case 1:{
            if(mAppDelegate._userInfo){
                [weakSelf performSegueWithIdentifier:@"orderRecord" sender:nil];
            }else{
                [weakSelf performSegueWithIdentifier:@"login" sender:nil];
            }
        }
            break;
        case 3:{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"关注公众号"
                                                                                     message:@"已复制微信号: 说说英语平台\n打开微信，搜索公众号在关注"                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:@"说说英语"];
                [weakSelf.view makeToast:@"复制成功, 正在前往微信" duration:2.0 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSURL * url = [NSURL URLWithString:@"weixin://"];
                    if([[UIApplication sharedApplication] canOpenURL:url]){
                        [[UIApplication sharedApplication] openURL:url];
                    }
                });
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {   
            }];
            [alertController addAction:action];
            [alertController addAction:action2];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        break;
        case 5: {
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                [weakSelf shareWebPageToPlatformType: platformType];
            }];
        }
        break;
        case 7:
            [weakSelf performSegueWithIdentifier:@"setting" sender:nil];
            break;
        default:
            break;
    }
}

- (void)login:(id)sender {
    if(mAppDelegate._userInfo){
        [self performSegueWithIdentifier:@"userInfo" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"login" sender:nil];
    }
}

- (void)learn:(id)sender {
    [self performSegueWithIdentifier:@"promotion" sender:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float height = isPhoneX ? 88.0  : 64.0;
    if(scrollView.mj_offsetY > height){
        self.headerView.alpha = 1;
    } else {
        self.headerView.alpha = scrollView.mj_offsetY / height;
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
