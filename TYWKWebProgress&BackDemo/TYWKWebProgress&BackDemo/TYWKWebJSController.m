//
//  TYWKWebJSController.m
//  TYWKWebProgress&BackDemo
//
//  Created by T_yun on 2018/4/17.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYWKWebJSController.h"
#import <WebKit/WebKit.h>
#import "TYWeakScriptDelegate.h"


@interface TYWKWebJSController ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TYWKWebJSController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象名称，当JS通过对象来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:[[TYWeakScriptDelegate alloc] initWithDelegate:self] name:@"TYTEST"];
    [config.userContentController addScriptMessageHandler:[[TYWeakScriptDelegate alloc] initWithDelegate:self] name:@"tytest3"];

    
    
    //通过默认的构造器来创建对象
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                      configuration:config];
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"JSCallOC" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:path]];
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = self;
    
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"callJS" style:UIBarButtonItemStyleDone target:self action:@selector(onCallJS)];
    self.navigationItem.rightBarButtonItem = item;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WKScriptMessageHandler
//JS调用OC方法
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        NSLog(@"%@==%@",message.name, message.body);
}

//OC调用JS
- (void)onCallJS{
    
    //调用JS方法
    NSString *tytest =[NSString stringWithFormat:@"tytest5(6)"] ;
    [self.webView evaluateJavaScript:tytest completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSLog(@"");
    }];
}

- (void)dealloc{
    
    //删除所有的回调事件
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"TYTEST"];
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"tytest3"];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
