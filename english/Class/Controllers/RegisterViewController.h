//
//  RegisterViewController.h
//  english
//
//  Created by zhangkai on 2018/10/13.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BaseInnerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : BaseInnerViewController

@property (nonatomic, assign) IBOutlet UIView *userView;
@property (nonatomic, assign) IBOutlet UIView *codeView;
@property (nonatomic, assign) IBOutlet UIView *passwordView;


@property (nonatomic, assign) IBOutlet UITextField *userTf;
@property (nonatomic, assign) IBOutlet UITextField *codeTf;
@property (nonatomic, assign) IBOutlet UITextField *passwordTf;

@property (nonatomic, assign) IBOutlet UIButton *submitBtn;
@property (nonatomic, assign) IBOutlet UIButton *codeBtn;

@end

NS_ASSUME_NONNULL_END
