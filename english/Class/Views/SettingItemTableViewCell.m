//
//  SettingItemTableViewCell.m
//  english
//
//  Created by zhangkai on 2018/10/18.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "SettingItemTableViewCell.h"

@implementation SettingItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)layoutSubviews {
    if(isPhone5 || isRetina){
        [self.itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(300));
            make.height.equalTo(@(82.7));
        }];
        
        [@[self.item1View, self.item2View] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(300));
            make.height.equalTo(@(40.7));
        }];
    }
}

- (IBAction)itemClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(itemClick:)]){
        [_delegate itemClick:sender];
    }
}

- (IBAction)itemClick2:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(itemClick2:)]){
        [_delegate itemClick2:sender];
    }
}

@end
