//
//  Model.h
//  CSDN_TableView_allSelected
//
//  Created by T_yun on 2016/12/15.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import <Foundation/Foundation.h>

//测试用的Model类  需要每一个对象又不同的唯一标识符
@interface Model : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithID:(NSString *)ID name:(NSString *)name;

@end
