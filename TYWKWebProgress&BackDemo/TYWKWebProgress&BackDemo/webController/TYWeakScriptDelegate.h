//
//  TYWeakScriptDelegate.h
//  TYWKWebProgress&BackDemo
//
//  Created by T_yun on 2018/4/17.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface TYWeakScriptDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic,weak)id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;


@end
