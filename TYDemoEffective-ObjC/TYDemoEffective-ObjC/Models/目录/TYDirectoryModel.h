//
//  TYDirectoryModel.h
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/4.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/objc.h>

@interface TYDirectoryModel : NSObject

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *detail;

//第几小节 共52节  1-52
@property(nonatomic, assign) NSInteger section;

@property(nonatomic, assign) CGFloat cellHeight;

-(instancetype)initWithTile:(NSString *)title detail:(NSString *)detail;

@end
