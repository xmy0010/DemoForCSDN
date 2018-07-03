//
//  TYContentShowViewController.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/4.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYContentShowViewController.h"

@interface TYContentShowViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) SDCycleScrollView *cycleView;


@property(nonatomic, strong) UIView *backView;
@property(nonatomic, assign) BOOL showBack;

@end

@implementation TYContentShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addGesture];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{
    
    [SVProgressHUD showWithStatus:@""];
    //从沙盒中取旋转之后的图片缓存
    NSString *path_sandox = NSHomeDirectory();
    NSString *newPath = [path_sandox stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/pic_%ld.plist", _section]];
    NSArray *localImgs = [NSArray arrayWithContentsOfFile:newPath];
    NSMutableArray *imgs = @[].mutableCopy;
    if (localImgs.count != _pageNumber) {
        
        //俩者不等 生成图片并存在本地

        NSMutableArray *tempImgs = @[].mutableCopy;
        for (int i = 0; i < _pageNumber; i++) {
            
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"page_%ld_%d", _section, i]];
            /*
             
             把图片转换为Base64的字符串
             
             
             在iphone上有两种读取图片数据的简单方法: UIImageJPEGRepresentation和UIImagePNGRepresentation.
             
             UIImageJPEGRepresentation函数需要两个参数:图片的引用和压缩系数.而UIImagePNGRepresentation只需要图片引用作为参数.通过在实际使用过程中,
             比较发现: UIImagePNGRepresentation(UIImage* image) 要比UIImageJPEGRepresentation(UIImage* image, 1.0) 返回的图片数据量大很多.
             譬如,同样是读取摄像头拍摄的同样景色的照片, UIImagePNGRepresentation()返回的数据量大小为199K ,
             而 UIImageJPEGRepresentation(UIImage* image, 1.0)返回的数据量大小只为140KB,比前者少了50多KB.
             如果对图片的清晰度要求不高,还可以通过设置 UIImageJPEGRepresentation函数的第二个参数,大幅度降低图片数据量.譬如,刚才拍摄的图片,
             通过调用UIImageJPEGRepresentation(UIImage* image, 1.0)读取数据时,返回的数据大小为140KB,但更改压缩系数后,
             通过调用UIImageJPEGRepresentation(UIImage* image, 0.5)读取数据时,返回的数据大小只有11KB多,大大压缩了图片的数据量 ,
             而且从视角角度看,图片的质量并没有明显的降低.因此,在读取图片数据内容时,建议优先使用UIImageJPEGRepresentation,
             并可根据自己的实际使用场景,设置压缩系数,进一步降低图片数据量大小.
             */
            NSData *data = UIImageJPEGRepresentation(image, 1.0f);
            NSString *strimage64 = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [tempImgs addObject:strimage64];
            [imgs addObject:image];
        }
        if ([tempImgs writeToFile:newPath atomically:YES]) {
            
            NSLog(@"写入成功");
        }
    } else{
        for (NSString *strimage64 in localImgs) {
            
            NSData *data = [[NSData alloc] initWithBase64EncodedString:strimage64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:data];
            [imgs addObject:decodedImage];
        }
    }
    
    

    
    
    
    CGFloat imgWidth = kSCREEN_HEIGHT;
    CGFloat imgHeight = imgWidth / 4167 * 5492;
    UIScrollView *cycleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    
    cycleView.backgroundColor = HexRGB(0xf4f5f7);
    cycleView.contentSize = CGSizeMake(imgHeight * _pageNumber,imgWidth);
    cycleView.bounces = NO;
    cycleView.delegate = self;

    
    cycleView.backgroundColor = [UIColor redColor];
    for (int i = 0; i < imgs.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgHeight * i + 1 * i, 0, imgHeight, imgWidth)];
        
        UIImage *image = imgs[i];
        imageView.image = [TYTool image:image rotation:UIImageOrientationLeft];
        [cycleView addSubview:imageView];
        
        //        image.transform = CGAffineTransformMakeRotation(-M_PI/2);
    }
    
    [self.view addSubview:cycleView];
    
    [SVProgressHUD dismiss];

    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, kSCREEN_HEIGHT)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[UIImage imageNamed:@"qt_left"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, kSCREEN_HEIGHT - 44 - 32, 44, 44);
    [backView addSubview:button];
    [button addTarget:self action:@selector(defaultLeftItemPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    self.backView = backView;
    [self.view addSubview:backView];
    
    self.showBack = NO;
}

- (void)hideBackView{
    
    self.backView.xmy_x = 0;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        self.backView.xmy_x = -44;
    } completion:nil];
}

- (void)showBackView{
    
    self.backView.xmy_x = -44;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.backView.xmy_x = 0;
    } completion:nil];
}

- (void)setShowBack:(BOOL)showBack{
    
    _showBack = showBack;
    if (showBack) {
        
        [self showBackView];
    } else{
        
        [self hideBackView];
    }
}



#pragma mark 缩放手势添加和处理
- (void)addGesture{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapView:)];
    
    [self.view addGestureRecognizer:tap];
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
//    [self.cycleView addGestureRecognizer:pinch];
}
- (void)onTapView:(UITapGestureRecognizer *)sender{
    
    self.showBack = !self.showBack;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"%f", scrollView.contentOffset.x);
}


//- (void)pinchView:(UIPinchGestureRecognizer *)sender{
//
//    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
//
//        self.cycleView.transform = CGAffineTransformScale(self.cycleView.transform, sender.scale, sender.scale);
//        //刷新数据
////        SEL selector = NSSelectorFromString(@"reloadData");
//        UICollectionView *mainView = [self.cycleView valueForKey:@"mainView"];
//        [mainView reloadData];
//
//
//        sender.scale = 1;
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
