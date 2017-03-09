//
//  ViewController.m
//  TyunMediaPickerDemo
//
//  Created by 智美高科 on 2017/3/1.
//  Copyright © 2017年 zmgk. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ViewController () <MPMediaPickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//显示选中的音频
@property (nonatomic, strong) UILabel *audiolb;

@property (nonatomic, strong) NSMutableDictionary *songDict;

//显示选中的视频
@property (nonatomic, strong) UIImageView *vedioimage;

@property (nonatomic, strong) UILabel *vediolb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.songDict = @{}.mutableCopy;
    

    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button addTarget:self action:@selector(showMediaPickerController) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"click" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UILabel *audiolb = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(button.frame) + 50, 300, 30)];
    [self.view addSubview:audiolb];
    self.audiolb = audiolb;
    

    
    //封面图
    UIImageView *vedioimage = [[UIImageView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(audiolb.frame) + 50, 100, 100)];
    vedioimage.contentMode = UIViewContentModeScaleAspectFill;
    vedioimage.layer.masksToBounds = YES;
    self.vedioimage = vedioimage;
    [self.view addSubview:vedioimage];
    
    //大小
    UILabel *vediolb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(vedioimage.frame) + 30, CGRectGetMaxY(vedioimage.frame) - 30, 300, 30)];
    [self.view addSubview:vediolb];
    self.vediolb = vediolb;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMediaPickerController {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"piker" message:@"chose audios and videos" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *audioAction = [UIAlertAction actionWithTitle:@"chose audio" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        
        MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
        picker.prompt = @"请选择您需要上传的歌曲";
        picker.showsCloudItems = YES;           //是否显示下载项
        picker.allowsPickingMultipleItems = NO; //是否多选
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    UIAlertAction *vedioAction = [UIAlertAction actionWithTitle:@"chose vedio" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = @[(NSString *)kUTTypeMovie];
        
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:audioAction];
    [alert addAction:vedioAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    

}

- (void)convertToM4A: (MPMediaItem *)song
{
    NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
    NSLog(@"%@", documentsDirectoryPath);
    NSLog (@"compatible presets for songAsset: %@",[AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
    
    NSArray *ar = [AVAssetExportSession exportPresetsCompatibleWithAsset: songAsset];
    NSLog(@"%@", ar);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: songAsset
                                      presetName: AVAssetExportPresetAppleM4A];
    
    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSString *exportFile = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",[song valueForProperty:MPMediaItemPropertyTitle]]];
    
    NSError *error1;
    
    if([fileManager fileExistsAtPath:exportFile])
    {
        [fileManager removeItemAtPath:exportFile error:&error1];
    }
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:documentsDirectoryPath];
    for (NSString *fileName in enumerator)
    {
        NSLog(@"------%@", fileName);
    }
    
    
    NSURL* exportURL = [NSURL fileURLWithPath:exportFile];
    
    exporter.outputURL = exportURL;
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         NSData *data1 = [NSData dataWithContentsOfFile:exportFile];
         double size = (long)data1.length / 1024. / 1024.;
         NSString *title = song.title;
         if ([[title stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
             
             title = @"无名称音频";
         }
         title = [title stringByAppendingString:[NSString stringWithFormat:@"       %.2fM", size]];
         dispatch_async(dispatch_get_main_queue(), ^{
            
             self.audiolb.text = title;
         });
//         NSLog(@"==================data1:%@",data1);
         
         
         int exportStatus = exporter.status;
         
         switch (exportStatus) {
                 
             case AVAssetExportSessionStatusFailed: {
                 
                 // log error to text view
                 NSError *exportError = exporter.error;
                 
                 NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                 
                 
                 
                 break;
             }
                 
             case AVAssetExportSessionStatusCompleted: {
                 
                 NSLog (@"AVAssetExportSessionStatusCompleted");
                 
                 
                 break;
             }
                 
             case AVAssetExportSessionStatusUnknown: {
                 NSLog (@"AVAssetExportSessionStatusUnknown");
                 break;
             }
             case AVAssetExportSessionStatusExporting: {
                 NSLog (@"AVAssetExportSessionStatusExporting");
                 break;
             }
                 
             case AVAssetExportSessionStatusCancelled: {
                 NSLog (@"AVAssetExportSessionStatusCancelled");
                 break;
             }
                 
             case AVAssetExportSessionStatusWaiting: {
                 NSLog (@"AVAssetExportSessionStatusWaiting");
                 break;
             }
                 
             default:
             { NSLog (@"didn't get export status");
                 break;
             }
         }
         
     }];
}



#pragma mark MPMediaPickerControllerDelegate
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {

    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {

    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    MPMediaItem *item = mediaItemCollection.items.firstObject;
   [self convertToM4A:item];

    NSLog(@"%@---%@-----", item.title, item.assetURL);
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"found a video");
  
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:videoURL options:NSDataReadingUncached error:&error];
        if (!error) {
            
            double size = (long)data.length / 1024. / 1024.;
        
            self.vediolb.text = [NSString stringWithFormat:@"%.2fMB", size];
            if (size > 30.0) {
                
                //文件过大
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"视频文件不得大于30M" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancle];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
            
                //保存数据
                //获取视频的thumbnail
                MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:videoURL] ;
                UIImage  *thumbnail = [player thumbnailImageAtTime:0.01 timeOption:MPMovieTimeOptionNearestKeyFrame];
                player = nil;
                self.vedioimage.image = thumbnail;
            }
        }
        
    }
}

@end
