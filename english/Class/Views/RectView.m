//
//  RectView.m
//  english
//
//  Created by zhangkai on 2018/11/6.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "RectView.h"

@implementation RectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2)];
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y+ rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)];
    [path closePath];
    [UIColorFromHex(0xE6F1FB) setFill];
    [path fill];
}


@end
