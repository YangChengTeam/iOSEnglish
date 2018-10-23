//
//  NewsTableViewCell.h
//  english
//
//  Created by zhangkai on 2018/10/12.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIImageView *newsImageView;

@property (nonatomic, assign) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) IBOutlet UILabel *timeLabel;


@end

NS_ASSUME_NONNULL_END
