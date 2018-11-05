//
//  NameCollectionViewCell.m
//  english
//
//  Created by zhangkai on 2018/11/2.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "NameCollectionViewCell.h"

@implementation NameCollectionViewCell


- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameBtn.layer.borderWidth = 1.0f;
    self.nameBtn.layer.cornerRadius = 14;
    
    _nameBtn.frame = self.contentView.bounds;
    _nameBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _nameBtn.titleLabel.numberOfLines = 1;
    _nameBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _nameBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

@end
