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
#define kNotiBook @"kNotiBook"

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

#define REGISTER_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"user/mobile_reg"]

#define REGISTER_SEND_CODE_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"user/reg_sendCode"]

#define FORGOT_SEND_CODE_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"user/forgetPwd_sendCode"]

#define FORGOT_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"user/reset_pwd"]

#define UPD_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"user/upd"]

#define UPD_PWD_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"user/upd_pwd"]

#define ORDER_RECORD_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"order/lists"]

#define WEIKE_CATEGORY_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"news/getParentList"]

#define WEIKE_UNIT_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"news/getChildList"]

#define BOOK_INFO_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"book/book_info"]

#define BOOK_LIST_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"book/book_list"]

#define GRADE_LIST_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"book/grade_list"]

#define COURSE_VERSION_LIST_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"book/version_list"]

#define COURSE_LIST_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"book/course_list"]

#define SENTENCE_LIST_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"book/sentence_list"]

#define WORD_UNIT_LIST_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"book/unit_list"]

#define WORD_LIST_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"book/words_list"]

#define NOTE_LIST_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"book/notelist"]

#define ADD_NOTE_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"note/add"]

#define FOLLOW_LIST_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"note/followlist"]

#define ADD_COMMENT_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"note/follow"]

#define ADD_AGREE_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"note/agree"]

#define DELETE_NOTE_URL [NSString stringWithFormat:@"%@%@", kCurrentBaseUrl, @"note/delNote"]

#endif /* Config_h */
