//
//  TYModel.h
//  T_yunDemoTableUnfold
//
//  Created by T_yun on 2017/11/3.
//  Copyright © 2017年 tangyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, TYCellType) {

    TYCellTypeNone, //不可展开
    TYCellTypeFold, //折叠状态
    TYCellTypeUnfold, //展开状态
};


@interface TYModel : NSObject

@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) NSString *content;

@property(nonatomic, assign) TYCellType type;

//cell高度
@property(nonatomic, assign) CGFloat cellHeight;


- (instancetype)initWithName:(NSString *)name content:(NSString *)content;

@end
