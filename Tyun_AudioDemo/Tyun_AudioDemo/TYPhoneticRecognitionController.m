//
//  TYPhoneticRecognitionController.m
//  Tyun_AudioDemo
//
//  Created by T_yun on 2018/3/8.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYPhoneticRecognitionController.h"
#import <AVFoundation/AVFoundation.h>

@interface TYPhoneticRecognitionController ()<AVSpeechSynthesizerDelegate>

@property(nonatomic, strong) AVSpeechSynthesizer *speechManager;

@end

@implementation TYPhoneticRecognitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.speechManager = [[AVSpeechSynthesizer alloc] init];
    _speechManager.delegate = self;
    
    //语音识别
    AVSpeechUtterance *aut = [AVSpeechUtterance speechUtteranceWithString:@"welcom to 四川成都"];
    aut.rate = 0.5; //速度 正常播放
    [_speechManager speakUtterance:aut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    NSLog(@"语音处理 start");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    NSLog(@"语音处理 finish");
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
