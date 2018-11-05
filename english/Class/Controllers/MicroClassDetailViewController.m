//
//  MicroClassDetailViewController.m
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "MicroClassDetailViewController.h"
#import <WebKit/WebKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface MicroClassDetailViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *newsWebView;

@property (nonatomic, assign) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) IBOutlet UIView *wrapperWebView;

@property (nonatomic, assign) IBOutlet UIView *header2View;
@property (nonatomic, assign) IBOutlet UIView *quickView;

@property (nonatomic, assign) IBOutlet UILabel *title2Lbl;
@property (nonatomic, assign) IBOutlet UILabel *numLbl;
@property (nonatomic, assign) IBOutlet UILabel *priceLbl;


@property (nonatomic, assign) IBOutlet UIView *playerView;
@property (nonatomic, assign) IBOutlet UIImageView *coverImageView;

@property (strong,nonatomic) AVPlayer *player;
@property (strong,nonatomic) AVPlayerItem *item;

@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, assign) BOOL isFullScreen;
@property (strong,nonatomic) AVPlayerViewController *moviePlayer;

@property (nonatomic, assign) IBOutlet UIView *titleView;

@end

@implementation MicroClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.newsWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.newsWebView.UIDelegate = self;
    self.newsWebView.navigationDelegate = self;
    [self.wrapperWebView addSubview:self.newsWebView];
    
    [self.newsWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.newsWebView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wrapperWebView.mas_top);
        make.centerX.equalTo(self.wrapperWebView.mas_centerX);
        make.width.equalTo(@(self.view.frame.size.width - 20));
        make.height.equalTo(self.wrapperWebView.mas_height);
    }];
    self.newsWebView.scrollView.scrollEnabled = NO;
    self.newsWebView.scrollView.bounces = NO;
    
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

- (void)setCoverUrl:(NSString *)coverUrl {
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString: coverUrl]
                           placeholderImage:[UIImage imageNamed:@"ic_player_error.png"]];
}

- (IBAction)play:(id)sender {
    
    if(!mAppDelegate._userInfo){
        [self performSegueWithIdentifier:@"login" sender:nil];
        return;
    }
    if([mAppDelegate._userInfo[@"vip"] integerValue] != 1){
        return;
    }
    self.item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString: self.videoUrl]];
    
    self.player = [AVPlayer playerWithPlayerItem: self.item];
    self.moviePlayer = [[AVPlayerViewController alloc] init];
    self.moviePlayer.player = self.player;
    self.moviePlayer.view.frame = self.playerView.bounds;
    self.moviePlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.moviePlayer addObserver:self forKeyPath:@"videoBounds" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerView addSubview:self.moviePlayer.view];
    [self.moviePlayer.player play];
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];

}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)loadData {
    NSString *htmlString = [NSString stringWithFormat:@"<b style='color:red'>%@</b>人已购买", self.info[@"user_num"]];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.numLbl.attributedText = attrStr;
    
    NSString *htmlString2 = [NSString stringWithFormat:@"<b style=\"color:red\">永久会员 ¥%@</b>&nbsp;&nbsp;&nbsp;<b style=\"color: #999;text-decoration:line-through;\">原价:¥%@</b>", self.info[@"pay_price"], self.info[@"price"]];
    NSAttributedString * attrStr2 = [[NSAttributedString alloc] initWithData:[htmlString2 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.priceLbl.attributedText = attrStr2;
    
    self.title2Lbl.text = self.info[@"title"];
    [self setCoverUrl:self.info[@"img"]];
    
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:NEWS_INFO_URL params:@{@"news_id": self.info[@"id"] } callback:^(NSDictionary *data) {
        if(weakSelf.scrollView.mj_header){
            [weakSelf.scrollView.mj_header endRefreshing];
        }
        if([data[@"code"] integerValue] == 1){
            NSString *body = [data[@"data"][@"info"][@"body"] stringByReplacingOccurrencesOfString:@"&tp=webp" withString:@""];
            [weakSelf.newsWebView loadHTMLString:body baseURL:nil];
            [weakSelf setVideoUrl:data[@"data"][@"info"][@"url"]];
            
            if(weakSelf.scrollView.mj_header){
                [weakSelf.scrollView.mj_header removeFromSuperview];
                weakSelf.scrollView.mj_header = nil;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.header2View.hidden = NO;
            self.wrapperWebView.hidden = NO;
            self.quickView.hidden = NO;
            self.titleView.hidden = NO;
        });
    }];
}

#pragma mark - WKWebView
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat contentHeight = self.newsWebView.scrollView.contentSize.height;
        if(contentHeight > 300){
            contentHeight = 256;
        }
        [self.wrapperWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(contentHeight));
        }];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, HEIGHT(self.header2View) + contentHeight +  self.quickView.frame.size.height + HEIGHT(self.titleView));
        return;
    }
    if ([keyPath isEqualToString:@"videoBounds"]){
        CGRect newRect = [change[NSKeyValueChangeNewKey] CGRectValue];
        if(newRect.size.height > 250){
            self.isFullScreen = YES;
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        } else {
            self.isFullScreen = NO;
        }
    }
}

- (void)dealloc {
    [self.newsWebView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    [self.player pause];
    [self.moviePlayer.view removeFromSuperview];
    [self.moviePlayer removeObserver:self forKeyPath:@"videoBounds"];
    self.item = nil;
    self.player = nil;
    self.moviePlayer.player = nil;
    self.moviePlayer = nil;
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
