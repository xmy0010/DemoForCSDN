//
//  MYAnimationView.h
//  TyunStackDemos
//
//  Created by T_yun on 2017/1/12.
//  Copyright © 2017年 优谱德. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^completeBlock)(BOOL finished);


@interface MYAnimationView : UIView

//动画完成回调
@property (nonatomic,copy) void(^completeBlock)(BOOL finished);

//计数生效回调
@property (nonatomic, copy) void (^countBlock)(BOOL);

//默认0.15秒
@property (nonatomic, assign) CGFloat animationDuration;

//图片名字
@property (nonatomic, copy) NSString *imageName;


- (instancetype)initWithOriginY:(CGFloat)originY imageWidth:(CGFloat)imageWidth;

- (void)animateWithCompleteBlock:(completeBlock)completed
                          isLeft:(BOOL)isLeft;

- (void)drawView;


@end
