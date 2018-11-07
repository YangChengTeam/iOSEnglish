//
//  BookWordDetailViewController.m
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BookWordDetailViewController.h"
#import <HVTableView/HVTableView.h>
#import "WordDetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>

@interface BookWordDetailViewController ()

@property (nonatomic, assign) IBOutlet HVTableView *detailTableView;

@property (nonatomic, assign) IBOutlet UIImageView *readLoopSelectedImageView;
@property (nonatomic, assign) IBOutlet UIView *processView;

@property (nonatomic, assign) IBOutlet UILabel *numLbl;

@property (nonatomic, assign) IBOutlet UIImageView *audioImageView;


@end
static NSString *wordDetailIdentifier = @"wordDetailIdentifier";
@implementation BookWordDetailViewController {
    NSArray *_dataSource;
    
    NSIndexPath *_currentPlayIndexPath;
    BOOL _isPlaying;
    NSInteger _count;
    BOOL isReadAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.detailTableView registerNib:[UINib nibWithNibName:@"WordDetailTableViewCell" bundle:nil] forCellReuseIdentifier:wordDetailIdentifier];
    
    self.titleLbl.text = _info[@"name"];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf loadData];
    }];
    normalHeader.stateLabel.hidden = YES;
    normalHeader.lastUpdatedTimeLabel.hidden = YES;
    self.detailTableView.mj_header = normalHeader;
    [self.detailTableView.mj_header beginRefreshing];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:WORD_LIST_URL params:@{
                                                 @"current_page": @(1),
                                                 @"page_count": @(100),
                                                 @"unit_id": _info[@"id"]
                                                 } callback:^(NSDictionary *data) {
                                                     [weakSelf.detailTableView.mj_header endRefreshing];
                                                     if([data[@"code"] integerValue] == 1){
                                                         self->_dataSource = data[@"data"][@"list"];
                                                         [weakSelf setCurrentNum:0]; [weakSelf.detailTableView reloadData];
                                                       
                                                     }
                                                 }];
}

- (void)setCurrentNum:(NSInteger)num {
    NSString *htmlString = [NSString stringWithFormat:@"当前朗读<b style=\"color:#59CCFE\">%ld</b>/%ld", num, self->_dataSource.count];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.numLbl.attributedText = attrStr;
}

#pragma mark HVTableViewDatasource
-(void)tableView:(UITableView *)tableView expandCell:(WordDetailTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    cell.rectView.hidden = NO;
    cell.view2.hidden = NO;
}

-(void)tableView:(UITableView *)tableView collapseCell:(WordDetailTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    cell.rectView.hidden = YES;
    cell.view2.hidden = YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count ? _dataSource.count : 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded
{
    
    WordDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: wordDetailIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *info = _dataSource[indexPath.row];
    cell.numLbl.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.en1Lbl.text = info[@"name"];
    cell.en2Lbl.text = info[@"ep_sentence"];
    
    cell.cn1Lbl.text = info[@"means"];
    cell.cn2Lbl.text = info[@"ep_sentence_means"];
    
    cell.playBtn.tag = indexPath.row;
    [cell.playBtn addTarget:self action:@selector(playWithCell:) forControlEvents:UIControlEventTouchUpInside];
    cell.playBtn2.tag = indexPath.row;
    [cell.playBtn2 addTarget:self action:@selector(playWithCell2:) forControlEvents:UIControlEventTouchUpInside];
    if(!isExpanded){
        cell.rectView.hidden = YES;
        cell.view2.hidden = YES;
    } else {
        cell.rectView.hidden = NO;
        cell.view2.hidden = NO;
    }
    return cell;
}



- (void)playWithCell:(UIButton *)btn {
    if(_isPlaying){
        [self.view makeToast:@"正在播放，请稍后" duration:2.0 position:CSToastPositionBottom];
        return;
    }
    _isPlaying = YES;
    [self playWithRow:btn.tag];
}


- (void)playWithRow:(NSInteger)tag {
    _isPlaying = YES;

    NSDictionary *info = _dataSource[tag];
    NSString *name = info[@"name"];
    _count = 1;
    [self text2speech:info[@"name"] rate:0.4];
    if(!self.readLoopSelectedImageView.hidden){
        _count += name.length;
        for(int i = 0; i <name.length;i++){
            [self text2speech: [name substringWithRange:NSMakeRange(i, 1)] rate:0.6];
        }
    }
    
    [self setCurrentNum: tag + 1];
    float width = (tag + 1) / (float)_dataSource.count * 240;
    [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    _currentPlayIndexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    WordDetailTableViewCell *cell= [self.detailTableView cellForRowAtIndexPath:_currentPlayIndexPath];
    cell.audioImageView.animationImages = [NSArray arrayWithObjects:
                                           [UIImage imageNamed:@"read_audio_gif_play1"],
                                           [UIImage imageNamed:@"read_audio_gif_play2"],
                                           [UIImage imageNamed:@"read_audio_gif_play3"],
                                           [UIImage imageNamed:@"read_audio_gif_play4"], nil];
    cell.audioImageView.animationDuration = 1.0f;
    cell.audioImageView.animationRepeatCount = 0;
    [cell.audioImageView startAnimating];
}

- (void)stopAll {
    _count = 0;
    _isPlaying = NO;
    WordDetailTableViewCell *cell= [self.detailTableView cellForRowAtIndexPath:_currentPlayIndexPath];
    cell.audioImageView.image = [UIImage imageNamed:@"read_word_default"];
    [cell.audioImageView stopAnimating];
    
    cell.audioImageView2.image = [UIImage imageNamed:@"read_word_audio"];
    [cell.audioImageView2 stopAnimating];
    
    self.audioImageView.image = [UIImage imageNamed:@"read_audio_white_stop"];
    [self.audioImageView stopAnimating];
    
    [self text2speechStop];
}


// 播放结束状态
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    _count --;
    if(_count <= 0){
        WordDetailTableViewCell *cell= [self.detailTableView cellForRowAtIndexPath:_currentPlayIndexPath];
        cell.audioImageView.image = [UIImage imageNamed:@"read_word_default"];
        [cell.audioImageView stopAnimating];
        
        cell.audioImageView2.image = [UIImage imageNamed:@"read_word_audio"];
        [cell.audioImageView2 stopAnimating];
        _isPlaying = NO;
        
        if(isReadAll && _dataSource.count == _currentPlayIndexPath.row+1){
            self.audioImageView.image = [UIImage imageNamed:@"read_audio_white_stop"];
            [self.audioImageView stopAnimating];
            isReadAll = NO;
            _currentPlayIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            return;
        }
        
        if(isReadAll){
            [self playWithRow:_currentPlayIndexPath.row+1];
        }
    }
}

// 跳出播放状态
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance {
    
}

- (void)playWithCell2:(UIButton *)btn {
    if(_isPlaying){
        [self.view makeToast:@"正在播放，请稍后" duration:2.0 position:CSToastPositionBottom];
        return;
    }
    _count = 1;
    _isPlaying = YES;
    NSDictionary *info = _dataSource[btn.tag];
    [self text2speech:info[@"ep_sentence"] rate:0.4];
     _currentPlayIndexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    WordDetailTableViewCell *cell= [self.detailTableView cellForRowAtIndexPath:_currentPlayIndexPath];
    cell.audioImageView2.animationImages = [NSArray arrayWithObjects:
                                           [UIImage imageNamed:@"read_audio_gif_play1"],
                                           [UIImage imageNamed:@"read_audio_gif_play2"],
                                           [UIImage imageNamed:@"read_audio_gif_play3"],
                                           [UIImage imageNamed:@"read_audio_gif_play4"], nil];
    cell.audioImageView2.animationDuration = 1.0f;
    cell.audioImageView2.animationRepeatCount = 0;
    [cell.audioImageView2 startAnimating];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded
{
    if (isExpanded)
        return 141;
    return 61;
}

- (IBAction)readAll:(id)sender {
    
    [self stopAll];
    if(isReadAll){
        isReadAll = NO;
        return;
    }
    isReadAll = YES;
    [self playWithRow:_currentPlayIndexPath.row];
    self.audioImageView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"read_audio_white_gif_play1"],
                                            [UIImage imageNamed:@"read_audio_white_gif_play2"],
                                            [UIImage imageNamed:@"read_audio_white_gif_play3"],
                                            [UIImage imageNamed:@"read_audio_white_gif_play4"], nil];
    self.audioImageView.animationDuration = 1.0f;
    self.audioImageView.animationRepeatCount = 0;
    [self.audioImageView startAnimating];
}

- (IBAction)readLoop:(id)sender {
    self.readLoopSelectedImageView.hidden =  !self.readLoopSelectedImageView.hidden;
}

- (IBAction)wordGame:(id)sender {
    [self alert:@"开发中..."];
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
