//
//  WordsHeaderCollectionReusableView.h
//  english
//
//  Created by zhangkai on 2018/11/6.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WordsHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) IBOutlet UIImageView *photoImageView;

@property (nonatomic, assign) IBOutlet UILabel *nameLbl;
@property (nonatomic, assign) IBOutlet UILabel *versionLbl;
@property (nonatomic, assign) IBOutlet UILabel *moduleNumLbl;

@end

NS_ASSUME_NONNULL_END
