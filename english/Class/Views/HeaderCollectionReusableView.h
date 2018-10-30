//
//  HeaderCollectionReusableView.h
//  english
//
//  Created by zhangkai on 2018/10/30.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) IBOutlet UILabel *titleLbl;

- (void)setTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
