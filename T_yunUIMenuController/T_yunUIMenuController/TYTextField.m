//
//  TYTextField.m
//  T_yunUIMenuController
//
//  Created by T_yun on 2017/11/23.
//  Copyright © 2017年 优谱德. All rights reserved.
//

#import "TYTextField.h"

@implementation TYTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    //回调点击事件
    if (_tapBlock) {
        
        _tapBlock();
    }
    [super touchesBegan:touches withEvent:event];
}


@end
