//
//  TyunModel.m
//  T_yunTableViewEditActions
//
//  Created by T_yun on 2016/12/19.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import "TyunModel.h"

@implementation TyunModel

- (instancetype)initWithName:(NSString *)name ID:(int)ID {

    if (self = [super init]) {
        
        self.name = name;
        self.ID = ID;
    }
    
    return self;
}

@end
