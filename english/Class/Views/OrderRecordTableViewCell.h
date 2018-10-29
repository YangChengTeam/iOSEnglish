//
//  OrderRecordTableViewCell.h
//  english
//
//  Created by zhangkai on 2018/10/29.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderRecordTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *orderNumLbl;
@property (nonatomic, assign) IBOutlet UILabel *moneyLbl;
@property (nonatomic, assign) IBOutlet UILabel *statusLbl;
@property (nonatomic, assign) IBOutlet UILabel *timeLbl;

@end

NS_ASSUME_NONNULL_END
