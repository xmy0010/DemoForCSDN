//
//  MYPerson.h
//  T_yunSortArrayWithCustomObjs
//
//  Created by T_yun on 2016/12/23.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYPerson : NSObject

@property (nonatomic, strong) NSDate *birthDate;

-(instancetype)initWithBirthDate:(NSDate *)birthDate;

@end
