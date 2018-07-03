//
//  TYSmithPerson.h
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/7.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYPersonModel.h"

@interface TYSmithPerson : TYPersonModel

@property(nonatomic, assign) NSString *assignString;

@property(nonatomic, assign) NSArray *assignArray;

@property(nonatomic, copy) NSString *myCopyString;

@property(nonatomic, strong) NSString *strongString;


- (instancetype)initWithMyLastName:(NSString *)lastName;

@end
