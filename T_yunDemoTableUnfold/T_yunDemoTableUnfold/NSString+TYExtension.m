//
//  NSString+TYExtension.m
//  LezhengAppForIOS
//
//  Created by T_yun on 2017/3/21.
//  Copyright © 2017年 lezheng. All rights reserved.
//

#import "NSString+TYExtension.h"

@implementation NSString (TYExtension)

- (CGFloat)textHeightInWidth:(CGFloat)width font:(UIFont *)font{

    NSDictionary *attributesDict = @{NSFontAttributeName:font};
    
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    
    CGRect subviewRect = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDict context:nil];
    
    return subviewRect.size.height;
}

- (CGFloat)textWidhtInHeight:(CGFloat)height font:(UIFont *)font{

    NSDictionary *attributesDict = @{NSFontAttributeName:font};
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, height);
    
    CGRect subviewRect = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDict context:nil];
    
    return subviewRect.size.width;
}

- (BOOL)isUrl
{
    if(self == nil)
        return NO;
    NSString *url;
    if (self.length>4 && [[self substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",self];
    }else{
        url = self;
    }
    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}

@end
