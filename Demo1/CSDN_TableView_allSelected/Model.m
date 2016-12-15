//
//  Model.m
//  CSDN_TableView_allSelected
//
//  Created by T_yun on 2016/12/15.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import "Model.h"

@implementation Model

- (instancetype)initWithID:(NSString *)ID name:(NSString *)name {

    if (self = [super init]) {
        
        self.ID = ID;
        self.name = name;
    }
    
    return self;
}

@end
