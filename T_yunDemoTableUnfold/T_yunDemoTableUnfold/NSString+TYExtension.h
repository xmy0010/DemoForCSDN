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

//是否是url
- (BOOL)isUrl;

@end
