//
//  BookContentsViewController.m
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BookContentsViewController.h"
#import "ModuleTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "BookHeaderTableViewCell.h"

@interface BookContentsViewController ()


@property (nonatomic, assign) IBOutlet UITableView *moduleTableView;

@end

@implementation BookContentsViewController {
     NSArray *_dataSource;
     NSDictionary *_bookInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.moduleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.moduleTableView registerNib:[UINib nibWithNibName:@"ModuleTableViewCell" bundle:nil] forCellReuseIdentifier:moduleIdentifier];
    [self.moduleTableView registerNib:[UINib nibWithNibName:@"BookHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:bookHeaderIdentifier];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.moduleTableView.tableFooterView = view;
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf loadData];
    }];
    normalHeader.stateLabel.hidden = YES;
    normalHeader.lastUpdatedTimeLabel.hidden = YES;
    self.moduleTableView.mj_header = normalHeader;
    [self.moduleTableView.mj_header beginRefreshing];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:BOOK_INFO_URL params:@{
                                             @"book_id": _info[@"book_id"]
                                             } callback:^(NSDictionary * data) {
                                                 [weakSelf.moduleTableView.mj_header endRefreshing];
                                                 if([data[@"code"] integerValue] == 1){
                                                     self->_bookInfo = data[@"data"][@"info"];
                                                     
            
        }                                     
    }];
    
    [NetUtils postWithUrl:WORD_UNIT_LIST_URL params:@{
                                                      @"current_page": @(1),
                                                 @"book_id": _info[@"book_id"]
                                                 } callback:^(NSDictionary * data) {
                                                     [weakSelf.moduleTableView.mj_header endRefreshing];
                                                     if([data[@"code"] integerValue] == 1){
                                                         self->_dataSource = data[@"data"][@"list"];
                                                         [weakSelf.moduleTableView reloadData];
                                                         
                                                     }
                                                 }];
}

static NSString *moduleIdentifier = @"moduleIdentifier";
static NSString *bookHeaderIdentifier = @"bookHeaderIdentifier";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *identifier = bookHeaderIdentifier;
    if(row != 0){
        identifier = moduleIdentifier;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(row != 0){
        NSDictionary *info = _dataSource[row-1];
        ModuleTableViewCell *moduleCell =  (ModuleTableViewCell *)cell;
        moduleCell.moduleLbl.text = info[@"name"];
        moduleCell.sentenceCountLbl.text = [NSString stringWithFormat:@"%@句",  info[@"sentence_count"]];
    } else {
        NSLog(@"%@", _bookInfo);
        BookHeaderTableViewCell *bookHeaderCell =  (BookHeaderTableViewCell *)cell;
        [bookHeaderCell.photoImageView sd_setImageWithURL:[NSURL URLWithString:_info[@"cover_img"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        if(_bookInfo){
            bookHeaderCell.nameLbl.text = _bookInfo[@"name"];
            bookHeaderCell.versionLbl.text = _bookInfo[@"press"];
            bookHeaderCell.moduleNumLbl.text = [NSString stringWithFormat:@"%@句", _bookInfo[@"sentence_count"]];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self->_dataSource ? self->_dataSource.count  : 0;
    if(_bookInfo){
        count += 1;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 80;
    if(indexPath.row == 0){
        height = 146;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSDictionary *info = self->_dataSource[row-1];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"bookDetail" sender:info];
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
