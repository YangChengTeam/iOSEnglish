//
//  UserInfoViewController.m
//  english
//
//  Created by zhangkai on 2018/10/13.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@property (nonatomic, assign) IBOutlet UIView *avatarItemView;

@property (nonatomic, assign) IBOutlet UIView *gradeItemView;

@property (nonatomic, assign) IBOutlet UIView *phoneItemView;

@property (nonatomic, assign) IBOutlet UIView *passwordItemView;


@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.avatarItemView.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    self.avatarItemView.layer.mask = maskLayer;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.gradeItemView.bounds
                                                   byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.path = maskPath2.CGPath;
    self.gradeItemView.layer.mask = maskLayer2;
    
    
    UIBezierPath *maskPath3 = [UIBezierPath bezierPathWithRoundedRect:self.phoneItemView.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer3 = [[CAShapeLayer alloc] init];
    maskLayer3.path = maskPath3.CGPath;
    self.phoneItemView.layer.mask = maskLayer3;
    
    UIBezierPath *maskPath4 = [UIBezierPath bezierPathWithRoundedRect:self.passwordItemView.bounds
                                                    byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                                          cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer4 = [[CAShapeLayer alloc] init];
    maskLayer4.path = maskPath4.CGPath;
    self.passwordItemView.layer.mask = maskLayer4;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
