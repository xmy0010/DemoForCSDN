//
//  TYNOperation.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/22.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYNOperation.h"

@implementation TYNOperation


//重写main方法
- (void)main{
    
    if (!self.isCancelled) {
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1------%@", [NSThread currentThread]);
        }
    }
    
}

@end
