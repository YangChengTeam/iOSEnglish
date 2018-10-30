//
//  HeaderCollectionReusableView.m
//  english
//
//  Created by zhangkai on 2018/10/30.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title {
    self.titleLbl.text = title;
}

@end
