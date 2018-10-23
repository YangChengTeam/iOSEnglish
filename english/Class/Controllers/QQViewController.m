//
//  QQViewController.m
//  english
//
//  Created by zhangkai on 2018/10/22.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "QQViewController.h"

@interface QQViewController ()

@property (nonatomic, assign) IBOutlet UIView *item1View;
@property (nonatomic, assign) IBOutlet UIView *item2View;

@end

@implementation QQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.item1View.layer.cornerRadius = 8;
    self.item1View.layer.borderWidth = 1;
    self.item1View.layer.borderColor = UIColorFromHex(0xeeeeee).CGColor;
    
    self.item2View.layer.cornerRadius = 8;
    self.item2View.layer.borderWidth = 1;
    self.item2View.layer.borderColor = UIColorFromHex(0xeeeeee).CGColor;
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
