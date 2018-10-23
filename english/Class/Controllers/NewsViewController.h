//
//  NewsViewController.h
//  english
//
//  Created by zhangkai on 2018/10/15.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BaseInnerViewController.h"
#import "NewsType.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsViewController : BaseInnerViewController

@property (nonatomic, assign) IBOutlet UITableView *newsTableView;

@property (nonatomic, strong)  NewsType *newsType;

@end

NS_ASSUME_NONNULL_END
