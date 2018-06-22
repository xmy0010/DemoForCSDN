//
//  TYNFriend.m
//  T_yunCopyDemo
//
//  Created by T_yun on 2018/6/14.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYNFriend.h"
#import <objc/message.h>

@implementation TYNFriend

- (instancetype)initWithName:(NSString *)name bestFriends:(NSMutableArray *)bestFriends{
    
    if (self = [super init]) {
        
        _name = name;
        _bestFriends = bestFriends;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    
    NSString *name = [NSString stringWithString:self.name.mutableCopy];
    TYNFriend *copy = [[[self class] alloc] initWithName:name bestFriends:[[NSMutableArray alloc] initWithArray:self.bestFriends copyItems:YES]];
    return copy;
}

//- (id)copyWithZone:(NSZone *)zone{
//
//    //1.这样写  拷贝对象里面的属性地址不一样 但是friends属性里面的元素开始完全一样。  原因为self.bestFriends.mutableCopy，对数组进行了单层次深拷贝
////    NSString *name = [NSString stringWithString:self.name.mutableCopy];
////    TYNFriend *copy = [[[self class] alloc] initWithName:name bestFriends:self.bestFriends.mutableCopy];
//
//
//
//    //2.这样写出来 对象本身 对象的各个属性  容器属性下面的属性均进行了拷贝 每一层都是深拷贝
//    NSString *name = [NSString stringWithString:self.name.mutableCopy];
//
//    TYNFriend *copy = [[[self class] alloc] initWithName:name bestFriends:[[NSMutableArray alloc] initWithArray:self.bestFriends copyItems:YES]];
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
            if ([propertyValue isKindOfClass:[NSArray class]]) {
                
                NSMutableDictionary *dic = @{}.mutableCopy;
                for (id obj in propertyValue) {
                    if ([obj isMemberOfClass:[self class]]) {
                        
                        [dic setObject:[obj properties_aps] forKey:[NSString stringWithFormat:@"%p", obj]];
                    }
                }
                [props setObject:dic forKey:[NSString stringWithFormat:@"friends:%p", propertyValue]];
            } else{
                
                [props setObject:[NSString stringWithFormat:@"%p", propertyValue] forKey:propertyName];
            }
            
        }
    }
    free(properties);
    
    
    return props;
}



@end
