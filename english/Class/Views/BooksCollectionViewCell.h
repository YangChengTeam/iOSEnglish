//
//  BooksCollectionViewCell.h
//  english
//
//  Created by zhangkai on 2018/11/2.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BooksCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) IBOutlet UIImageView *photoImageView;

@property (nonatomic, assign) IBOutlet UILabel *titleLbl;
@property (nonatomic, assign) IBOutlet UILabel *gradeLbl;
@property (nonatomic, assign) IBOutlet UIButton *delBtn;


@end

NS_ASSUME_NONNULL_END
