//
//  TYBaseModel.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/4.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYBaseModel.h"

@implementation TYBaseModel


//基类实现描述  获取本类的所有属性 并呈现
//子类的描述也会调用此方法
//- (NSString *)description{
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self properties_aps] options:NSJSONWritingPrettyPrinted error:nil];
//  
//    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//}

//获取所有属性名
- (NSArray *)getAllProperties{
    
    
    unsigned int count;//记录属性的个数
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    //遍历
    NSMutableArray *mArray = @[].mutableCopy;
    for (int i = 0; i < count; i++) {
        
        //An opaque type that represents an Objective-c declared property.
        //obj_property_t 属性类型
        objc_property_t property = properties[i];
        
        //获取属性名称 c语言字符串
        const char *cName = property_getName(property);

        
        //转换成OC的字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        

        [mArray addObject:name];
    }
    
    //mArray里装了所有的属性名称
    return mArray;
}

//Model到字典
- (NSDictionary *)properties_aps{
    
    NSMutableDictionary *props = @{}.mutableCopy;
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [[NSString alloc] initWithCString:char_f encoding:NSUTF8StringEncoding];
        id propertyValue = [self valueForKey:propertyName];
        if ([propertyValue isKindOfClass:[NSArray class]] || [propertyValue isKindOfClass:[NSDictionary class]] || [propertyValue isKindOfClass:[NSSet class]]) {
            //如果属性是容器  直接调用容器的description方法用来表示
            //很多换行 之类的  固用deBugDescription表示
            
            propertyValue = [propertyValue debugDescription];
        }
        if (property) {
            
            [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);

    
    return props;
}


@end
