//
//  MYPerson.m
//  T_yunSortArrayWithCustomObjs
//
//  Created by T_yun on 2016/12/23.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import "MYPerson.h"

@implementation MYPerson

- (instancetype)initWithBirthDate:(NSDate *)birthDate {

    if (self = [super init]) {
        
        self.birthDate = birthDate;
    }
    
    return self;
}

- (NSComparisonResult)compare:(MYPerson *)other
{
    return [self.birthDate compare:other.birthDate];
}

@end
