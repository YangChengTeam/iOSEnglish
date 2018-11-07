//
//  WordDetailTableViewCell.h
//  english
//
//  Created by zhangkai on 2018/11/6.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WordDetailTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIView *rectView;
@property (nonatomic, assign) IBOutlet UIView *view2;

@property (nonatomic, assign) IBOutlet UIButton *playBtn;
@property (nonatomic, assign) IBOutlet UIButton *playBtn2;

@property (nonatomic, assign) IBOutlet UIImageView *audioImageView;
@property (nonatomic, assign) IBOutlet UIImageView *audioImageView2;


@property (nonatomic, assign) IBOutlet UILabel *numLbl;

@property (nonatomic, assign) IBOutlet UILabel *en1Lbl;
@property (nonatomic, assign) IBOutlet UILabel *cn1Lbl;

@property (nonatomic, assign) IBOutlet UILabel *en2Lbl;
@property (nonatomic, assign) IBOutlet UILabel *cn2Lbl;
@end

NS_ASSUME_NONNULL_END
