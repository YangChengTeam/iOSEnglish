//
//  Config.h
//  english
//
//  Created by zhangkai on 2018/10/11.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define kNotiLoginSuccess @"kNotiLoginSucceess"

#define Config_DEBUG 0

#define kbaseUrl  @"http://en.wk2.com/api/"
#define kdebugBaseUrl @"http://en.wk2.com/api/"

#define kCurrentBaseUrl  Config_DEBUG ? kbaseUrl : kdebugBaseUrl

#define REGISTER_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"user/mobile_reg"]

#define REGISTER_SEND_CODE_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"user/reg_sendCode"]

#define INDEX_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"index/index"]

#define SHARE_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"index/share_info"]

#define NEWS_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"news/search"]

#define NEWS_INFO_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"news/info"]

#define MENU_ADV_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"index/menu_adv"]

#define LOGIN_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"user/login"]


#define POST_MESSAGE_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"user/post_msg"]



#endif /* Config_h */
