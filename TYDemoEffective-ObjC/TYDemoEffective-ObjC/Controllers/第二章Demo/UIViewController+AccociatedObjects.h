//
//  UIViewController+AccociatedObjects.h
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/8.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

// Associated Objects
//主要使用场景 1.为现有的类添加私有变量以帮助实现细节 2.为现有的类添加共有属性 3.为KVO创建一个关联的观察者（不常用）
//设置时KEY选择 1.声明 static char kAssociatedObjectKey; ，使用 &kAssociatedObjectKey 作为 key 值;
//2.声明 static void *kAssociatedObjectKey = &kAssociatedObjectKey; ，使用 kAssociatedObjectKey 作为 key 值；
//3.用 selector ，使用 getter 方法的名称作为 key 值。(此方法为最佳方法)


@interface UIViewController (AccociatedObjects)

@property(nonatomic, assign) NSArray *associatedObject_assign;

@property(nonatomic, strong) NSArray *associatedObject_retain;

@property(nonatomic, copy) NSArray *associatedObject_copy;


@end
