//
//  TYMusicPlayController.m
//  Tyun_AudioDemo
//
//  Created by T_yun on 2018/3/8.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYMusicPlayController.h"
#import <AVFoundation/AVFoundation.h>

@interface TYMusicPlayController ()<AVAudioPlayerDelegate>


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *audioPro;
@property (weak, nonatomic) IBOutlet UISlider *audioTime;
@property (weak, nonatomic) IBOutlet UIStepper *cyc;
@property (weak, nonatomic) IBOutlet UIProgressView *audioProgress;
@property (weak, nonatomic) IBOutlet UISlider *audioVol;

@property(nonatomic, strong) AVAudioPlayer *audioPlayer;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation TYMusicPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Actions

- (IBAction)onPlay:(id)sender {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"蔡依林 - 倒带" ofType:@"mp3"];
    if (path) {
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _audioPlayer.delegate = self;
        _audioPlayer.meteringEnabled = YES;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(monitor) userInfo:nil repeats:YES];
        
        [_audioPlayer play];
    }
}

- (IBAction)onPause:(id)sender {
    
    if ([_audioPlayer isPlaying]) {
        
        [_audioPlayer pause];
    } else{
        [_audioPlayer play];
    }
}

- (IBAction)onStop:(id)sender {
   
    self.audioTime.value = 0;
    self.audioProgress.progress = 0;
    [_audioPlayer stop];
}

- (IBAction)audioSwitch:(id)sender {
    
    _audioPlayer.volume = [sender isOn];
}
- (IBAction)audioCyc:(id)sender {
   
    _audioPlayer.numberOfLoops = self.cyc.value;

}

- (IBAction)audioVol:(id)sender {
    
    _audioPlayer.volume = _audioVol.value;
}
- (IBAction)audioTime:(id)sender {
    
    [_audioPlayer pause];
    [_audioPlayer setCurrentTime:(NSTimeInterval)self.audioTime.value * _audioPlayer.duration];
    [_audioPlayer play];
}

- (void)monitor{
    
    NSUInteger channels = _audioPlayer.numberOfChannels;
    NSTimeInterval duration = _audioPlayer.duration;
    [_audioPlayer updateMeters];
    NSString *audioInfoValue = [[NSString alloc] initWithFormat:@"%f,%f\nchannels=%lu  duration=%lu\n currentTime = %f",[_audioPlayer peakPowerForChannel:0],[_audioPlayer peakPowerForChannel:1], channels, (unsigned long)duration, _audioPlayer.currentTime];
    self.textView.text = audioInfoValue;
    self.audioProgress.progress = _audioPlayer.currentTime / _audioPlayer.duration;
}

#pragma Mark delegate
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    NSLog(@"播放完成");
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
