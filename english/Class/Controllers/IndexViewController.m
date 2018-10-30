//
//  IndexViewController.m
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexHeaderTableViewCell.h"
#import "NewsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import <UShareUI/UShareUI.h>
#import "NewsType.h"
#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "BooksViewController.h"

@interface IndexViewController ()<UITableViewDelegate, UITableViewDataSource,  IndexHeaderTableViewCellDelegate>

@end

@implementation IndexViewController {
    NSArray *_dataSource;
    NSDictionary *_hotInfo;
}

static NSString *headerViewIdentifier=@"headerViewIdentifier";
static NSString *newsViewIdentifier=@"newsViewIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    mAppDelegate._userInfo = [[CacheHelper shareInstance] getCurrentUser];
   
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logined:)
                                                 name:kNotiLoginSuccess
                                               object:nil];
    
    // tableiView 初始设置
    self.indexTableView.delegate = self;
    self.indexTableView.dataSource = self;
    self.indexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.indexTableView registerNib:[UINib nibWithNibName:@"IndexHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:headerViewIdentifier];
    [self.indexTableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:newsViewIdentifier];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf loadData];
    }];
    normalHeader.stateLabel.hidden = YES;
    normalHeader.lastUpdatedTimeLabel.hidden = YES;
    self.indexTableView.mj_header = normalHeader;
    [self.indexTableView.mj_header beginRefreshing];
    
    // 加载数据
    [self logined:nil];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderWidth = 0;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}


- (void)loadData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = nil;
    if(mAppDelegate._userInfo){
        params = @{@"user_id" : mAppDelegate._userInfo[@"id"]};
    }
    [NetUtils postWithUrl:INDEX_URL params:params callback:^(NSDictionary * data) {
        if([data[@"code"] integerValue] == 1){
            if(!weakSelf.indexTableView.tableFooterView){
                UIView *view = [UIView new];
                view.backgroundColor = [UIColor clearColor];
                weakSelf.indexTableView.tableFooterView = view;
            }
            weakSelf.indexTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self->_dataSource = [NSArray arrayWithArray:data[@"data"][@"tuijian"]];
            mAppDelegate._dataSource = self->_dataSource;
            self->_hotInfo = data[@"data"][@"redian"][0];
            [weakSelf.indexTableView reloadData];
        }
        if(weakSelf.indexTableView.mj_header){
            [weakSelf.indexTableView.mj_header endRefreshing];
        }
    }];
}

- (void)logined:(NSNotification *)notify {
   if(mAppDelegate._userInfo) {
        [self.avatarImageView sd_setImageWithURL:mAppDelegate._userInfo[@"face"]];
   } else {
       self.avatarImageView.image = [UIImage imageNamed:@"default_avatar.png"];
   }
}

- (IBAction)share:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareWebPageToPlatformType: platformType];
    }];
}

- (IBAction)tab2avatar:(id)sender {
    self.navigationController.tabBarController.selectedIndex = 2;
}

- (void)nav2microClass:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"microClass" sender:nil];
}

- (void)nav2hotNews:(id)sender {
    NewsType *newsType = [NewsType new];
    newsType.title = @"今日热点";
    newsType.type = 3;
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"news" sender:newsType];
}

- (void)nav2newsDetail:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"newsDetail" sender:_hotInfo];
}

- (void)nav2topNews:(id)sender {
    NewsType *newsType = [NewsType new];
    newsType.title = @"爱学习";
    newsType.type = 0;
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"news" sender:newsType];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", sender);
    if([segue.identifier isEqualToString:@"news"]){
        NewsViewController  *newsViewController = (NewsViewController *)segue.destinationViewController;
        newsViewController.newsType = sender;
    } else if([segue.identifier isEqualToString:@"newsDetail"]){
        NewsDetailViewController  *newsDetailViewController = (NewsDetailViewController *)segue.destinationViewController;
        newsDetailViewController.info = sender;
    } else if([segue.identifier isEqualToString:@"books"]){
        BooksViewController  *booksViewController = (BooksViewController *)segue.destinationViewController;
        booksViewController.title = sender;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *identifier = newsViewIdentifier;
    if(row == 0){
        identifier = headerViewIdentifier;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    cell.backgroundColor = [UIColor clearColor];
    if(row != 0){
        NSDictionary *info = _dataSource[row-1];
        NewsTableViewCell *newsCell =  (NewsTableViewCell *)cell;
        newsCell.backgroundColor = [UIColor whiteColor];
        newsCell.titleLabel.text = info[@"title"];
        newsCell.timeLabel.text = [self getDateStringWithTimeStr:info[@"add_time"]];
        [newsCell.newsImageView sd_setImageWithURL:[NSURL URLWithString:info[@"img"]]
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        if(row == _dataSource.count){
            newsCell.separatorInset = UIEdgeInsetsMake(0, newsCell.bounds.size.width, 0, 0);
        } else {
            newsCell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        }
    } else {
        IndexHeaderTableViewCell *headerCell =  (IndexHeaderTableViewCell *)cell;
        [headerCell.hotTitleBtn setTitle:_hotInfo[@"title"] forState:UIControlStateNormal];
        NSLog(@"%@", _hotInfo[@"title"]);
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        headerCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        headerCell.delegate = self;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self->_dataSource ? self->_dataSource.count + 1 : 0;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 70;
    if(indexPath.row == 0){
        if(isRetina || isPhone5){
            height = 287;
        } else {
            height = 307;
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if(row != 0){
        NSDictionary *info = self->_dataSource[row - 1];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"newsDetail" sender:info];
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
