//
//  BookSelectViewController.m
//  english
//
//  Created by zhangkai on 2018/11/1.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BookSelectViewController.h"
#import "NameCollectionViewCell.h"
#import "BookWordsViewController.h"
#import "BookContentsViewController.h"

@interface BookSelectViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) IBOutlet UICollectionView *collectionView2;

@end

@implementation BookSelectViewController {
    NSArray *_dataSource;
    NSArray *_dataSource2;
    
    NSMutableArray *_cacheList;
    NSInteger _row;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _row = -1;
    // Do any additional setup after loading the view.
    
    _cacheList = [[NSMutableArray alloc] initWithArray:[[CacheHelper shareInstance] getBooksWithType:_type]];
    
    
    [self loadData];
    [self loadData2:@"" type:@""];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    
    [NetUtils postWithUrl:GRADE_LIST_URL params:nil callback:^(NSDictionary * data) {
                                                        NSArray *list = nil;
        
                                                        if([data[@"code"] integerValue] == 1){
                                                            list = [NSArray arrayWithArray:data[@"data"][@"list"]];
                                                            if(list && list.count > 0){
                                                                
                                                                self->_dataSource = list;
                                                                
                                                       
                                                                
                                                                [weakSelf.collectionView reloadData];
                                                            }
                                                        }
                                                        
        
                                                    }];
}


- (void)loadData2:(NSString *)grade type:(NSString *)type{
    __weak typeof(self) weakSelf = self;
    [self show:@"加载中..."];
    [NetUtils postWithUrl:COURSE_VERSION_LIST_URL params:@{
                                                           @"grade":grade,
                                                           @"part_type": type
                                                           } callback:^(NSDictionary * data) {
        [weakSelf dismiss];
                                                               NSArray *list = nil;
        if([data[@"code"] integerValue] == 1){
            list = [NSArray arrayWithArray:data[@"data"][@"list"]];
            if(list && list.count > 0){
                self->_dataSource2 = list;
                [weakSelf.collectionView2 reloadData];
            }
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([collectionView hash] == [_collectionView hash]){
        return _dataSource ? _dataSource.count : 0;
    }
    if([collectionView hash] == [_collectionView2 hash]){
        return _dataSource2 ? _dataSource2.count : 0;
    }
    return 0;
}
static NSString *identifier = @"grade";
static NSString *identifier2 = @"textbook";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *tmpIdentifier = identifier;
    NSInteger row = indexPath.row;
    NSDictionary *info = nil;
    NSString *titleName = nil;
    BOOL flag = NO;
    
    if([collectionView hash] == [_collectionView hash]){
        tmpIdentifier = identifier;
        info = _dataSource[row];
        titleName = @"name";
    }
    else if([collectionView hash] == [_collectionView2 hash]){
        tmpIdentifier = identifier2;
        info = _dataSource2[row];
        titleName = @"version_name";
        for(NSDictionary *tmpInfo in _cacheList) {
            if([info[@"book_id"] integerValue] == [tmpInfo[@"book_id"] integerValue]){
                flag = YES;
                break;
            }
        }
    }
    NameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tmpIdentifier forIndexPath:indexPath];
    cell.nameBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if([collectionView hash] == [_collectionView hash]){
        if(indexPath.row == _row){
            cell.nameBtn.layer.borderColor = UIColorFromHex(0xFE908C).CGColor;
        }
    } else {
        cell.nameBtn.tag = row;
        [cell.nameBtn addTarget:self action:@selector(nav2Detail:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(flag){
        cell.nameBtn.backgroundColor = [UIColor grayColor];
        [cell.nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        cell.nameBtn.backgroundColor = [UIColor whiteColor];
        [cell.nameBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [cell.nameBtn setTitle:info[titleName] forState:UIControlStateNormal];
    return cell;
}

- (void)nav2Detail:(id)sender {
    NSInteger row = ((UIButton *)sender).tag;
    NSDictionary *info = _dataSource2[row];
    NSString *identifierName = @"bookContents";
    if([_type isEqualToString:@"word"]){
        identifierName = @"bookWords";
    }
    ((UIButton *)sender).backgroundColor = [UIColor grayColor];
    [_cacheList addObject:info];
    [[CacheHelper shareInstance] setBook:info withType:_type];
    [self performSegueWithIdentifier:identifierName sender:info];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiBook object:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake((SCREEN_WIDTH - 92) / 4, 30);
    if([collectionView hash] == [_collectionView hash]){
        size = CGSizeMake((SCREEN_WIDTH - 92) / 4, 30);
    }
    else if([collectionView hash] == [_collectionView2 hash]){
        size = CGSizeMake((SCREEN_WIDTH - 72) / 3, 30);
    }
    return size;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", sender);
    if([segue.identifier isEqualToString:@"bookContents"]){
        BookContentsViewController *contentsViewController = segue.destinationViewController;
        contentsViewController.info = sender;
    } else if([segue.identifier isEqualToString:@"bookWords"]){
        BookWordsViewController *contentsViewController = segue.destinationViewController;
        contentsViewController.info = sender;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if([collectionView hash] == [_collectionView hash]){
        NSInteger row = indexPath.row;
        NSDictionary *info = _dataSource[row];
        _row = row;
        [collectionView reloadData];
        [self loadData2:info[@"grade"] type:info[@"part_type"]];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
   if([collectionView hash] == [_collectionView hash]){
       return YES;
   }
   return NO;
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
