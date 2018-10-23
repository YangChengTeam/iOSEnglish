//
//  IndexHeaderTableViewCell.m
//  english
//
//  Created by zhangkai on 2018/10/12.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "IndexHeaderTableViewCell.h"

@implementation IndexHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.menuView.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    self.menuView.layer.mask = maskLayer;
   
    if(isRetina || isPhone5){
        [@[self.readBtn , self.phoneticBtn] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(145));
            make.height.equalTo(@(75.6));
        }];
        
        [@[self.toolBtn, self.wordBtn, self.microClassBtn, self.taskBtn] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(70));
            make.height.equalTo(@(78));
        }];
        
        [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(234));
        }];
    }
    
}

- (IBAction)nav2hotNews:(id)sender {
    NSLog(@"hot");
    if(_delegate && [_delegate respondsToSelector:@selector(nav2hotNews:)]){
        [_delegate nav2hotNews: sender];
    }
}

- (IBAction)nav2topNews:(id)sender {
    NSLog(@"top");
    if(_delegate && [_delegate respondsToSelector:@selector(nav2topNews:)]){
        [_delegate nav2topNews: sender];
    }
}

- (IBAction)nav2phonetic:(id)sender {
    NSLog(@"phonetic");
    if(_delegate && [_delegate respondsToSelector:@selector(nav2phonetic:)]){
        [_delegate nav2phonetic: sender];
    }
}

- (IBAction)nav2read:(id)sender {
    NSLog(@"read");
    if(_delegate && [_delegate respondsToSelector:@selector(nav2read:)]){
        [_delegate nav2read: sender];
    }
}

- (IBAction)nav2word:(id)sender {
    NSLog(@"word");
    if(_delegate && [_delegate respondsToSelector:@selector(nav2word:)]){
        [_delegate nav2word: sender];
    }
}

- (IBAction)nav2microClass:(id)sender {
    NSLog(@"MicroClass");
    if(_delegate && [_delegate respondsToSelector:@selector(nav2microClass:)]){
        [_delegate nav2microClass: sender];
    }
}

- (IBAction)nav2task:(id)sender {
    NSLog(@"task");
    if(_delegate && [_delegate respondsToSelector:@selector(nav2task:)]){
        [_delegate nav2task: sender];
    }
}

- (IBAction)nav2tool:(id)sender {
    NSLog(@"tool");
    if(_delegate && [_delegate respondsToSelector:@selector(nav2tool:)]){
        [_delegate nav2tool: sender];
    }
}

- (IBAction)nav2newsDetail:(id)sender {
    NSLog(@"detail");
    if(_delegate && [_delegate respondsToSelector:@selector(nav2newsDetail:)]){
        [_delegate nav2newsDetail: sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
