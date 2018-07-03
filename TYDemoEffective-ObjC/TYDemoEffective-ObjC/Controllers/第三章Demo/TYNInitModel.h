//
//  TYNInitModel.h
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/12.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYBaseModel.h"



@interface TYNInitModel : TYBaseModel <NSCopying, NSMutableCopying>

@property(nonatomic, copy) NSString *p1;

@property(nonatomic, copy) NSString *p2;

@property(nonatomic, copy) NSString *p3;

//不把可变的collection作为属性公开， 而应提供相关方法，以次修改对象中的可变collection
@property(nonatomic, strong) NSArray *friends;

- (void)addFriend:(TYNInitModel *)model;

- (void)removeFriend:(TYNInitModel *)model;


- (id)deepCopy;

- (instancetype)initWithP1:(NSString *)p1;

- (instancetype)initWithP1:(NSString *)p1 P2:(NSString *)p2 P3:(NSString *)P3;


@end
