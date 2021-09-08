//
//  ARNewsSceneNode.m
//  UniversalQRCode
//
//  Created by lxin on 2019/1/16.
//  Copyright © 2019 OMT. All rights reserved.
//

#import "ARNewsSceneNode.h"

static NSString *ARNewsSceneNodePositionKey = @"ARNewsSceneNodePositionKey";
static NSString *ARNewsSceneNodeScaleKey = @"ARNewsSceneNodeScaleKey";
static NSString *ARNewsSceneNodeRotateKey = @"ARNewsSceneNodeRotateKey";

@implementation ARNewsSceneNode

- (void)startAnimation {
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    //1.1告诉系统要执行什么动画
    CGFloat random = rand() % 40 - 20;
    NSValue *value1=[NSValue valueWithSCNVector3:SCNVector3Make(self.position.x, self.position.y, self.position.z)];
    NSValue *value2=[NSValue valueWithSCNVector3:SCNVector3Make(self.position.x-random, self.position.y+random, self.position.z+random)];
    NSValue *value3=[NSValue valueWithSCNVector3:SCNVector3Make(self.position.x, self.position.y, self.position.z)];
    NSValue *value4=[NSValue valueWithSCNVector3:SCNVector3Make(self.position.x+random, self.position.y-random, self.position.z-random)];
    NSValue *value5=[NSValue valueWithSCNVector3:SCNVector3Make(self.position.x, self.position.y, self.position.z)];
    keyAnima.values=@[value1, value2, value3, value4, value5];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=4;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    keyAnima.repeatCount = FLT_MAX;
    
    //设置代理，开始—结束
    //    keyAnima.delegate=self;
    //2.添加核心动画
    [self addAnimation:keyAnima forKey:ARNewsSceneNodePositionKey];
    
    self.scale = SCNVector3Make(0.5, 0.5, 0.5);
    self.physicsField = [SCNPhysicsField springField];
    SCNAction *scale = [SCNAction scaleTo:1.0 duration:0.25];
    [self runAction:scale forKey:ARNewsSceneNodeScaleKey];
}

- (void)endAnimation {
    [self removeAnimationForKey:ARNewsSceneNodePositionKey];
    [self removeActionForKey:ARNewsSceneNodeScaleKey];
}

- (void)startRotateAnimation {
    SCNAction *rotate = [SCNAction rotateByX:0 y:M_PI * 2 z:0 duration:2];
    [self runAction:rotate forKey:ARNewsSceneNodeRotateKey];
}

- (void)endRotateAnimation {
    [self removeActionForKey:ARNewsSceneNodeRotateKey];
}

@end
