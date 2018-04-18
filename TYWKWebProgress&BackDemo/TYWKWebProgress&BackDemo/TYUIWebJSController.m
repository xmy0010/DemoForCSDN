//
//  TYUIWebJSController.m
//  TYWKWebProgress&BackDemo
//
//  Created by T_yun on 2018/4/17.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYUIWebJSController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface TYUIWebJSController ()<UIWebViewDelegate>

@property(nonatomic, strong)UIWebView *web;
@property (strong, nonatomic) JSContext *context;


@end

@implementation TYUIWebJSController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"JSCallOC.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    
    self.web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.web loadRequest:request];
    [self.view addSubview:self.web];
    self.web.delegate = self;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"callJS" style:UIBarButtonItemStyleDone target:self action:@selector(onCallJS)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //JS调用OC方法 此处实现
    self.context[@"tytest"] = ^(NSString *str){
       


        NSLog(@"%@", str);
    };
    self.context[@"tytest3"] = ^(NSString *str){
        
        NSLog(@"%@", str);
    };
    
    

}

//OC调用JS
- (void)onCallJS{
    
    self.context = [self.web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *js =[NSString stringWithFormat:@"tytest5(6)"] ;
    [self.context evaluateScript:js];
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
