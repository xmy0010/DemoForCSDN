//
//  TYSmithPerson.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/7.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYSmithPerson.h"


@interface TYSmithPerson ()
{
    NSString *myLastName;
}


@end



@implementation TYSmithPerson

+ (void)load{
    
    NSLog(@"%@  %s",[self class], __func__);
}

+ (void)initialize{
    
    NSLog(@"%@  %s",[self class], __func__);
}
- (void)gotoSchool{
    
    NSLog(@"Smith go to school");
}


//当待初始化的实例变量声明在超类中，而我们又无法再子类中直接访问此实例变量的话，那么就需要调用setter方法
-(instancetype)initWithMyLastName:(NSString *)lastName{
    
    if (self = [super init]) {
        
        self.lastName = lastName;
    }
    
    return self;
}

//覆写属性的setter方法
-(void)setLastName:(NSString *)lastName{
    
    if (![lastName isEqualToString:@"Smith"]) {
        
        [NSException raise:NSInvalidArgumentException format:@"Last name must be Smith"];
    }
    
    
    myLastName = lastName;
}

- (NSString *)lastName{
    
    return myLastName;
}

@end
