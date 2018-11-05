//
//  BooksViewController.m
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BooksViewController.h"
#import "BooksCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "BookSelectViewController.h"
#import "BookContentsViewController.h"


@interface BooksViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) IBOutlet UIView *contentView;
@property (nonatomic, assign) IBOutlet UIView *quickView;


@property (nonatomic, assign) IBOutlet UIButton *editBtn;
@property (nonatomic, assign) IBOutlet UICollectionView *collectionView;

@end

@implementation BooksViewController {
    NSMutableArray *_dataSource;
    NSString *_type;
    
    BOOL _isEdit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLbl.text = self.title;
    if([self.title isEqualToString:@"课本点读"]){
        _type = @"read";
    }
    else if([self.title isEqualToString:@"单词宝典"]){
        _type = @"word";
    }
    
    [self reload:nil];
    self.editBtn.layer.cornerRadius = 1.5;
    self.editBtn.layer.borderColor = UIColorFromHex(0x3BA9FF).CGColor;
    self.editBtn.layer.borderWidth = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:kNotiBook
                                               object:nil];
}

- (void)reload:(NSNotification *)notify {
    _dataSource = [[CacheHelper shareInstance] getBooksWithType:_type];
    if(_dataSource.count){
        [self.collectionView reloadData];
    }
    if(_dataSource.count == 0){
        self.editBtn.hidden = YES;
    } else {
        self.editBtn.hidden = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.contentView.layer.cornerRadius = 3;
    self.quickView.layer.cornerRadius = 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource ? _dataSource.count + 1 : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *identifier = @"books";
    BooksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if(row == 0){
        cell.titleLbl.hidden = YES;
        cell.gradeLbl.hidden = YES;
        cell.delBtn.hidden = YES;
        cell.photoImageView.image = [UIImage imageNamed:@"read_book_add"];
    } else {
        cell.titleLbl.hidden = NO;
        cell.gradeLbl.hidden = NO;
        cell.titleLbl.text = _dataSource[indexPath.row - 1][@"version_name"];
        cell.gradeLbl.text = _dataSource[indexPath.row - 1][@"grade_name"];
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource[indexPath.row - 1][@"cover_img"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        if(_isEdit){
            cell.delBtn.hidden = NO;
        } else {
            cell.delBtn.hidden = YES;
        }
        cell.delBtn.tag = indexPath.row - 1;
        [cell.delBtn addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (IBAction)edit:(id)sender {
    _isEdit = _isEdit ? NO : YES;
    if(_isEdit){
        self.editBtn.layer.cornerRadius = 1.5;
        self.editBtn.layer.borderWidth = 0;
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
        [self.editBtn setBackgroundColor:UIColorFromHex(0xFE908C)];
    }else {
        self.editBtn.layer.cornerRadius = 1.5;
        self.editBtn.layer.borderColor = UIColorFromHex(0x3BA9FF).CGColor;
        self.editBtn.layer.borderWidth = 1;
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:UIColorFromHex(0x3BA9FF) forState:UIControlStateNormal];
        [self.editBtn setBackgroundColor:UIColorFromHex(0xffffff)];
    }
    [self.collectionView reloadData];
}

- (void)del:(id)sender {
    NSInteger row = ((UIButton *)sender).tag;
    NSDictionary *info = _dataSource[row];
    [_dataSource removeObject:info];
    [[CacheHelper shareInstance] removeBook:info withType:_type];
    [self.collectionView reloadData];
    if(_dataSource.count == 0){
        [self edit:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(_isEdit) {
        return;
    }
    NSInteger row = indexPath.row;
    if(row == 0){
        [self performSegueWithIdentifier:@"bookSelect" sender:_type];
    } else {
        NSDictionary *info = self->_dataSource[row - 1];
        if([_type isEqualToString:@"read"]) {
            [self performSegueWithIdentifier:@"bookContents" sender:info];
        } else if([_type isEqualToString:@"word"]) {
            [self performSegueWithIdentifier:@"bookWords" sender:info];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", sender);
    if([segue.identifier isEqualToString:@"bookContents"]){
        BookContentsViewController *contentsViewController = segue.destinationViewController;
        contentsViewController.info = sender;
    } else if([segue.identifier isEqualToString:@"bookSelect"]){
        BookSelectViewController *contentsViewController = segue.destinationViewController;
        contentsViewController.type = sender;
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
