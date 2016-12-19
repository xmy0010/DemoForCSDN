//
//  TyunModel.h
//  T_yunTableViewEditActions
//
//  Created by T_yun on 2016/12/19.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TyunModel : NSObject

@property (nonatomic, assign) int ID;

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithName:(NSString *)name ID:(int)ID;

@end
