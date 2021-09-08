//
//  TYWeakScriptDelegate.m
//  TYWKWebProgress&BackDemo
//
//  Created by T_yun on 2018/4/17.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYWeakScriptDelegate.h"

@implementation TYWeakScriptDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
