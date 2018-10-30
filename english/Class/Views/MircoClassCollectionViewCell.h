//
//  MircoClassCollectionViewCell.h
//  english
//
//  Created by zhangkai on 2018/10/30.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MircoClassCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) IBOutlet UIImageView *photoImageView;
@property (nonatomic, assign) IBOutlet UILabel *titleLbl;
@property (nonatomic, assign) IBOutlet UILabel *unitCountLbl;

@end

NS_ASSUME_NONNULL_END
