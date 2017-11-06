//
//  TYModel.m
//  T_yunDemoTableUnfold
//
//  Created by T_yun on 2017/11/3.
//  Copyright © 2017年 tangyun. All rights reserved.
//

#import "TYModel.h"
#import "NSString+TYExtension.h"

#define TY_ORIGIN_CELL_HEIGHT 65  //其他控件高度
#define TY_BTN_HEIGHT 25       //按钮高度
#define TY_CONTENT_HEIGHT 102 // 5行高度

@implementation TYModel

- (instancetype)initWithName:(NSString *)name content:(NSString *)content{

    if (self = [super init]) {
        
        self.name = name;
        self.content = content;
    }
    
    return self;
}

- (CGFloat)cellHeight{

    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //名字 加展开按钮高度
    CGFloat originHeight = TY_ORIGIN_CELL_HEIGHT;
    CGFloat contentHeight = [_content textHeightInWidth:screenWidth - 30 font:[UIFont systemFontOfSize:17]];
    
    if (_type == TYCellTypeNone) {
        
        //如果不可展开
        return originHeight + contentHeight - TY_BTN_HEIGHT;
    } else if (_type == TYCellTypeFold){
    
        //如果展开状态
        return originHeight + contentHeight;
    } else if (_type == TYCellTypeUnfold) {
    
        //如果是收起状态
        return originHeight + TY_CONTENT_HEIGHT;
    }
    
    return 0;
}


- (void)setContent:(NSString *)content{

    _content = content;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat contentHeight = [_content textHeightInWidth:screenWidth - 30 font:[UIFont systemFontOfSize:17]];
    if (contentHeight > TY_CONTENT_HEIGHT) {
        
        _type = TYCellTypeUnfold;
    } else{
    
        _type = TYCellTypeNone;
    }

}


@end
