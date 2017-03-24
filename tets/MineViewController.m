//
//  MineViewController.m
//  03-FZHTabbarController
//
//  Created by lijunjie on 2016/11/25.
//  Copyright © 2016年 FZH. All rights reserved.
//

#import "MineViewController.h"
#import "UIView+AutoLayout.h"
#import <AVFoundation/AVFoundation.h>
#define kscreen_width [UIScreen mainScreen].bounds.size.width
@interface MineViewController ()<AVAudioRecorderDelegate>{
    NSURL *tmpFile;
    AVAudioRecorder *recorder;
    BOOL recording;
    BOOL paly;
    AVAudioPlayer *audioPlayer;
  //  UIButton*LuBut;
}

@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIButton *lubtn;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kscreen_width,320)];
    [self.view addSubview:_imageview];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10, 400, 100, 30)];
    [btn setTitle:@"播放视频" forState:UIControlStateNormal];
    btn.layer.borderWidth=1.0;
    self.btn=btn;
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(mergenor) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *lubtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 440, 50, 30)];
    [lubtn setTitle:@"录音" forState:UIControlStateNormal];
    self.lubtn=lubtn;
      lubtn.layer.borderWidth=1.0;
    [lubtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:lubtn];
    [lubtn addTarget:self action:@selector(luyin) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *bobtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 480, 100, 30)];
//    [bobtn setTitle:@"播放录音" forState:UIControlStateNormal];
//    //self.lubtn=lubtn;
//      bobtn.layer.borderWidth=1.0;
//    [bobtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.view addSubview:bobtn];
//    [bobtn addTarget:self action:@selector(boluyin) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *mixbtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 520, 100, 30)];
    [mixbtn setTitle:@"播放混合" forState:UIControlStateNormal];
      mixbtn.layer.borderWidth=1.0;
    //self.lubtn=lubtn;
    [mixbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:mixbtn];
    [mixbtn addTarget:self action:@selector(merge) forControlEvents:UIControlEventTouchUpInside];

}
-(void)luyin{
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    if (!recording) {
        recording = YES;
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        [audioSession setActive:YES error:nil];
        [_lubtn setTitle:@"停止" forState:UIControlStateNormal];
        
        NSDictionary *setting = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat: 44100.0],AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey, [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey, [NSNumber numberWithInt: 2], AVNumberOfChannelsKey, [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey, [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,nil]; //然后直接把文件保存成.wav就好了
        tmpFile = [NSURL fileURLWithPath:
                   [NSTemporaryDirectory() stringByAppendingPathComponent:
                    [NSString stringWithFormat: @"%@.%@",
                     @"wangshuo",
                     @"caf"]]];
        
        // tmpFile = [NSURL URLWithString:path];
        recorder = [[AVAudioRecorder alloc] initWithURL:tmpFile settings:setting error:nil];
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        [recorder record];
    } else {
        recording = NO;
        [audioSession setActive:NO error:nil];
        [recorder stop];
        [_lubtn setTitle:@"录音" forState:UIControlStateNormal];
    }

}
-(void)boluyin{
    NSError *error;
    audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:tmpFile
                                                      error:&error];
    
    audioPlayer.volume=1;
    if (error) {
        NSLog(@"error:%@",[error description]);
        return;
    }
    //准备播放
    [audioPlayer prepareToPlay];
    //播放
    [audioPlayer play];
}
- (void)merge{
    // mbp提示框
    //[MBProgressHUD showMessage:@"正在处理中"];
    // 路径
    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    // 声音来源
     NSURL *audioInputUrl = tmpFile;
   // NSURL *audioInputUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"五环之歌" ofType:@"mp3"]];
    // 视频来源
   NSURL *videoInputUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"my" ofType:@"mp4"]];
  //  NSURL* videoInputUrl =[NSURL URLWithString:@"http://flv2.bn.netease.com/videolib3/1612/28/heqxR3192/SD/heqxR3192-mobile.mp4"];
    // 最终合成输出路径
    NSString *outPutFilePath = [documents stringByAppendingPathComponent:@"merge.mp4"];
    // 添加合成路径
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outPutFilePath];
    // 时间起点
    CMTime nextClistartTime = kCMTimeZero;
    // 创建可变的音视频组合
    AVMutableComposition *comosition = [AVMutableComposition composition];
    
    
    // 视频采集
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoInputUrl options:nil];
    // 视频时间范围
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    // 视频通道 枚举 kCMPersistentTrackID_Invalid = 0
    AVMutableCompositionTrack *videoTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    // 视频采集通道
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    //  把采集轨道数据加入到可变轨道之中
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];
    
    
    
    // 声音采集
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioInputUrl options:nil];
    // 因为视频短这里就直接用视频长度了,如果自动化需要自己写判断
    CMTimeRange audioTimeRange = videoTimeRange;
    // 音频通道
    AVMutableCompositionTrack *audioTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    // 音频采集通道
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    // 加入合成轨道之中
    [audioTrack insertTimeRange:audioTimeRange ofTrack:audioAssetTrack atTime:nextClistartTime error:nil];
    
    // 创建一个输出
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:comosition presetName:AVAssetExportPresetMediumQuality];
    // 输出类型
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    // 输出地址
    assetExport.outputURL = outputFileUrl;
    // 优化
    assetExport.shouldOptimizeForNetworkUse = YES;
    // 合成完毕
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 调用播放方法
            [self playWithUrl:outputFileUrl];
        });
    }];
}

/** 播放方法 */
- (void)mergenor{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    CGRect playerFrame = CGRectMake(0, 0, 375, 400);
       NSURL *videoInputUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"my" ofType:@"mp4"]];
    NSURL* movieUrl =[NSURL URLWithString:@"http://flv2.bn.netease.com/videolib3/1612/28/heqxR3192/SD/heqxR3192-mobile.mp4"];
    AVURLAsset *asset = [AVURLAsset assetWithURL: movieUrl];
    // Float64 duration = CMTimeGetSeconds(asset.duration);
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset: asset];
    
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = playerFrame;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.imageview.layer addSublayer:playerLayer];
    if (!paly) {
        paly=YES;
        [player play];
        [_btn setTitle:@"停止视频" forState:UIControlStateNormal];
    }else{
        paly=NO;
        [player pause];
        
        [_btn setTitle:@"播放视频" forState:UIControlStateNormal];
    }

}
- (void)playWithUrl:(NSURL *)url{
 
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    CGRect playerFrame = CGRectMake(0, 0, 375, 400);
    
    AVURLAsset *asset = [AVURLAsset assetWithURL: url];
   // Float64 duration = CMTimeGetSeconds(asset.duration);
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset: asset];
    
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = playerFrame;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.imageview.layer addSublayer:playerLayer];
     [player play];
//    if (!paly) {
//        paly=YES;
//        [player play];
//         [_btn setTitle:@"停止视频" forState:UIControlStateNormal];
//    }else{
//        paly=NO;
//         [player pause];
//         [_btn setTitle:@"播放视频" forState:UIControlStateNormal];
//    }

    
    
}

@end
