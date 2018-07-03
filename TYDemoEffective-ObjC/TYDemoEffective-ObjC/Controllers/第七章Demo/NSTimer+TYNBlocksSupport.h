//
//  NSTimer+TYNBlocksSupport.h
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/27.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (TYNBlocksSupport)

+ (NSTimer *)tyn_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(void))block repoeats:(BOOL)repeats;

@end
