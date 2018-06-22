//
//  TYNPerson.m
//  T_yunCopyDemo
//
//  Created by T_yun on 2018/6/14.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYNPerson.h"
#import <objc/message.h>

@implementation TYNPerson

- (instancetype)initWithName:(NSString *)name bestFriend:(TYNPerson *)bestFriend{
    
    if (self = [super init]) {
        
        _name = name;
        _bestFriend = bestFriend;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    
    NSString *name = [NSString stringWithString:self.name.mutableCopy];
    TYNPerson *copy = [[[self class] alloc] initWithName:name bestFriend:self.bestFriend.copy];
    
    return copy;
}

//- (id)copyWithZone:(NSZone *)zone{
//
//    //1.这样写出来 俩个对象 只是本身地址不同 里面所有属性指向相同地址
////    TYNPerson *copy = [[[self class] alloc] initWithName:self.name bestFriend:self.bestFriend];
//
//    //2.这样写出来 俩个对象自身地址不同 里面bestFriend属性地址不同  之后下去每一层的bestFriend属性都拷贝了。 是深层次的拷贝。  但是里面的name属性 由于实现方法 是没有进行深拷贝。
////    TYNPerson *copy = [[[self class] alloc] initWithName:self.name bestFriend:self.bestFriend.copy];
//
//    //对字符串进行可变拷贝为深拷贝
//    //3.这样写出来 对象本身 对象的各个属性  属性下面的属性均进行了拷贝 每一层都是深拷贝
//    NSString *name = [NSString stringWithString:self.name.mutableCopy];
//    TYNPerson *copy = [[[self class] alloc] initWithName:name bestFriend:self.bestFriend.copy];
//
//    return copy;
//}

//实现description方便调试
- (NSString *)description{
    
    
    if (self == nil) {
        
        return @"nil";
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self properties_aps] options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return str;
}

//Model到字典
- (NSDictionary *)properties_aps{
    
    NSMutableDictionary *props = @{@"memory":[NSString stringWithFormat:@"%p", self]}.mutableCopy;
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [[NSString alloc] initWithCString:char_f encoding:NSUTF8StringEncoding];
        id propertyValue = [self valueForKey:propertyName];

        if (propertyValue) {
            if ([propertyValue isMemberOfClass:[self class]]) {
                
                //如果属性是本类
                [props setObject:[propertyValue properties_aps] forKey:propertyName];
            } else{
                
                [props setObject:[NSString stringWithFormat:@"%p", propertyValue] forKey:propertyName];
            }

        }
    }
    free(properties);
    
    
    return props;
}


@end
