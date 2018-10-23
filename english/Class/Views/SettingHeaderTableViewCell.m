//
//  SettingTableViewCell.m
//  english
//
//  Created by zhangkai on 2018/10/18.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "SettingHeaderTableViewCell.h"

@implementation SettingHeaderTableViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    self.learnBtn.layer.shadowOffset = CGSizeMake(0, 5);
    self.learnBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.learnBtn.layer.shadowOpacity = 0.1;
    self.learnBtn.layer.shadowRadius = 5;
    self.learnBtn.layer.masksToBounds = NO;
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderWidth = 0;
    if(isPhone5 || isRetina){
        [self.learnBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(300));
            make.height.equalTo(@(88));
        }];
    }
}

- (IBAction)login:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(login:)]){
        [_delegate login:sender];
    }
}

- (IBAction)learn:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(learn:)]){
        [_delegate learn:sender];
    }
}

@end
