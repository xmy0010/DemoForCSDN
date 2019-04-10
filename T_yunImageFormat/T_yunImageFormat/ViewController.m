//
//  ViewController.m
//  T_yunImageFormat
//
//  Created by T_yun on 2019/3/7.
//  Copyright © 2019年 T_yun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
}

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 800*0.25, 800*0.25)];
//    [self.view addSubview:imageView];
//    [self imageShow];
//    [self jgpToPng];
//    [self pngToJpg];
    [self loadImage];
    [self convertFormatTest];
    [self testImageGray];
    [self testImageReColor];
    [self testImageReColor2];
    [self testImageHighLight];
}

//- (void)imageShow {
//    UIImage *image = [UIImage imageNamed:@"123"];
//    imageView.image = image;
//}

//- (void)jgpToPng {
//    UIImage *image = [UIImage imageNamed:@"123"];
//    NSData *data = UIImagePNGRepresentation(image);
//    UIImage *pngImage = [UIImage imageWithData:data];
//    imageView.image = pngImage;
//}
//
//- (void)pngToJpg {
//    UIImage *image = [UIImage imageNamed:@"22"];
//    NSData *data = UIImageJPEGRepresentation(image, 0.5);
//    UIImage *jpgImage = [UIImage imageWithData:data];
//    imageView.image = jpgImage;
//}

- (void)convertFormatTest {
   
    UIImage *image = [UIImage imageNamed:@"head"];
    unsigned char *imageData = [self convertUIImagetoData:image];
    UIImage *imageNew = [self convertDatatoUIImage:imageData image:image];
    UIImageView *imageView = self.imageViews[1];
    imageView.image = imageNew;

}

- (void)testImageGray {
    UIImage *image = [UIImage imageNamed:@"head"];
    unsigned char *imageData = [self convertUIImagetoData:image];
    unsigned char *imageDataNew = [self imageGrayWithData:imageData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self convertDatatoUIImage:imageDataNew image:image];
    UIImageView *imageView = self.imageViews[2];
    imageView.image = imageNew;
}

- (void)testImageReColor {
    UIImage *image = [UIImage imageNamed:@"head"];
    unsigned char *imageData = [self convertUIImagetoData:image];
    unsigned char *imageDataNew = [self imageReColorWithData:imageData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self convertDatatoUIImage:imageDataNew image:image];
    UIImageView *imageView = self.imageViews[3];
    imageView.image = imageNew;
}

- (void)testImageReColor2 {
    UIImage *image = [UIImage imageNamed:@"head"];
    unsigned char *imageData = [self convertUIImagetoData:image];
    //先灰度算法 再颜色反转
    unsigned char *imageData1 = [self imageGrayWithData:imageData width:image.size.width height:image.size.height];
    unsigned char *imageDataNew = [self imageReColorWithData:imageData1 width:image.size.width height:image.size.height];
    UIImage *imageNew = [self convertDatatoUIImage:imageDataNew image:image];
    UIImageView *imageView = self.imageViews[4];
    imageView.image = imageNew;
}

- (void)testImageHighLight {
    UIImage *image = [UIImage imageNamed:@"head"];
    unsigned char *imageData = [self convertUIImagetoData:image];

    unsigned char *imageDataNew = [self imageHighlightWithData:imageData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self convertDatatoUIImage:imageDataNew image:image];
    UIImageView *imageView = self.imageViews[5];
    imageView.image = imageNew;
}

- (void)loadImage {
   
    self.imageViews = @[].mutableCopy;
    CGFloat topMargin = 40;
    CGFloat space = 30;
    CGFloat imageWidth = ([UIScreen mainScreen].bounds.size.width - space * 3) / 2;
    for (int i = 0; i < 6; i++) {
        CGRect frame = CGRectMake(space * (i % 2 + 1) + (i % 2) * imageWidth, topMargin + i / 2 * imageWidth + (i / 2 + 1) * space, imageWidth, imageWidth);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.backgroundColor = [UIColor redColor];
        [self.view addSubview:imageView];
        [self.imageViews addObject:imageView];
        if (i == 0) {
            imageView.image = [UIImage imageNamed:@"head"];
        }
    }
}

// unsigned char*  CoreGraphsic
//1.UIImage -> CGImage  2.CGColorSpace  3.分配bit级空间 4.CGBitmap上下文 5.渲染
- (unsigned char*)convertUIImagetoData:(UIImage *)image {
    CGImageRef imageref = [image CGImage];
    CGSize image_size = image.size;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //每个像素点 4个Byte R G B A 像素点个数 = 宽 * 高
    
    //内存分配
    void *data = malloc(image_size.width * image_size.height *4);
    
    //参数1data  2\3 宽高  4 bit 5行*每行字节数 6.颜色空间
    CGContextRef context = CGBitmapContextCreate(data, image_size.width, image_size.height, 8, 4 * image_size.width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    //参数 1CGBitmap 2CGRectMake 3imageref
    CGContextDrawImage(context, CGRectMake(0, 0, image_size.width, image_size.height), imageref);
    
    // UIImage ->Data
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return (unsigned char*)data;
}

- (UIImage *)convertDatatoUIImage:(unsigned char*)imageData image:(UIImage *)imageSource {
    
    CGFloat width = imageSource.size.width;
    CGFloat height = imageSource.size.height;
    NSInteger dataLength = width * height * 4;
    
    //参数2 3 info
    CGDataProviderRef provide = CGDataProviderCreateWithData(NULL, imageData, dataLength, NULL);
    int bitsPerComponent = 8; //每个元素（RGBA）bit
    int bitsPerPixel = 32;   //每个像素位数bit
    int bytePerRow = 4 * width; //每行字节数

    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageref = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytePerRow, colorSpaceRef, bitmapInfo, provide, NULL, NO, renderIntent);
    
    UIImage *imageNew = [UIImage imageWithCGImage:imageref];
    
    CFRelease(imageref);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provide);
    return imageNew;
}

//彩色转灰度图
//映射彩色RBG到灰度RGB Gray = 0.299 * red + 0.587 * green + 0.114 * blue;
- (unsigned char*)imageGrayWithData:(unsigned char*)imageData width:(CGFloat)width height:(CGFloat)height {
    
    //1.分配内存空间 == image == w*h*4
    unsigned char* resultData = malloc(width * height * sizeof(unsigned char) * 4);
    
    //把resultData内存空间全部填成0
    memset(resultData, 0, width * height * sizeof(unsigned char) * 4);
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIndex = h * width + w; //处理到某一行的第几个像素
            // 像素RGBA == 4B
            unsigned char bitMapRed = *(imageData + imageIndex * 4);
            unsigned char bitMapGreen = *(imageData + imageIndex * 4 + 1);
            unsigned char bitMapBlue = *(imageData + imageIndex * 4 + 2);

//            int bitMap = (bitMapRed + bitMapGreen + bitMapBlue) / 3;
            int bitMap = bitMapRed*77/255 + bitMapGreen*151/255 + bitMapBlue*88/255;
            unsigned char newBitMap = bitMap > 255 ? 255 : bitMap;
            memset(resultData + imageIndex * 4, newBitMap, 1);
            memset(resultData + imageIndex * 4 + 1, newBitMap, 1);
            memset(resultData + imageIndex * 4 + 2, newBitMap, 1);
        }
    }
    
    return resultData;
}

//彩色底板算法 NewValue = 255 - oldValue
- (unsigned char *)imageReColorWithData:(unsigned char*)imageData width:(CGFloat)width height:(CGFloat)height {
    //1.分配内存空间 == image == w*h*4
    unsigned char* resultData = malloc(width * height * sizeof(unsigned char) * 4);
    
    //把resultData内存空间全部填成0
    memset(resultData, 0, width * height * sizeof(unsigned char) * 4);
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIndex = h * width + w; //处理到某一行的第几个像素
            // 像素RGBA == 4B
            unsigned char bitMapRed = *(imageData + imageIndex * 4);
            unsigned char bitMapGreen = *(imageData + imageIndex * 4 + 1);
            unsigned char bitMapBlue = *(imageData + imageIndex * 4 + 2);
            
            unsigned char newBitMapRed = 255 - bitMapRed;
            unsigned char newBitMapGreen = 255 - bitMapGreen;
            unsigned char newBitMapblue = 255 - bitMapBlue;
            memset(resultData + imageIndex * 4, newBitMapRed, 1);
            memset(resultData + imageIndex * 4 + 1, newBitMapGreen, 1);
            memset(resultData + imageIndex * 4 + 2, newBitMapblue, 1);
        }
    }
    
    return resultData;
}

//美白 算法 最小二乘法曲线拟合、公式推导、工具分析（Matlab）、深度学习、映射表
//此方法选用最简单的映射表
- (unsigned char*)imageHighlightWithData:(unsigned char*)imageData width:(CGFloat)width height:(CGFloat)height {
    unsigned char* resultData = malloc(width * height * sizeof(unsigned char) * 4);
    
    //把resultData内存空间全部填成0
    memset(resultData, 0, width * height * sizeof(unsigned char) * 4);
    
    //选8个点
    NSArray *colorArrayBase = @[@"55",@"110",@"155",@"185",@"220",@"240",@"250",@"255"];
    NSMutableArray *colorArray = @[].mutableCopy;
    int beforNum = 0;
    for (int i = 0; i < colorArrayBase.count; i++) {
        NSString *numbStr = colorArrayBase[i];
        int num = numbStr.intValue;
        float step = 0;
        if (i == 0) {
            step = num / 32.0;
            beforNum = num;
        } else {
            step = (num - beforNum) / 32.0;
        }
        for (int j = 0; j < 32; j++) {
            int newNum = 0;
            if (i == 0) {
                newNum = (int)(j*step);
            } else {
                newNum = (int)(beforNum + j*step);
            }
            NSString *newNumStr = [NSString stringWithFormat:@"%d", newNum];
            [colorArray addObject:newNumStr];
        }
        beforNum = num;
    }
    
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIndex = h * width + w; //处理到某一行的第几个像素
            // 像素RGBA == 4B
            unsigned char bitMapRed = *(imageData + imageIndex * 4);
            unsigned char bitMapGreen = *(imageData + imageIndex * 4 + 1);
            unsigned char bitMapBlue = *(imageData + imageIndex * 4 + 2);
            
            
            //colorArray :index 0 ~ 255 value
            NSString *redStr = colorArray[bitMapRed];
            NSString *greenStr = colorArray[bitMapGreen];
            NSString *blueStr = colorArray[bitMapBlue];
            unsigned char bitMapRedNew = redStr.intValue;
            unsigned char bitMapGreenNew = greenStr.intValue;
            unsigned char bitMapBlueNew = blueStr.intValue;
            
            memset(resultData + imageIndex * 4, bitMapRedNew, 1);
            memset(resultData + imageIndex * 4 + 1, bitMapGreenNew, 1);
            memset(resultData + imageIndex * 4 + 2, bitMapBlueNew, 1);

        }
    }
    return resultData;
}

@end
