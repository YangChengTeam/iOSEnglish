//
//  NewsDetailViewController.m
//  english
//
//  Created by zhangkai on 2018/10/15.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <UShareUI/UShareUI.h>
#import <MJRefresh/MJRefresh.h>
#import "YBImageBrowser.h"
#import "NewsType.h"
#import "NewsTableViewCell.h"
#import "NewsDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <WebKit/WebKit.h>


@interface NewsDetailViewController ()<UIScrollViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, YBImageBrowserDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WKWebView *newsWebView;

@property (nonatomic, assign) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) IBOutlet UIButton *shareBtn;

@property (nonatomic, assign) IBOutlet UIView *sampleView;

@property (nonatomic, assign) IBOutlet UILabel *title2Lbl;
@property (nonatomic, assign) IBOutlet UILabel *sourceLbl;
@property (nonatomic, assign) IBOutlet UILabel *timeLbl;

@property (nonatomic, assign) IBOutlet UIView *wrapperWebView;

@property (nonatomic, assign) IBOutlet UIView *quickView;
@property (nonatomic, assign) IBOutlet UIView *topContentView;

@property (nonatomic, assign) IBOutlet UITableView *topTableView;




@end

@implementation NewsDetailViewController {
    NSMutableArray *_imgurls;
    NSArray *_dataSource;
}

static NSString *newsViewIdentifier=@"newsViewIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = mAppDelegate._dataSource;
    
    self.scrollView.delegate = self;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    config.processPool = [[WKProcessPool alloc] init];
    
    
    self.newsWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.newsWebView.UIDelegate = self;
    self.newsWebView.navigationDelegate = self;
    [self.wrapperWebView addSubview:self.newsWebView];
    
    [config.userContentController addScriptMessageHandler:self name:@"previewImage"];
    [config.userContentController addScriptMessageHandler:self name:@"getImages"];
    
    [self.newsWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.newsWebView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wrapperWebView.mas_top);
        make.centerX.equalTo(self.wrapperWebView.mas_centerX);
        make.width.equalTo(@(self.view.frame.size.width - 20));
        make.height.equalTo(self.wrapperWebView.mas_height);
    }];
    self.newsWebView.scrollView.scrollEnabled = NO;
    self.newsWebView.scrollView.bounces = NO;
    
    // tableiView 初始设置
    self.topTableView.delegate = self;
    self.topTableView.dataSource = self;
    self.topTableView.scrollEnabled = NO;
    self.topTableView.bounces = NO;
    [self.topTableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:newsViewIdentifier];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.topTableView.tableFooterView = view;
    self.topTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf loadData];
    }];
    normalHeader.stateLabel.hidden = YES;
    normalHeader.lastUpdatedTimeLabel.hidden = YES;
    self.scrollView.mj_header = normalHeader;
    [self.scrollView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (NSUInteger)yb_numberOfCellForImageBrowserView:(YBImageBrowserView *)imageBrowserView {
    return _imgurls ? _imgurls.count : 0;
}

- (id<YBImageBrowserCellDataProtocol>)yb_imageBrowserView:(YBImageBrowserView *)imageBrowserView dataForCellAtIndex:(NSUInteger)index {
    YBImageBrowseCellData *data = [YBImageBrowseCellData new];
    data.url = _imgurls[index];
    data.sourceObject = _imgurls[index];
    return data;
}


- (void)loadData {
    self.titleLbl.text = self.info[@"title"];
    self.title2Lbl.text = self.info[@"title"];
    self.sourceLbl.text = [NSString stringWithFormat:@"来自于: %@", self.info[@"author"]];
    self.timeLbl.text = [self getDateStringWithTimeStr:self.info[@"add_time"]];
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:NEWS_INFO_URL params:@{@"news_id": self.info[@"id"] } callback:^(NSDictionary *data) {
        if(weakSelf.scrollView.mj_header){
            [weakSelf.scrollView.mj_header endRefreshing];
        }
        if([data[@"code"] integerValue] == 1){
            NSString *body = [data[@"data"][@"info"][@"body"] stringByReplacingOccurrencesOfString:@"&tp=webp" withString:@""];
            [weakSelf.newsWebView loadHTMLString:body baseURL:nil];
            if(weakSelf.scrollView.mj_header){
                [weakSelf.scrollView.mj_header removeFromSuperview];
                weakSelf.scrollView.mj_header = nil;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.sampleView.hidden = NO;
            self.wrapperWebView.hidden = NO;
            self.quickView.hidden = NO;
            self.topContentView.hidden = NO;
        });
    }];
}



- (IBAction)share:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareWebPageToPlatformType: platformType];
    }];
}

#pragma mark - TableView
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
    if(row == _dataSource.count - 1){
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsDetailViewController *newsDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"newsDetail"];
    newsDetailViewController.info = info;
    [self.navigationController pushViewController:newsDetailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - WKWebView
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@";imgs=[];for(i=0;i<document.images.length;i++){;imgs.push(document.images[i].src);document.images[i].addEventListener(\"click\",function(){window.webkit.messageHandlers.previewImage.postMessage(this.src)})}window.webkit.messageHandlers.getImages.postMessage(imgs)" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat contentHeight = self.newsWebView.scrollView.contentSize.height;
        [self.wrapperWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(contentHeight));
        }];
        
        [self.topTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(70*self->_dataSource.count));
        }];
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, contentHeight + self.sampleView.frame.size.height+HEIGHT(self.quickView) + 70*self->_dataSource.count+50);
        
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if([message.name isEqualToString:@"previewImage"]){
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSource = self;
        browser.currentIndex = [_imgurls  indexOfObject:message.body];
        [browser show];
    } else if([message.name isEqualToString:@"getImages"]){
        if([message.body isKindOfClass:[NSArray class]]){
            _imgurls = [NSMutableArray arrayWithArray:message.body];
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.mj_offsetY > 70){
        self.titleLbl.hidden = NO;
    } else {
        self.titleLbl.hidden = YES;
    }
}

- (void)dealloc {
    [self.newsWebView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
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
