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
#import "TYTextViewController.h"


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
    [config.userContentController addScriptMessageHandler:[[TYWeakScriptDelegate alloc] initWithDelegate:self] name:@"tyToController"];

    
    
    //通过默认的构造器来创建对象
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                      configuration:config];
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"JSCallOC" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:path]];
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    
    
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
    if ([message.name isEqualToString:@"tyToController"]) {
        //js调用OC中 去新的页面 拿到结果之后销毁页面并回传JS
        TYTextViewController *vc = [TYTextViewController controller];
        vc.resultBlock = ^(NSString *  result) {
            NSString *tytest =[NSString stringWithFormat:@"tytest3(%@)",result];
            [self.webView evaluateJavaScript:tytest completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                
                NSLog(@"");
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//OC调用JS
- (void)onCallJS{
    
    //调用JS方法
    NSString *tytest = [NSString stringWithFormat:@"tytest5(5)"] ;
    [self.webView evaluateJavaScript:tytest completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSLog(@"");
    }];
}

- (void)dealloc{
    
    //删除所有的回调事件
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"TYTEST"];
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"tytest3"];

}



- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
