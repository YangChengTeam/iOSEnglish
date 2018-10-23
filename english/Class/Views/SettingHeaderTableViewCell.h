//
//  SettingTableViewCell.h
//  english
//
//  Created by zhangkai on 2018/10/18.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SettingHeaderTableViewCellDelegate <NSObject>

- (void)login:(id)sender;

- (void)learn:(id)sender;

@end

@interface SettingHeaderTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, assign) IBOutlet UIButton *avatarBtn;

@property (nonatomic, assign) IBOutlet UILabel *nameLbl;
@property (nonatomic, assign) IBOutlet UIButton *learnBtn;

@property (nonatomic, assign) id<SettingHeaderTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
