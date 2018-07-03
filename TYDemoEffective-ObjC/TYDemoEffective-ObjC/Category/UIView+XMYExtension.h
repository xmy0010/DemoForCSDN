//
//  UIView+XMYExtension.h
//  MyAliPay
//
//  Created by Tyun on 15/12/8.
//  Copyright (c) 2015年 Tyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XMYExtension)

@property (nonatomic, assign) CGFloat xmy_height;
@property (nonatomic, assign) CGFloat xmy_width;

@property (nonatomic, assign) CGFloat xmy_y;
@property (nonatomic, assign) CGFloat xmy_x;


//获取该视图 所在的VC
- (UIViewController *)viewController;

@end
