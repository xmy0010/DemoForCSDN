//
//  NSTimer+TYNBlocksSupport.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/27.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "NSTimer+TYNBlocksSupport.h"

@implementation NSTimer (TYNBlocksSupport)


//这段代码将计时器所应执行的任务封装成block 在调用计时器函数时，把它作为userInfo参数传过去。 该参数可用来存放“不透明值” 只要计时器还有效，就会一直保留着它。传入参数时要通过copy方法将block拷贝到堆上，否则等到稍后要执行他的时候，该block肯能已经无效了。计时器现在的target是NSTimer类对象，这是单例，因为计时器是否会保留它都无所谓
//但是外界实例对象调用此方法的时候还是有保留环，以为传入的block捕获了实例对象，而计时器用通过userInfo参数保留了block。所有实例对象需用weak
+ (NSTimer *)tyn_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repoeats:(BOOL)repeats{
    
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(tyn_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)tyn_blockInvoke:(NSTimer *)timer{
    
    void(^block)(void) = timer.userInfo;
    if (block) {
        
        block();
    }
}


@end
