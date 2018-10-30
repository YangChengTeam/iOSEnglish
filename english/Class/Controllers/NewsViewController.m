//
//  NewsViewController.m
//  english
//
//  Created by zhangkai on 2018/10/15.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "NewsDetailViewController.h"

@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation NewsViewController {
    NSMutableArray *_dataSource;
    NSInteger _page;
    NSInteger _pagesize;
}

static NSString *newsViewIdentifier=@"newsViewIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLbl.text = self.newsType.title;
    self->_page = 1;
    self->_pagesize = 20;
    // tableiView 初始设置
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.newsTableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:newsViewIdentifier];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.newsTableView.tableFooterView = view;
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        self->_page = 1;
        self->_dataSource = [NSMutableArray array];
        [weakSelf loadData];
    }];
    normalHeader.stateLabel.hidden = YES;
    normalHeader.lastUpdatedTimeLabel.hidden = YES;
    self.newsTableView.mj_header = normalHeader;
    [self.newsTableView.mj_header beginRefreshing];
    
    MJRefreshAutoNormalFooter *normalAutoFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->_page++;
        [weakSelf loadData];
        [weakSelf.newsTableView.mj_footer resetNoMoreData];
    }];
    [normalAutoFooter endRefreshing];
    normalAutoFooter.stateLabel.hidden = YES;
    normalAutoFooter.refreshingTitleHidden = YES;
    self.newsTableView.mj_footer = normalAutoFooter;
    
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:NEWS_URL params:@{
                                            @"type_id": @(self.newsType.type),
                                            @"flag": @(0),
                                            @"page": @(_page),
                                            @"page_size": @(_pagesize)
                                            } callback:^(NSDictionary * data) {
        NSArray *list = nil;
        if([data[@"code"] integerValue] == 1){
             list = [NSArray arrayWithArray:data[@"data"][@"list"]];
             if(list && list.count > 0){
                 
                  [self->_dataSource addObjectsFromArray:list];
                  weakSelf.newsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                  [weakSelf.newsTableView reloadData];
             }
        }
                                                
        if(self->_page == 1 && weakSelf.newsTableView.mj_header){
            [weakSelf.newsTableView.mj_header endRefreshing];
        }
                                                
        if(weakSelf.newsTableView.mj_footer){
            if(!list || list.count < self->_pagesize){
             ((MJRefreshAutoNormalFooter*)weakSelf.newsTableView.mj_footer).stateLabel.hidden = NO;
                [weakSelf.newsTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.newsTableView.mj_footer endRefreshing];
            }
        }
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", sender);
    if([segue.identifier isEqualToString:@"newsDetail"]){
        NewsDetailViewController  *newsDetailViewController = (NewsDetailViewController *)segue.destinationViewController;
        newsDetailViewController.info = sender;
    }
}


- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *identifier = newsViewIdentifier;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *info = _dataSource[row];
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
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self->_dataSource ? self->_dataSource.count : 0;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 70;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSDictionary *info = self->_dataSource[row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"newsDetail" sender:info];
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
