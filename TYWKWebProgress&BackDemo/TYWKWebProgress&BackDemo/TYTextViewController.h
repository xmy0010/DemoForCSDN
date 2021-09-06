//
//  TYTextViewController.h
//  TYWKWebProgress&BackDemo
//
//  Created by zwzh_14 on 2021/9/6.
//  Copyright © 2021 tangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYTextViewController : UIViewController

@property (nonatomic, copy) void(^resultBlock)(NSString *result);


+ (instancetype)controller;

@end

NS_ASSUME_NONNULL_END
