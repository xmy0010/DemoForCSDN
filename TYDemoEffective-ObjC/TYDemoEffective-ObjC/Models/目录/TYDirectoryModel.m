//
//  TYDirectoryModel.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/4.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYDirectoryModel.h"

@implementation TYDirectoryModel

-(instancetype)initWithTile:(NSString *)title detail:(NSString *)detail{
    
    if (self = [super init]) {
        
        self.title = title;
        self.detail = detail;
    }
    
    return self;
}

- (CGFloat)cellHeight{
    
    CGFloat baseHeight = 25;
    CGFloat titleHeight = [self.title textHeightInWidth:kSCREEN_WIDTH - 30 font:[UIFont systemFontOfSize:16]];
    CGFloat detailHeight = [self.detail textHeightInWidth:kSCREEN_WIDTH - 30 font:[UIFont systemFontOfSize:14]];
    
    return baseHeight + titleHeight + detailHeight;
}

@end
