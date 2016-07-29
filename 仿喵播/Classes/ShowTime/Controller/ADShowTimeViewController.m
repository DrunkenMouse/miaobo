//
//  ADShowTimeViewController.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/22.
//  Copyright © 2016年 王奥东. All rights reserved.
//


#import <LFLiveKit/LFLiveKit.h>
#import "ADShowTimeViewController.h"

/**
 
    推流使用的LFLive框架,其自身集合了美颜、摄像头切换、转码推流到服务器
    与直播状态的获取等方法
    
    本案例通过自己本地搭建的nginx + RTMP服务器与ffmpeg协议来接收推流,通过IJK框架
    实现拉流解码的操作
 
 */


@interface ADShowTimeViewController ()<LFLiveSessionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *BeautifulBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *LivingBtn;

//RTMP地址
@property(nonatomic, copy) NSString *rtmpUrl;
@property (nonatomic, strong) LFLiveSession *session;
@property(nonatomic, weak) UIView *livingPreView;

@end

@implementation ADShowTimeViewController

//直播时显示的View
-(UIView *)livingPreView{
    if (!_livingPreView) {
        
        UIView *livingPreView = [[UIView alloc]initWithFrame:self.view.bounds];
        livingPreView.backgroundColor = [UIColor clearColor];
        //通过约束与frame让显示的View填充整个页面
        livingPreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:livingPreView atIndex:0];
        _livingPreView = livingPreView;
        
    }
    return _livingPreView;
    
}

- (LFLiveSession*)session{
   
    
    if(!_session){
        
        //  默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏
       
//        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration]  videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2]];
    
        _session = [[LFLiveSession alloc]initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration: [LFLiveVideoConfiguration defaultConfiguration]];
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(720, 1280);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.orientation = UIInterfaceOrientationPortrait;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration liveType:LFLiveRTMP];
         */
        
        // 设置代理
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.livingPreView;
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}


-(void)setup{
   
    //美颜按钮的圆环设置
    self.BeautifulBtn.layer.cornerRadius = self.BeautifulBtn.height * 0.5;
    self.BeautifulBtn.layer.masksToBounds = YES;
    
    //直播按钮的圆环设置
    self.LivingBtn.backgroundColor = KeyColor;
    self.LivingBtn.layer.cornerRadius = self.livingPreView.height * 0.5;
    self.LivingBtn.layer.masksToBounds = YES;
    
    //状态栏的设置
    self.statusLabel.numberOfLines = 0;
    
    //默认开启后置摄像头
    self.session.captureDevicePosition = AVCaptureDevicePositionBack;
}


//关闭直播
- (IBAction)clock:(UIButton *)sender {
    //连接中或已连接状态就停止播放
    if (self.session.state == LFLivePending || self.session.state == LFLiveStart) {
        [self.session stopLive];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//开启/关闭美颜按钮
- (IBAction)beautiful:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    //默认是开启了美颜功能的
    self.session.beautyFace = !self.session.beautyFace;
}

//前置后置摄像头选择
- (IBAction)SwitchCamera:(UIButton *)sender {
    
    // 切换前置/后置摄像头
    AVCaptureDevicePosition devicePostion = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (devicePostion == AVCaptureDevicePositionBack)?AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    
}

//开始直播
- (IBAction)living:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
         // 开始直播
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        //服务器的地址
        stream.url = @"rtmp://192.168.1.104/rtmplive/room";
        self.rtmpUrl = stream.url;
        [self.session startLive:stream];

        
    }else{
        // 结束直播
        [self.session stopLive];
        self.statusLabel.text = [NSString stringWithFormat:@"状态:直播被关闭\nRTMP:%@", self.rtmpUrl];
    }
}

#pragma mark - LFStreamingSessionDelegate
//live status changed will callback
-(void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    
    NSString *tempStatus;
    switch (state) {
            
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"状态: %@\nRTMP:%@",tempStatus,self.rtmpUrl];
}

//live debug info callback
-(void)liveSession:(LFLiveSession *)session debugInfo:(LFLiveDebug *)debugInfo{
    
}

//callback socket errorcode
-(void)liveSession:(LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
}

@end
