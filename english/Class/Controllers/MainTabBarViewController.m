//
//  MainTabBarViewController.m
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *items = self.tabBar.items;
    UITabBarItem *indexItem = items[0];
    indexItem.selectedImage = [[UIImage imageNamed:@"main_tab_index_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *onlineItem = items[1];
    onlineItem.selectedImage = [[UIImage imageNamed:@"main_tab_task_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *myItem = items[2];
    myItem.selectedImage = [[UIImage imageNamed:@"main_tab_my_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
   
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
