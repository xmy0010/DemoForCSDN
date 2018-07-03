//
//  TYPersonModel.h
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/6.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYBaseModel.h"

@interface TYPersonModel : TYBaseModel

//可能动态调用存取方法的属性
@property(nonatomic, strong) NSString *string;

@property(nonatomic, strong) NSNumber *number;

@property(nonatomic, strong) NSDate *date;

@property(nonatomic, strong) id opaqueObject;
//-------

@property(nonatomic, strong) NSNumber *nonatomicNumber;

@property(atomic, strong) NSNumber *atomicNumber;

@property(nonatomic, copy) NSString *lastName;

@property(nonatomic, strong)id obj;

- (instancetype)initWithLastName:(NSString *)lastName;

- (BOOL)isEqualToPerson:(TYPersonModel *)person;


//____________完成消息转发机制例子
-(void)work;

-(void)beFriendWith:(TYPersonModel *)otherPerson;

@end
