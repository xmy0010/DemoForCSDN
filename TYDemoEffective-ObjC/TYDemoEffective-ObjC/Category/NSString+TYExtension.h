//
//  NSString+TYExtension.h
//  LezhengAppForIOS
//
//  Created by T_yun on 2017/3/21.
//  Copyright © 2017年 lezheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TYExtension)

- (CGFloat)textHeightInWidth:(CGFloat)width font:(UIFont *)font;

- (CGFloat)textWidhtInHeight:(CGFloat)height font:(UIFont *)font;

//计算最大行数 文字高度 可以处理单行情况
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines;

- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing;

- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing;

+(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace;

//是否是url
- (BOOL)isUrl;

@end
