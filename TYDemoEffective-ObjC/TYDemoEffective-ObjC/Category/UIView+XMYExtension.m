//
//  UIView+XMYExtension.m
//  MyAliPay
//
//  Created by Tyun on 15/12/8.
//  Copyright (c) 2015年 Tyun. All rights reserved.
//

#import "UIView+XMYExtension.h"

@implementation UIView (XMYExtension)

- (CGFloat)xmy_height {

    return self.frame.size.height;
}

- (void)setXmy_height:(CGFloat)xmy_height {

    CGRect temp = self.frame;
    temp.size.height = xmy_height;
    self.frame = temp;
}

- (CGFloat)xmy_width {

    return self.frame.size.width;
}

- (void)setXmy_width:(CGFloat)xmy_width {

    CGRect temp = self.frame;
    temp.size.width = xmy_width;
    self.frame = temp;
}

- (CGFloat)xmy_x {

    return self.frame.origin.x;
}

- (void)setXmy_x:(CGFloat)xmy_x {

    CGRect temp = self.frame;
    temp.origin.x = xmy_x;
    self.frame = temp;
}

- (CGFloat)xmy_y {
   
    return self.frame.origin.y;
}

- (void)setXmy_y:(CGFloat)xmy_y {

    CGRect temp = self.frame;
    temp.origin.y = xmy_y;
    self.frame = temp;
}
- (UIViewController *)viewController {

    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    
//    for (UIView *next = [self superview]; next; next.superview) {
//        
//        UIResponder *responder = [next nextResponder];
//        if (responder == nil) {
//            
//            return nil;
//        }
//        if ([responder isKindOfClass:[UIViewController class]]) {
//            
//            return (UIViewController *)responder;
//        }
//    }
    
    return nil;
}

@end
