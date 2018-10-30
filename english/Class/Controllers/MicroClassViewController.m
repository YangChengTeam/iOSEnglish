//
//  MicroClassViewController.m
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "MicroClassViewController.h"
#import "MircoClassCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "MicroClassUnitViewController.h"
#import "HeaderCollectionReusableView.h"

@interface MicroClassViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) IBOutlet UICollectionView *collectionView;

@end

@implementation MicroClassViewController {
    NSMutableArray *_dataSource;
    NSInteger _page;
    NSInteger _pagesize;
    
    UILabel *_titleLbl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self->_page = 1;
    self->_pagesize = 20;
    
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
    self.collectionView.mj_header = normalHeader;
    [self.collectionView.mj_header beginRefreshing];

    MJRefreshAutoNormalFooter *normalAutoFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->_page++;
        [weakSelf loadData];
        [weakSelf.collectionView.mj_footer resetNoMoreData];
    }];
    [normalAutoFooter endRefreshing];
    normalAutoFooter.stateLabel.hidden = YES;
    normalAutoFooter.refreshingTitleHidden = YES;
    self.collectionView.mj_footer = normalAutoFooter;
    
    [self.collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
  
}



- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:WEIKE_CATEGORY_URL params:@{
                                            @"cate": @"1",
                                            @"top_list_type": @"1",
                                            @"type": @"8",
                                            @"page": @(_page),
                                            @"page_size": @(_pagesize)
                                            } callback:^(NSDictionary * data) {
                                                NSArray *list = nil;
                                                if([data[@"code"] integerValue] == 1){
                                                    list = [NSArray arrayWithArray:data[@"data"][@"list"]];
                                                    if(list && list.count > 0){
                                                        
                                                     
                                                        [self->_dataSource addObjectsFromArray:list];
                                                        
                                                        [weakSelf.collectionView reloadData];
                                                        NSLog(@"%@", [NSString stringWithFormat:@"已更新%@集", data[@"data"][@"count"]]);
                                                        self->_titleLbl.text = [NSString stringWithFormat:@"已更新%@集", data[@"data"][@"count"]];
                                                    }
                                                }
                                                
                                                if(self->_page == 1 && weakSelf.collectionView.mj_header){
                                                    [weakSelf.collectionView.mj_header endRefreshing];
                                                }
                                                
                                                if(weakSelf.collectionView.mj_footer){
                                                    if(!list || list.count < self->_pagesize){
                                                        ((MJRefreshAutoNormalFooter*)weakSelf.collectionView.mj_footer).stateLabel.hidden = NO;
                                                        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                                                    } else {
                                                        [weakSelf.collectionView.mj_footer endRefreshing];
                                                    }
                                                }
                                            }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource ? _dataSource.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *identifier = @"microClass";
    MircoClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    cell.titleLbl.text = _dataSource[indexPath.row][@"title"];
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource[indexPath.row][@"img"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    NSString * htmlString = [NSString stringWithFormat:@"总共<b style='color:red'>%@</b>单元", _dataSource[indexPath.row][@"unit_num"]];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    cell.unitCountLbl.attributedText = attrStr;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSDictionary *info = self->_dataSource[row];
    [self performSegueWithIdentifier:@"microClassUnit" sender:info];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", sender);
    if([segue.identifier isEqualToString:@"microClassUnit"]){
        MicroClassUnitViewController  *detailViewController = (MicroClassUnitViewController *)segue.destinationViewController;
        detailViewController.info = sender;
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头部视图
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        _titleLbl = [UILabel new];
        _titleLbl.textColor = [UIColor darkGrayColor];
        _titleLbl.font = [UIFont systemFontOfSize: 14];
        _titleLbl.textAlignment = NSTextAlignmentRight;
        _titleLbl.frame = CGRectMake(0, 0, self.view.bounds.size.width - 5, 20);
        [header addSubview:_titleLbl];
        return header;
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size= {self.view.bounds.size.width, 20};
    return size;
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
