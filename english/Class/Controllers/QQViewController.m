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

- (IBAction)qq1:(id)sender {
    [self joinQQGroup: @"-KHOf9yt4Cifr9VNSOM7PUs9u41ssG9_"];
}

- (IBAction)qq2:(id)sender {
    [self joinQQGroup: @"_3srBJmmySTC6K7ct-heNvasSGoB9T4M"];
}

- (void)joinQQGroup:(NSString *)key {
    NSLog(@"%@", key);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqqopensdkapi://bizAgent/qm/qr?url=http://qm.qq.com/cgi-bin/qm/qr?from=app&p=android&k=%@", key]];
    @try {
        [[UIApplication sharedApplication] openURL: url];
    }@catch(NSException *error){
        [self alert:@"请安装QQ"];
    }
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
