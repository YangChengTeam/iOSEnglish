//
//  LoginViewController.h
//  english
//
//  Created by zhangkai on 2018/10/13.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BaseInnerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : BaseInnerViewController

@property (nonatomic, assign) IBOutlet UIView *userView;
@property (nonatomic, assign) IBOutlet UIView *passwordView;

@property (nonatomic, assign) IBOutlet UIButton *loginBtn;

@property (nonatomic, assign) IBOutlet UITextField *userTf;
@property (nonatomic, assign) IBOutlet UITextField *passwordTf;

@property (nonatomic, assign) IBOutlet UIButton *forgotBtn;
@property (nonatomic, assign) IBOutlet UIButton *registerBtn;


@end

NS_ASSUME_NONNULL_END
