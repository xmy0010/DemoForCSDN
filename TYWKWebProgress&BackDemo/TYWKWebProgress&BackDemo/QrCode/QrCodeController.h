//
//  QrCodeController.h
//  UniversallyFramework
//
//  Created by liuf on 15/11/9.
//  Copyright © 2015年 liuf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSUInteger, captureType){
    captureTypeScan     = 0,  ///摄像头扫描
//    captureTypeAR       = 1,  ///调用AR
};


@interface QrCodeController:UIViewController 


///webView 打卡扫码界面（实现该block则将扫码结果回传）
@property (nonatomic, copy) void (^webOpenQRCodeBlock)(NSString *result);

- (void)refreshScanState:(captureType)type;

@end
