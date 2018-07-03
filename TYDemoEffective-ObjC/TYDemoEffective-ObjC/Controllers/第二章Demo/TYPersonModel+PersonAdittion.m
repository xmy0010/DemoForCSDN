//
//  TYPersonModel+PersonAdittion.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/12.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYPersonModel+PersonAdittion.h"

@implementation TYPersonModel (PersonAdittion)


//父类 父类的分类 子类顺序
//+[TYPersonModel(PersonAdittion) initialize]
//+[TYPersonModel load]
//+[TYSmithPerson initialize]
//+[TYSmithPerson load]
//+[TYPersonModel(PersonAdittion) load]
+ (void)load{
    
    NSLog(@"%@  %s",[self class], __func__);
}

+ (void)initialize{
    
    NSLog(@"%@  %s",[self class], __func__);
}
@end
