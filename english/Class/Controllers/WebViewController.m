//
//  WebViewController.m
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import <MJRefresh/MJRefresh.h>


@interface WebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.userContentController = [[WKUserContentController alloc] init];
    config.processPool = [[WKProcessPool alloc] init];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    __weak typeof(self) weakSelf = self;
    [self.webView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.width.equalTo(weakSelf.headerView.mas_width);
        make.bottom.equalTo(weakSelf.mas_bottomLayoutGuide);
    }];
    
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf loadData];
    }];
    normalHeader.stateLabel.hidden = YES;
    normalHeader.lastUpdatedTimeLabel.hidden = YES;
    self.webView.scrollView.mj_header = normalHeader;
    [self.webView.scrollView.mj_header beginRefreshing];
    
    [self loadData];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:MENU_ADV_URL params:nil
                 callback:^(NSDictionary *data) {
                     if([data[@"code"] integerValue] == 1){
                         NSString *url = [NSString stringWithFormat:@"%@?t=%@", data[@"data"][@"info"][@"url"], data[@"add_time"][@"info"][@"url"]];
                         [weakSelf.webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                     }
                     if(weakSelf.webView.scrollView.mj_header){
                         [weakSelf.webView.scrollView.mj_header endRefreshing];
                     }
                 }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView.scrollView.mj_header endRefreshing];
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
