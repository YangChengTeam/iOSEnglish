//
//  ModuleTableViewCell.h
//  english
//
//  Created by zhangkai on 2018/11/5.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModuleTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *moduleLbl;
@property (nonatomic, assign) IBOutlet UILabel *sentenceCountLbl;;

@end

NS_ASSUME_NONNULL_END
