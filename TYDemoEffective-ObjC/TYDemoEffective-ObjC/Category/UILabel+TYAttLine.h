//
//  UILabel+TYAttLine.h
//  Sheyang_GovHotline_iOS
//
//  Created by T_yun on 2017/12/12.
//  Copyright © 2017年 tangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TYAttLine)

//是否显示为一行（当一行的时候 不设置行间距）
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing;

@end
