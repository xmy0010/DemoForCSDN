//
//  NSString+EOCMethodSwizzling.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/12.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "NSString+EOCMethodSwizzling.h"

@implementation NSString (EOCMethodSwizzling)

+(void)load{
    
//    原因是runtime调用+(void)load的时候，程序还没有建立其autorelease pool，所以那些会需要使用到autorelease pool的代码，都会出现异常。这一点是非常需要注意的，也就是说放在+(void)load中的对象都应该是alloc出来并且不能使用autorelease来释放。

    
    Method originalMethod = class_getInstanceMethod([NSString class], @selector(lowercaseString));
    Method swappedMethod = class_getInstanceMethod([NSString class], @selector(ty_myLowercaseString));
    method_exchangeImplementations(originalMethod, swappedMethod);
}

- (NSString *)ty_myLowercaseString{
    
    //此方法看起来是死循环 实际上此方法是准备和lowercaseString互换的，所以ty_myLowercaseString选择子实际上对应原有的lowercaseString实现
    //目的是为本来不透明的lowercaseString提供日志打印功能 很少有用此方法来永久改动某个类的功能，一般用作调试
    NSString *lowercase = [self ty_myLowercaseString];
    NSLog(@"%@ => %@", self, lowercase);
    return lowercase;
}

@end
