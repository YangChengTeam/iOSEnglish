//
//  BookWordsViewController.m
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BookWordsViewController.h"
#import "BookWordsCollectionViewCell.h"
#import "BookWordDetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "WordsHeaderCollectionReusableView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BookWordsViewController ()

@property (nonatomic, assign) IBOutlet UICollectionView *wordsCollectionView;

@end

@implementation BookWordsViewController {
    NSArray *_dataSource;
    
    WordsHeaderCollectionReusableView *_headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf loadData];
    }];
    normalHeader.stateLabel.hidden = YES;
    normalHeader.lastUpdatedTimeLabel.hidden = YES;
    self.wordsCollectionView.mj_header = normalHeader;
    [self.wordsCollectionView.mj_header beginRefreshing];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    NSLog(@"%@", _info);
    [NetUtils postWithUrl:BOOK_INFO_URL params:@{
                                                 @"book_id": _info[@"book_id"]
                                                 } callback:^(NSDictionary * data) {
                                                     [weakSelf.wordsCollectionView.mj_header endRefreshing];
                                                     if([data[@"code"] integerValue] == 1){
                                                         NSDictionary *bookInfo = data[@"data"][@"info"];
                                                         
                                                         if(bookInfo){
                                                             self->_headerView.nameLbl.text = bookInfo[@"name"];
                                                             self->_headerView.versionLbl.text = bookInfo[@"press"];
                                                             self->_headerView.moduleNumLbl.text = [NSString stringWithFormat:@"%@个", bookInfo[@"word_count"]];
                                                         }
                                                         
                                                     }
                                                 }];
    
    [NetUtils postWithUrl:WORD_UNIT_LIST_URL params:@{
                                                      @"current_page": @(1),
                                                      @"book_id": _info[@"book_id"]
                                                      } callback:^(NSDictionary * data) {
                                                          [weakSelf.wordsCollectionView.mj_header endRefreshing];
                                                          if([data[@"code"] integerValue] == 1){
                                                              self->_dataSource = data[@"data"][@"list"];
                                                              [weakSelf.wordsCollectionView reloadData];
                                                              
                                                          }
                                                      }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource ? _dataSource.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *identifier = @"words";
    BookWordsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    NSDictionary *info = _dataSource[row];
    cell.nameLbl.text = info[@"simple_name"];
    cell.wordCountLbl.text = [NSString stringWithFormat:@"%@个单词", info[@"word_count"]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if(_headerView){
            _headerView.hidden = NO;
            return _headerView;
        }
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"wordsHeader" forIndexPath:indexPath];
        [_headerView.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.info[@"cover_img"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        reusableview = _headerView;
        _headerView.hidden = YES;
    }
    return reusableview;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSDictionary *info = self->_dataSource[row];
    [self performSegueWithIdentifier:@"wordsDetail" sender:info];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", sender);
    if([segue.identifier isEqualToString:@"wordsDetail"]){
        BookWordDetailViewController *contentsViewController = segue.destinationViewController;
        contentsViewController.info = sender;
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
