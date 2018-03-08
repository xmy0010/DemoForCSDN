//
//  ViewController.m
//  Tyun_AudioDemo
//
//  Created by T_yun on 2018/2/28.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>


#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()<MPMediaPickerControllerDelegate>

@property(nonatomic, strong) MPMediaPickerController *musicVC;

@property(nonatomic, strong) MPMusicPlayerController *musicPlayVC;

@end
void SoundFinishedPlaying(SystemSoundID sound_id, void *user_data){
    
    //注销系统声音
    AudioServicesRemoveSystemSoundCompletion(sound_id);
    AudioServicesDisposeSystemSoundID(sound_id);
}
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
}
- (IBAction)choseAudio:(id)sender {
  
    //取
    self.musicVC = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    self.musicVC.delegate = self;
    self.musicVC.prompt = @"请选择一首歌曲";
    [self showDetailViewController:self.musicVC sender:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    //播放
    self.musicPlayVC = [[MPMusicPlayerController alloc] init];
    
    [self.musicPlayVC setQueueWithItemCollection:mediaItemCollection];
    [self.musicPlayVC play];
    
}
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    
    NSLog(@"取消选择");
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//读取音频文件信息
-(NSDictionary *)readAudioProperty:(NSString *)name type:(NSString *)type{
    
    
    //读取音频文件信息
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    
    //打开
    AudioFileID audioFile;
    AudioFileOpenURL((__bridge CFURLRef)audioUrl, kAudioFileReadPermission, 0, &audioFile);
    
    //读取
    uint32_t dictionarySize = 0;
    AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, 0);
    CFDictionaryRef dictionary;
    AudioFileGetProperty(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, &dictionary);
    
    NSDictionary *audioDic = (__bridge NSDictionary*)dictionary;
    for (NSString *key in audioDic.allKeys) {
        
        NSString *value = audioDic[key];
        NSLog(@"%@==%@", key, value);
    }
    
    CFRelease(dictionary); //释放内存
    AudioFileClose(audioFile); //关闭音频方法
    
    return audioDic;
}

//震动
- (IBAction)systemSound1:(id)sender {
   
    NSString *deviceModel = [[UIDevice currentDevice] model];
    if ([deviceModel isEqualToString:@"iPhone"]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    } else{
        //iPhone才有震动
        NSLog(@"设备不支持震动");
    }
}

//系统声音
- (IBAction)systemSound2:(id)sender {
  
    NSURL *systemSound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"receive_msg" ofType:@"caf"]];
   
    //创建ID
    SystemSoundID systemSound_id;
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(systemSound_url), &systemSound_id);
    
    //注册回调
    AudioServicesAddSystemSoundCompletion(systemSound_id, NULL, NULL, SoundFinishedPlaying, NULL);
    //播放系统声音
    AudioServicesPlaySystemSound(systemSound_id);
}

//提示声音 （无论是否静音都有效果）
- (IBAction)systemSound3:(id)sender {
    
    
    NSURL *systemSound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"receive_msg" ofType:@"caf"]];
    
    //创建ID
    SystemSoundID systemSound_id;
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(systemSound_url), &systemSound_id);
    
    //注册回调
    AudioServicesAddSystemSoundCompletion(systemSound_id, NULL, NULL, SoundFinishedPlaying, NULL);
    //播放提示声音
    AudioServicesPlayAlertSound(systemSound_id);
}

@end
