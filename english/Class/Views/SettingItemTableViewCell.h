//
//  SettingItemTableViewCell.h
//  english
//
//  Created by zhangkai on 2018/10/18.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SettingItemTableViewCellDelegate <NSObject>

- (void)itemClick:(id)sender;
- (void)itemClick2:(id)sender;

@end


@interface SettingItemTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIView  *itemView;
@property (nonatomic, assign) IBOutlet UIView  *item1View;
@property (nonatomic, assign) IBOutlet UIView  *item2View;

@property (nonatomic, assign) IBOutlet UIButton *item1Btn;
@property (nonatomic, assign) IBOutlet UIImageView *iconImageView;
@property (nonatomic, assign) IBOutlet UILabel *titleLbl;

@property (nonatomic, assign) IBOutlet UIButton *item2Btn;
@property (nonatomic, assign) IBOutlet UIImageView *iconImageView2;
@property (nonatomic, assign) IBOutlet UILabel *titleLbl2;

@property (nonatomic, assign) id<SettingItemTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
