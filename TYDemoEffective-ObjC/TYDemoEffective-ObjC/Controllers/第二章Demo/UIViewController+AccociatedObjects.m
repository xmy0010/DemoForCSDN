//
//  UIViewController+AccociatedObjects.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/8.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "UIViewController+AccociatedObjects.h"

@implementation UIViewController (AccociatedObjects)

- (NSString *)associatedObject_assign{
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAssociatedObject_assign:(NSArray *)associatedObject_assign{
    
    objc_setAssociatedObject(self, @selector(associatedObject_assign), associatedObject_assign, OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)associatedObject_retain{
    
    return objc_getAssociatedObject(self, _cmd);

}

- (void)setAssociatedObject_retain:(NSArray *)associatedObject_retain{
    
    objc_setAssociatedObject(self, @selector(associatedObject_retain), associatedObject_retain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)associatedObject_copy{
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAssociatedObject_copy:(NSArray *)associatedObject_copy{
    
    objc_setAssociatedObject(self, @selector(associatedObject_copy), associatedObject_copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
