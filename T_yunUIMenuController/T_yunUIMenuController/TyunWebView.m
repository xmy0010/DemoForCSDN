//
//  TyunWebView.m
//  T_yunUIMenuController
//
//  Created by T_yun on 16/10/27.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import "TyunWebView.h"

@interface TyunWebView ()

@property(nonatomic, copy) NSString *content;

@end

@implementation TyunWebView

- (instancetype)initWithFrame:(CGRect)frame content:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self becomeFirstResponder];
        
        [self createMenu];
        
        self.content = content;
    }
    return self;
}


//构建UIMenuController
- (void)createMenu {

    UIMenuController *menu = [UIMenuController sharedMenuController];
//    UIMenuItem *item0 = [[UIMenuItem alloc] initWithTitle:@"加黑体" action:@selector(copy:)];
//    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"--" action:@selector(toggleItalics:)];
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"打印选中文字" action:@selector(logSelectedText:)];
    
    [menu setMenuItems:@[
//                         item0,
//                         item1,
                         item2]];
}

//内容的setter方法里面加载
- (void)setContent:(NSString *)content {
    
    _content = content;
    [self loadHTMLString:content baseURL:nil];
}




//指定menu响应事件 屏蔽系统自带响应事件
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    if (action == @selector(copy:) ||
        action == @selector(selectAll:) ||
        action == @selector(logSelectedText:)) {
        
        return YES;
    }
    
    return NO;
    
    
}

//允许成为第一响应
- (BOOL)becomeFirstResponder {

    return YES;
}


#pragma mark 实现自定义方法
- (void)logSelectedText:(UIMenuController *)menu {

    //先复制到粘贴板 再打印粘贴板上的内容
    [self copy:menu];
    NSLog(@"选中的文字为:%@", [UIPasteboard generalPasteboard].string);
    NSLog(@"选中的文字为:%@", [self getSelectedText]);
}

//- (void)ooincreaseSize:(UIMenuController *)menu {
//
//    [self increaseSize:menu];
//}
//崩溃
//- (void)tyunToggleBoldface:(UIMenuController *)menu {
//
////    [self toggleBoldface:menu];
//    
//}

//UIWebView自带获取选中文字的方法
- (NSString *)getSelectedText {

    return [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
