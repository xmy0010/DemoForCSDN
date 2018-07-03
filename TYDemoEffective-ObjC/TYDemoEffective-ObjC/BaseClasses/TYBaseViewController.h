//
//  TYBaseViewController.h
//  zmgk_LeZheng
//
//  Created by T_yun on 2017/5/2.
//  Copyright © 2017年 zmgk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYBaseViewController : UIViewController


//默认返回
- (void)defaultLeftItemPressed;

//弹窗提示信息
- (void)showTip:(NSString *)message;

- (void)showTip:(NSString *)message block:(void(^)())block;


@end
