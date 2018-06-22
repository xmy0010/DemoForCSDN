//
//  TYNFriend.h
//  T_yunCopyDemo
//
//  Created by T_yun on 2018/6/14.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYNFriend : NSObject<NSCopying>

@property(nonatomic, copy) NSString *name;

@property(nonatomic, strong) NSMutableArray *bestFriends;

- (instancetype)initWithName:(NSString *)name bestFriends:(NSMutableArray *)bestFriends;

- (NSDictionary *)properties_aps;


@end
