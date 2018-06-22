//
//  TYNPerson.h
//  T_yunCopyDemo
//
//  Created by T_yun on 2018/6/14.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYNPerson : NSObject <NSCopying>

@property(nonatomic, copy) NSString *name;

@property(nonatomic, strong) TYNPerson *bestFriend;

- (instancetype)initWithName:(NSString *)name bestFriend:(TYNPerson *)bestFriend;


- (NSDictionary *)properties_aps;

@end
