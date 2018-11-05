//
//  BookVoiceViewController.h
//  english
//
//  Created by zhangkai on 2018/11/1.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BaseInnerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookVoiceViewController : BaseInnerViewController

@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerItem * item;
@property (nonatomic, assign) BOOL isOver;

- (void)play:(NSURL *)url;

- (void)playing;
- (void)finished;
- (void)error;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
