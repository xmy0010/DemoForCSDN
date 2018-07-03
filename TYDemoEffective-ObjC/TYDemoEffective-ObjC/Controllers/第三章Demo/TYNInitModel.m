//
//  TYNInitModel.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/12.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYNInitModel.h"

@implementation TYNInitModel {
    
    NSMutableArray *_internalFriends;
}

//不可变拷贝
//KVC和直接指针访问属性都可以设置
//    [model setValue:_friends.copy forKey:@"_internalFriends"];
- (id)copyWithZone:(NSZone *)zone{
    
    TYNInitModel *model = [[[self class] allocWithZone:zone] initWithP1:_p1 P2:_p2 P3:_p3];
    NSArray *arr = [[NSArray alloc] initWithArray:self.friends copyItems:YES];//深拷贝
    model -> _internalFriends = arr.mutableCopy;
//    model -> _internalFriends = self.friends.mutableCopy;  //浅拷贝 数组属性
    return model;
}

//可变拷贝 有些内不好区分可变不可变 除了（容器类有非常明确的区分）
//- (id)mutableCopyWithZone:(NSZone *)zone{
//
//    TYNInitModel *model = [[[self class] allocWithZone:zone] initWithP1:_p1 P2:_p2 P3:_p3];
//    //    [model setValue:_friends.copy forKey:@"_internalFriends"];
//    model -> _internalFriends = self.friends.mutableCopy;
//    return model;
//}

//深拷贝  上面拷贝 容器里面的对象是浅拷贝
- (id)deepCopy{
    
    
    //系统实现的 深拷贝
    NSArray *arr = [[NSArray alloc] initWithArray:self.friends copyItems:YES];//深拷贝
    TYNInitModel *copyModel = [[[self class] alloc] initWithP1:_p1 P2:_p2 P3:_p3];
    copyModel -> _internalFriends = arr.mutableCopy;
    return copyModel;
}


- (NSArray *)friends{
    
    return [_internalFriends copy];
}

- (void)addFriend:(TYNInitModel *)model{
    
    [_internalFriends addObject:model];
}

//私有方法的命名应该区分
-(void)p_priveMethod{
    
    //....
}

- (void)removeFriend:(TYNInitModel *)model{
    
    [_internalFriends removeObject:model];
}


//实现类中的全能初始化方法
- (instancetype)init{
    
    //可以在此处设置成初始值
    return [self initWithP1:nil P2:nil P3:nil];
}

- (instancetype)initWithP1:(NSString *)p1{
    
    return [self initWithP1:p1 P2:nil P3:nil];
}

- (instancetype)initWithP1:(NSString *)p1 P2:(NSString *)p2 P3:(NSString *)P3{
    
    if (self = [super init]) {
        
        //此处可以做初始值筛选 例如当为空时统一赋值为xx
        _p1 = p1;
        _p2 = p2;
        _p3 = P3;
        _internalFriends = @[].mutableCopy;
    }
    return self;
}


//实现描述方法 参考 父类中的实现
//-(NSString *)description{
//
//    return [NSString stringWithFormat:@"p1 = %@,p2 = %@, p3 = %@", _p1, _p2, _p3];
//}

//此描述方法为debug 例如lldb里面po
//比如debug下得到类名和实例变量指针地址
- (NSString *)debugDescription{
    
    return [NSString stringWithFormat:@"%@:%p \n p1 = %@,p2 = %@, p3 = %@",[self class], self, _p1, _p2, _p3];

}


@end
