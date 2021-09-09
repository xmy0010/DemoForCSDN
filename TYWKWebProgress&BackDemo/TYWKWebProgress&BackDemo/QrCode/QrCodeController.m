//
//  QrCodeController.m
//  UniversallyFramework
//
//  Created by liuf on 15/11/9.
//  Copyright © 2015年 liuf. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "QrCodeController.h"
#import "ARNewsSceneView.h"
#import "BaseWebViewController.h"

#define HexColor(hexString) [UIColor colorWithHexString:hexString withAlpha:1.]
#define IS_IPHONE_4 ( ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) && ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON ) )
#define IS_IPHONE_5 ( ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) && ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON ) )
#define IS_IPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPhone6_PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_iPhoneX (IS_iPhoneX_1 == YES || IS_IPHONEX_S == YES || IS_IPHONEX_SMax == YES || IS_IPHONEX_R == YES || IS_IPHONEX_MINI == YES || IS_IPHONEX_12Or12P == YES || IS_IPHONEX_12PMax == YES)
#define IS_iPhoneX_1 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONEX_S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONEX_SMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONEX_R ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONEX_MINI ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONEX_12Or12P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONEX_12PMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IOS_7 (([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7) ? YES : NO)
#define IS_IOS_8 (([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8) ? YES : NO)
#define iOS10OrLater ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
/**-----------------------Carlife------------------------------*/

#define SCREEN_IS_2x ([UIScreen mainScreen].scale <= 2.0)
#define SCREEN_IS_3X ([UIScreen mainScreen].scale > 2.0)

/**----------------------Compatile with iPhoneX----------------------*/
#define IS_iPhoneX_TopExtraSpace (IS_iPhoneX ? 24 : 0)
#define IS_iPhoneX_BottomExtraSpace (IS_iPhoneX ? 34 : 0)
#define IS_iPhoneX_StatusBarHeight (IS_iPhoneX ? ((IS_iPhoneX_1 || IS_IPHONEX_S || IS_IPHONEX_SMax) ? 30 : 32) : 0)
/// 顶部导航栏高度，避免在业务逻辑中使用纯数字
#define TOP_NAV_HEIGHT (64+IS_iPhoneX_TopExtraSpace)
/// 底部导航栏高度，避免在业务逻辑中使用纯数字
#define BOTTOM_NAV_HEIGHT (49+IS_iPhoneX_BottomExtraSpace)
/// 状态栏高度，避免在业务逻辑中使用纯数字
#define STATUSBAR_HEIGHT (IS_iPhoneX ? ((IS_iPhoneX_1 || IS_IPHONEX_S || IS_IPHONEX_SMax) ? 30 : 32) : 20)
/**----------------------Compatile with iPhoneX----------------------*/

// 屏幕宽度
#define SCREEN_WIDTH \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define SCREEN_HEIGHT \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)

#define SCREEN_IS_2x ([UIScreen mainScreen].scale <= 2.0)
#define SCREEN_IS_3X ([UIScreen mainScreen].scale > 2.0)

/**----------------------Compatile with iPhoneX----------------------*/
#define IS_iPhoneX_TopExtraSpace (IS_iPhoneX ? 24 : 0)
#define IS_iPhoneX_BottomExtraSpace (IS_iPhoneX ? 34 : 0)
#define IS_iPhoneX_StatusBarHeight (IS_iPhoneX ? ((IS_iPhoneX_1 || IS_IPHONEX_S || IS_IPHONEX_SMax) ? 30 : 32) : 0)
/// 顶部导航栏高度，避免在业务逻辑中使用纯数字
#define TOP_NAV_HEIGHT (64+IS_iPhoneX_TopExtraSpace)
/// 底部导航栏高度，避免在业务逻辑中使用纯数字
#define BOTTOM_NAV_HEIGHT (49+IS_iPhoneX_BottomExtraSpace)

// 颜色
#define COLOR_WITH_RGB(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

@interface QrCodeController ()<AVCaptureMetadataOutputObjectsDelegate, UITextViewDelegate>

@end

@implementation QrCodeController {
    AVCaptureSession *_captureSession;
    
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
    AVSampleBufferDisplayLayer *_sampleBufferDisplayLayer;
    
    UIView *_boxView;
    UIView *_viewPreview;
    BOOL _isReading;
    NSTimer *_timer;
    UIImageView *_scanLayer;
    UIView * _bottomView;
    UIButton *_scanButton;
    UIButton *_arButton;
    captureType _currentCaptureType;
    UIButton *_revealButton;
    UIImageView *_bianJiaoImgeview;
    
    UIView *_leftBlackBgView;
    UIView *_rightBlackBgView;
    UIView *_topBlackBgView;
    UIView *_bottomBlackBgView;
    UIView *_topView;
    
    ARNewsSceneView *_sceneView;
    UIView *_imgBgView;
    ARNewsSceneNode *_selectedNode;
}


#pragma mark Init  - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"扫描二维码"];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)backBtnPre:(id)sender {
    [self stopReading];
    [self.navigationController popViewControllerAnimated:true];
}

- (BOOL)startReading {
    
    _viewPreview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _viewPreview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_viewPreview];
    
    [self addBlackBgView];
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_NAV_HEIGHT)];
    topView.backgroundColor = COLOR_WITH_RGB(31/255.0, 29/255.0, 30/255.0, 1);
    topView.alpha = 0.6;
    [self.view addSubview:topView];
    _topView = topView;
    
    [self addBottomView];
    
    UIButton *revealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    revealButton.frame = CGRectMake((SCREEN_WIDTH-190)/2, 100+TOP_NAV_HEIGHT + 255 + 30, 190, 26);
    revealButton.userInteractionEnabled = NO;
    [revealButton setBackgroundImage:[UIImage imageNamed:@"qr_reveal_btn_bg.png"] forState:UIControlStateNormal];
    revealButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [revealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    revealButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [revealButton setTitle:@"请对准二维码，耐心等待" forState:UIControlStateNormal];
    [self.view addSubview:revealButton];
    _revealButton = revealButton;
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 32+IS_iPhoneX_TopExtraSpace, 20, 20);
    [button setImage:[UIImage imageNamed:@"qr_nav-icon-fanhui-normal.png"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    button.alpha = 1;
    [self.view addSubview:button];

    return [self captureScan];
}

- (BOOL)captureScan{
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (captureDevice.isFocusPointOfInterestSupported && [captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [captureDevice lockForConfiguration:nil];
        [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [captureDevice unlockForConfiguration];
    }
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为所有类型
    captureMetadataOutput.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    _videoPreviewLayer.backgroundColor = (__bridge CGColorRef)([UIColor clearColor]);
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0, 0, 1, 1);
    
    _boxView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-256)/2, 100+TOP_NAV_HEIGHT, 256 , 256)];
    
    _boxView.alpha = 1;
    _boxView.backgroundColor = [UIColor clearColor];
    [_viewPreview addSubview:_boxView];
    
    UIImageView * imgeview = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-256)/2 ,100+TOP_NAV_HEIGHT, 256 , 256)];
    imgeview.image = [UIImage imageNamed:@"qr_saoyisao_bg_bianjiao_normal.png"];
    imgeview.alpha = 1;
    _bianJiaoImgeview = imgeview;
    
    [_viewPreview addSubview:imgeview];
    _scanLayer = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, 255 , 44)];
    _scanLayer.alpha = 1;
    _scanLayer.image = [UIImage imageNamed:@"qr_saoyisao_bg_xiantiao_normal"];
    [_boxView addSubview:_scanLayer];
    [_timer invalidate];
    _timer=nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.03f
                                              target:self
                                            selector:@selector(moveScanLayer:)
                                            userInfo:nil repeats:YES];
    [_timer fire];
    //10.开始扫描
    [_captureSession startRunning];
    return YES;
}

- (void)addBlackBgView{
    UIView *leftBlackBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 256) / 2,SCREEN_HEIGHT)];
    leftBlackBgView.backgroundColor = [UIColor blackColor];
    leftBlackBgView.alpha = 0.3f;
    [self.view addSubview:leftBlackBgView];
    _leftBlackBgView = leftBlackBgView;
    
    UIView *rightBlackBgView = [[UIView alloc] initWithFrame:CGRectMake( (SCREEN_WIDTH - 256) / 2 + 256, 0, (SCREEN_WIDTH - 256) / 2,SCREEN_HEIGHT)];
    rightBlackBgView.backgroundColor = [UIColor blackColor];
    rightBlackBgView.alpha = 0.3f;
    [self.view addSubview:rightBlackBgView];
    _rightBlackBgView = rightBlackBgView;
    
    UIView *topBlackBgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 256) / 2, 0, 256,100+TOP_NAV_HEIGHT)];
    topBlackBgView.backgroundColor = [UIColor blackColor];
    topBlackBgView.alpha = 0.3f;
    [self.view addSubview:topBlackBgView];
    _topBlackBgView = topBlackBgView;
    
    UIView *bottomBlackBgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 256) / 2, 100+TOP_NAV_HEIGHT+256, 256,SCREEN_HEIGHT - (100+TOP_NAV_HEIGHT+256))];
    bottomBlackBgView.backgroundColor = [UIColor blackColor];
    bottomBlackBgView.alpha = 0.3f;
    [self.view addSubview:bottomBlackBgView];
    _bottomBlackBgView = bottomBlackBgView;
}

- (void)addBottomView{
    if(_bottomView){
        [_bottomView removeFromSuperview];
    }
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-88, SCREEN_WIDTH, 88)];
    _bottomView.backgroundColor = [UIColor clearColor];
    _bottomView.alpha = 1.0;
    [self.view addSubview:_bottomView];
    _bottomView.hidden = YES;
    
    UIView *bottomBlackBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 88)];
    bottomBlackBgView.backgroundColor = [UIColor blackColor];
    bottomBlackBgView.alpha = 0.4;
    [_bottomView addSubview:bottomBlackBgView];
    
}

- (void)bottomBtnTouched:(id)sender{
    UIButton *button = (UIButton *)sender;
    [self setBottomButtonState:[button tag]];
}

- (void)setBottomButtonState:(captureType)type {
    if(type == captureTypeScan){
        [_scanButton setImage:[UIImage imageNamed:@"qr_scan_icon_scan_press.png"] forState:UIControlStateNormal];
//        [_scanButton setTitleColor:COLOR_WITH_RGB(255, 123, 0, 1) forState:UIControlStateNormal];
//        [_scanButton setTitleColor:C_Color(C_AssistColor) forState:UIControlStateNormal];
        
        [_arButton setImage:[UIImage imageNamed:@"qr_scan_icon_ar_nor.png"] forState:UIControlStateNormal];
        [_arButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        [_scanButton setImage:[UIImage imageNamed:@"qr_scan_icon_scan_nor.png"] forState:UIControlStateNormal];
        [_scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_arButton setImage:[UIImage imageNamed:@"qr_scan_icon_ar_press.png"] forState:UIControlStateNormal];
        [_arButton setTitleColor:COLOR_WITH_RGB(255, 123, 0, 1) forState:UIControlStateNormal];
//        [_arButton setTitleColor:C_Color(C_AssistColor) forState:UIControlStateNormal];
    }
}

-(void)refreshScanState:(captureType)type{
    [self setBottomButtonState:type];
}

- (void)back {
    [self backBtnPre:nil];
}

#pragma mark - ARNews
- (void)hideScanViews {
    [_timer invalidate];
    _timer=nil;
    
    [_scanLayer removeFromSuperview];
    _scanLayer = nil;
    
    [_revealButton removeFromSuperview];
    _revealButton = nil;
    
    [_bianJiaoImgeview removeFromSuperview];
    _bianJiaoImgeview = nil;
    
    [_leftBlackBgView removeFromSuperview];
    [_rightBlackBgView removeFromSuperview];
    [_topBlackBgView removeFromSuperview];
    [_bottomBlackBgView removeFromSuperview];
    _leftBlackBgView = nil;
    _rightBlackBgView = nil;
    _topBlackBgView = nil;
    _bottomBlackBgView = nil;
    
    [_bottomView removeFromSuperview];
    _bottomView = nil;
    
    [_topView removeFromSuperview];
    _topView = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获取到手势的对象
    UITouch *touch = [touches allObjects].firstObject;
    // 手势在SCNView中的位置
    CGPoint touchPoint = [touch locationInView:_sceneView];
    //该方法会返回一个SCNHitTestResult数组，这个数组中每个元素的node都包含了指定的点（CGPoint）
    NSArray *hitResults = [_sceneView hitTest:touchPoint options:nil];
    if (hitResults.count > 0) {
        SCNHitTestResult * hit = [hitResults firstObject];
        SCNNode *node = hit.node;
        if ([node isKindOfClass:ARNewsSceneNode.class]) {
            ARNewsSceneNode *newsNode = (ARNewsSceneNode *)node;
            
            if (_selectedNode) {
                SCNAction *rotate = [SCNAction rotateByX:0 y:-M_PI * 2 z:0 duration:0.5];
                SCNAction *scale = [SCNAction scaleTo:1 duration:0.5];
                SCNAction *group = [SCNAction group:@[rotate, scale]];
                [_selectedNode runAction:group];
            }
            
            _selectedNode = newsNode;
            
            SCNAction *rotate = [SCNAction rotateByX:0 y:M_PI * 2 z:0 duration:0.5];
            SCNAction *scale = [SCNAction scaleTo:1.2 duration:0.5];
//            SCNAction *move = [SCNAction moveTo:[self convertToScenOfPoint:self.view.center] duration:0.5];
            SCNAction *group = [SCNAction group:@[rotate, scale]];
            [newsNode runAction:group completionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSLog(@"jumpxxxxx");
//                        [[RemoteJumpService sharedInstance] jump:newsNode.jump params:nil sourceModel:nil];
                    });
                });
            }];
        }
    }
}

- (void)animationStart {
    /// 开始
    const char *queueName = [NSString stringWithFormat:@"%@.arimages.queue", [NSBundle mainBundle].bundleIdentifier].UTF8String;
    dispatch_queue_t refreshQueue = dispatch_queue_create(queueName, NULL);
    
    UIView *imgBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_WIDTH * 1920 / 1080. - IS_iPhoneX_StatusBarHeight - IS_iPhoneX_BottomExtraSpace, SCREEN_WIDTH, SCREEN_WIDTH * 1920 / 1080.)];
    [imgBgView setBackgroundColor:[UIColor clearColor]];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = imgBgView.frame;
    [imgBgView setTag:123569];
    [imgBgView addSubview:imgView];
    [_viewPreview addSubview:imgBgView];
    
    /// 循环
    UIView *imgBgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_WIDTH * 1920 / 1080. - IS_iPhoneX_StatusBarHeight - IS_iPhoneX_BottomExtraSpace, SCREEN_WIDTH, SCREEN_WIDTH * 1920 / 1080.)];
    [imgBgView1 setBackgroundColor:[UIColor clearColor]];
    UIImageView *imgView1 = [[UIImageView alloc] init];
    imgView1.frame = imgBgView1.frame;
    [imgBgView1 setTag:123568];
    [imgBgView1 addSubview:imgView1];
    [_viewPreview insertSubview:imgBgView1 belowSubview:imgBgView];
    
    _imgBgView = imgBgView1;
    
    /// 异步加载图片
    dispatch_async(refreshQueue, ^{
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 0; i <= 50; i++) {
            NSString *name = [NSString stringWithFormat:@"ar_start_%02lu.png", (unsigned long)i];
            UIImage *image = [UIImage imageNamed:name];
            if (image) {
                [refreshingImages addObject:image];
            }
        }
        NSMutableArray *refreshingImages1 = [NSMutableArray array];
        for (NSUInteger i = 51; i <= 109; i++) {
            NSString *name = [NSString stringWithFormat:@"ar_cycle_%lu.png", (unsigned long)i];
            UIImage *image = [UIImage imageNamed:name];
            if (image) {
                [refreshingImages1 addObject:image];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (imgView && _viewPreview) {
                [imgView setAnimationImages:refreshingImages];
                [imgView setAnimationDuration:2];
                [imgView setAnimationRepeatCount:1];
                [imgView startAnimating];
            }
            if (imgView1 && _viewPreview) {
                [imgView1 setAnimationImages:refreshingImages1];
                [imgView1 setAnimationDuration:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [imgView1 startAnimating];
                });
            }
        });
    });
}

- (void)endAnimation {
    [_viewPreview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == 123569 && [obj isKindOfClass:[UIView class]]) {
            [obj removeFromSuperview];
            *stop = YES;
        }
        if (obj.tag == 123568 && [obj isKindOfClass:[UIView class]]) {
            [obj removeFromSuperview];
            *stop = YES;
        }
    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate协议方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (_currentCaptureType != captureTypeScan) {
        return;
    }
    
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            if(!_isReading){
                _isReading=YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *result=[metadataObj stringValue];
                    
                    //web调起则将结果回传
                    if(self.webOpenQRCodeBlock) {
                        [self back];
                        NSLog(@"调用block");
                        self.webOpenQRCodeBlock(result);
                        return;
                    }
                    //匹配网址URL的正则表达式：[a-zA-z]+://[^s]*
                    NSString *urlRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
                    NSPredicate *urlPredicate  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
                    if ([urlPredicate evaluateWithObject:result]) {
                        BaseWebViewController *webController = [[BaseWebViewController alloc] init];
                        webController.urlString = result;
                        [self.navigationController pushViewController:webController animated:YES];
                    }
                    else{
                            [self addScreenAlterViewWith:result];
                    }
                    NSLog(@"本页面处理");
                });
            }
        }
    }
}

- (void)addScreenAlterViewWith:(NSString *)string {
    UIView * screenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_NAV_HEIGHT)];
    topView.backgroundColor = [UIColor blackColor];
    [screenView addSubview:topView];
    
    UIButton * button  = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 32+IS_iPhoneX_TopExtraSpace, 60, 21);
    [button setTitle:@" 返回" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"qr_nav-icon-fanhui-normal.png"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:button];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TOP_NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_NAV_HEIGHT)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [screenView addSubview:scrollView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 25)];
    label.text = @"已扫描到以下内容";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];

    UITextView * textView = [[UITextView alloc]init];
    textView.text = string;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = UIColor.grayColor.CGColor;;
    textView.textAlignment = NSTextAlignmentCenter;

    textView.font = [UIFont systemFontOfSize:20];
    CGSize constraintSize = CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    textView.frame = CGRectMake(10, CGRectGetMaxY(label.frame)+10, SCREEN_WIDTH-20, size.height);
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];

    UILabel * bottomLabe = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame)+5, SCREEN_WIDTH, 25)];
    bottomLabe.text = [NSString stringWithFormat:@"扫描到所得内容并非%@提供,请谨慎使用",appName];
    bottomLabe.font = [UIFont systemFontOfSize:13];
    bottomLabe.textAlignment = NSTextAlignmentCenter;
    bottomLabe.textColor = [UIColor grayColor];

    UILabel * bottomLabe1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomLabe.frame), SCREEN_WIDTH, 25)];
    bottomLabe1.text = @"如需使用,可通过复制操作获取内容";
    bottomLabe1.textAlignment = NSTextAlignmentCenter;
    bottomLabe1.font = [UIFont systemFontOfSize:13];
    bottomLabe1.textColor = [UIColor grayColor];

    UIView * mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(bottomLabe1.frame))];
    [mainView addSubview:label];
    [mainView addSubview:textView];
    [mainView addSubview:bottomLabe];
    [mainView addSubview:bottomLabe1];
    [scrollView addSubview:mainView];
    if (CGRectGetMaxY(bottomLabe1.frame) > SCREEN_HEIGHT - TOP_NAV_HEIGHT) {
        mainView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(bottomLabe1.frame));
        scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(mainView.frame));
    }
    else{
        mainView.frame = CGRectMake(0, (SCREEN_HEIGHT - TOP_NAV_HEIGHT -CGRectGetMaxY(bottomLabe1.frame))/2, SCREEN_WIDTH, CGRectGetMaxY(bottomLabe1.frame));
        scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(mainView.frame) + (SCREEN_HEIGHT - TOP_NAV_HEIGHT -CGRectGetMaxY(bottomLabe1.frame))/2);
    }
    
    [self.view addSubview:screenView];
}

//实现计时器方法moveScanLayer:(NSTimer *)timer
- (void)moveScanLayer:(NSTimer *)timer {
    CGRect frame = _scanLayer.frame;
    if (255-45 < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 2;
        [UIView animateWithDuration:0.1 animations:^{
            self->_scanLayer.frame = frame;
        }];
    }
}

- (void)stopReading {
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperview];
    [_videoPreviewLayer removeFromSuperlayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    _captureSession = nil;
    _isReading=NO;
    self.navigationController.navigationBar.hidden=YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self startReading];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    self.navigationController.navigationBar.hidden=NO;
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    [self stopReading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"扫描页面销毁");
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    [self stopReading];
    
    [self endAnimation];
}

@end
