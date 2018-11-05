//
//  OrderRecordViewController.m
//  english
//
//  Created by zhangkai on 2018/10/13.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "OrderRecordViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "OrderRecordTableViewCell.h"

@interface OrderRecordViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) IBOutlet UITableView *orderRecordTableView;

@end

@implementation OrderRecordViewController {
    NSMutableArray *_dataSource;
    NSInteger _page;
    NSInteger _pagesize;
}

static NSString *orderRecordViewIdentifier=@"orderRecordViewIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self->_dataSource = [NSMutableArray array];
    self->_page = 1;
    self->_pagesize = 20;
    // tableiView 初始设置
    self.orderRecordTableView.delegate = self;
    self.orderRecordTableView.dataSource = self;
    self.orderRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.orderRecordTableView registerNib:[UINib nibWithNibName:@"OrderRecordTableViewCell" bundle:nil] forCellReuseIdentifier:orderRecordViewIdentifier];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.orderRecordTableView.tableFooterView = view;

    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        self->_page = 1;
        [weakSelf loadData];
    }];
    normalHeader.stateLabel.hidden = YES;
    normalHeader.lastUpdatedTimeLabel.hidden = YES;
    self.orderRecordTableView.mj_header = normalHeader;
    [self.orderRecordTableView.mj_header beginRefreshing];
    
    MJRefreshAutoNormalFooter *normalAutoFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->_page++;
        [weakSelf loadData];
        [weakSelf.orderRecordTableView.mj_footer resetNoMoreData];
    }];
    [normalAutoFooter endRefreshing];
    normalAutoFooter.stateLabel.hidden = YES;
    normalAutoFooter.refreshingTitleHidden = YES;
    self.orderRecordTableView.mj_footer = normalAutoFooter;
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:ORDER_RECORD_URL params:@{
                                            @"user_id": mAppDelegate._userInfo[@"id"],
                                            @"app_id": @(1),
                                            @"type": @(1),
                                            @"page": @(_page),
                                            @"limit": @(_pagesize)
                                            } callback:^(NSDictionary * data) {
                                                NSArray *list = nil;
                                                if([data[@"code"] integerValue] == 1){
                                                    list = [NSArray arrayWithArray:data[@"data"]];
                                                    if(list && list.count > 0){
                                                        weakSelf.orderRecordTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                                     
                                                        
                                                        [self->_dataSource addObjectsFromArray:list];
                                                        
                                                        [weakSelf.orderRecordTableView reloadData];
                                                    }
                                                }
                                                
                                                if(self->_page == 1 && weakSelf.orderRecordTableView.mj_header){
                                                    [weakSelf.orderRecordTableView.mj_header endRefreshing];
                                                }
                                                
                                        if(weakSelf.orderRecordTableView.mj_footer){
                                                    if(!list || list.count < self->_pagesize){
                                                        ((MJRefreshAutoNormalFooter*)weakSelf.orderRecordTableView.mj_footer).stateLabel.hidden = NO;
                                                        [weakSelf.orderRecordTableView.mj_footer endRefreshingWithNoMoreData];
                                                    } else {
                                                        [weakSelf.orderRecordTableView.mj_footer endRefreshing];
                                                    }
                                                }
                                            }];
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *identifier = orderRecordViewIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *info = _dataSource[row];
    OrderRecordTableViewCell *orderRecordCell =  (OrderRecordTableViewCell *)cell;
    
    orderRecordCell.orderNumLbl.text = [NSString stringWithFormat:@"订单号：%@", info[@"order_sn"]];
    orderRecordCell.timeLbl.text = info[@"add_time"];
    orderRecordCell.statusLbl.text = [NSString stringWithFormat:@"订单状态：%@", info[@"status"]];
    orderRecordCell.moneyLbl.text = [NSString stringWithFormat:@"¥%@", info[@"money"]];
    
    orderRecordCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self->_dataSource ? self->_dataSource.count : 0;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
