//
//  TYSmithPerson+SmithAddition.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/12.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYSmithPerson+SmithAddition.h"

@implementation TYSmithPerson (SmithAddition)


//父类 子类  子类的分类 的load和initialize调用循序
//+[TYPersonModel initialize]
//+[TYPersonModel load]
//+[TYSmithPerson(SmithAddition) initialize]
//+[TYSmithPerson load]
//+[TYSmithPerson(SmithAddition) load]

//+ (void)load{
//    
//    NSLog(@"%@  %s",[self class], __func__);
//}
//
//+ (void)initialize{
//    
//    NSLog(@"%@  %s",[self class], __func__);
//}
@end
