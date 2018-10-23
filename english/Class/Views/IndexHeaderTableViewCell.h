//
//  IndexHeaderTableViewCell.h
//  english
//
//  Created by zhangkai on 2018/10/12.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IndexHeaderTableViewCellDelegate <NSObject>

- (void)nav2hotNews:(id)sender;
- (void)nav2topNews:(id)sender;
- (void)nav2phonetic:(id)sender;
- (void)nav2read:(id)sender;
- (void)nav2word:(id)sender;
- (void)nav2microClass:(id)sender;
- (void)nav2task:(id)sender;
- (void)nav2tool:(id)sender;
- (void)nav2newsDetail:(id)sender;

@end

@interface IndexHeaderTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIView *menuView;
@property (nonatomic, assign) IBOutlet UIButton *hotTitleBtn;

@property (nonatomic, assign) IBOutlet UIButton *moreHotBtn;


@property (nonatomic, assign) IBOutlet UIButton *readBtn;
@property (nonatomic, assign) IBOutlet UIButton *phoneticBtn; //音标

@property (nonatomic, assign) IBOutlet UIButton *toolBtn;
@property (nonatomic, assign) IBOutlet UIButton *wordBtn;
@property (nonatomic, assign) IBOutlet UIButton *microClassBtn;
@property (nonatomic, assign) IBOutlet UIButton *taskBtn;

@property (nonatomic, assign) IBOutlet UIButton *moreTopBtn;

@property (nonatomic, assign) id<IndexHeaderTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
