//
//  BookVoiceViewController.m
//  english
//
//  Created by zhangkai on 2018/11/1.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BookVoiceViewController.h"
#import <AVFoundation/AVSpeechSynthesis.h>
#import <Speech/Speech.h>

@interface BookVoiceViewController ()<SFSpeechRecognizerDelegate, AVAudioRecorderDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *av;

@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;

@property (nonatomic,strong) AVAudioRecorder *audioRecorder; //音频录音机


@end

#define kRecordAudioFile @"tempRecord.caf"

@implementation BookVoiceViewController {
     id _timeObserve;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.av = [[AVSpeechSynthesizer alloc] init];
    
    self.speechRecognizer = [[SFSpeechRecognizer alloc] init];
    self.speechRecognizer.delegate = self;
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    // 请求权限
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"SFSpeechRecognizerAuthorizationStatusNotDetermined");
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"SFSpeechRecognizerAuthorizationStatusDenied");
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"SFSpeechRecognizerAuthorizationStatusRestricted");
                break;
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"SFSpeechRecognizerAuthorizationStatusAuthorized");
                break;
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
}

- (void)clear {
    if(self.player){
        [self.player pause];
        [self.item removeObserver:self forKeyPath:@"status"];
        if(_timeObserve){
            [self.player removeTimeObserver:_timeObserve];
        }
    }
    self.isOver = NO;
}

- (void)play:(NSURL *)url {
    [self clear];
    self.item = [[AVPlayerItem alloc] initWithURL: url];
    self.player = [[AVPlayer alloc]initWithPlayerItem: self.item];
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    __weak typeof(self) weakSelf = self;
    _timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(weakSelf.item.duration);
        if(current == 0){
            if([weakSelf respondsToSelector:@selector(playing)]){
                [weakSelf performSelector:@selector(playing)
                                 onThread:[NSThread mainThread]
                               withObject:nil
                            waitUntilDone:NO];
            }
        }
        else if (current == total) {
            weakSelf.isOver = YES;
            if([weakSelf respondsToSelector:@selector(finished)]){
                [weakSelf performSelector:@selector(finished)
                                 onThread:[NSThread mainThread]
                               withObject:nil
                            waitUntilDone:NO];
            }
        }
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusReadyToPlay:
                [self.player play];
                break;
            default:
                self.isOver = YES;
                if([self respondsToSelector:@selector(error)]){
                    [self performSelector:@selector(error)
                                 onThread:[NSThread mainThread]
                               withObject:nil
                            waitUntilDone:NO];
                }
                break;
        }
    }
}

- (void)dealloc {
    [self clear];
}

- (void)text2speech:(NSString *)text {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:text];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    [self.av speakUtterance:utterance];
}

- (void)speech2text:(NSString *)url {
    self.recognitionRequest.shouldReportPartialResults = YES;
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
    
        if (result) {
             // result.bestTranscription.formattedString;
            
        }
    }];
}

- (void)startRecord {
    [self show:@"开始跟读..."];
    [self.audioRecorder record];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.audioRecorder stop];
        });
    });
}

- (void)setAudioSession {
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord  withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil ];
    [audioSession setActive:YES error:nil];
}

- (NSURL *)getRecordPath {
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent: kRecordAudioFile];
    return [NSURL fileURLWithPath:urlStr];
}


- (NSDictionary *)getAudioSetting {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //设置录音格式
    [params setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [params setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [params setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [params setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [params setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return params;
}

- (AVAudioRecorder *)setupAudioRecorder {
    if (!_audioRecorder) {
        NSURL *url = [self getRecordPath];
        NSDictionary *setting = [self getAudioSetting];
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//如果要监控声波则必须设置为YES
        if (error) {
            return nil;
        }
    }
    return _audioRecorder;
}

#pragma mark - 录音机代理方法
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
     [self dismiss];
    if(flag){
         // recordUrl = [self getRecordPath];
        return;
    }
    [self startRecord];
}

#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
