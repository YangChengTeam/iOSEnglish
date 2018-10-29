//
//  ModifyFieldViewController.h
//  english
//
//  Created by zhangkai on 2018/10/25.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BaseInnerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModifyFieldViewController : BaseInnerViewController

@property (nonatomic, assign) IBOutlet UITextField *fieldTF;
@property (nonatomic, assign) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong) NSDictionary *info;

@end

NS_ASSUME_NONNULL_END
