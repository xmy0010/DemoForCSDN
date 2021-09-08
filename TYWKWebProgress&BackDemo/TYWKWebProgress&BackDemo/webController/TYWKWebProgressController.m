//
//  TYWKWebProgressController.m
//  TYWKWebProgress&BackDemo
//
//  Created by T_yun on 2018/3/22.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYWKWebProgressController.h"
#import <WebKit/WebKit.h>


@interface TYWKWebProgressController ()<WKNavigationDelegate, WKUIDelegate>

@property(nonatomic, strong) WKWebView *web;
@property(nonatomic, strong) UIProgressView *progress;

@end

@implementation TYWKWebProgressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI
- (void)initUI{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(onBackItem)];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStyleDone target:self action:@selector(onCloseItem)];
    
    self.navigationItem.leftBarButtonItems = @[backItem, closeItem];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 2)];
    self.progress.transform = CGAffineTransformMakeScale(1.0, 1.5);
    self.progress.backgroundColor = [UIColor blueColor];
    [self.view addSubview:progress];
    self.progress = progress;
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.allowsPictureInPictureMediaPlayback = YES;
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight - 64) configuration:config];
    [self.view addSubview:web];
    web.navigationDelegate = self;
    web.UIDelegate = self;

    self.web = web;
    
    [web addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];

}

#pragma mark Actions
- (void)onBackItem{
    if ([self.web canGoBack]) {
        [self.web goBack];
    } else{
       
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (void)onCloseItem{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progress.progress = self.web.estimatedProgress;
        if (self.progress.progress == 1) {
            
            //将progress高度变成1.4倍 在开始加载网页的代理中会恢复1.5倍
            __weak typeof(self)weakSelf = self;
            [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                weakSelf.progress.transform = CGAffineTransformMakeScale(1.0, 1.4);
            
            } completion:^(BOOL finished) {
               
                weakSelf.progress.hidden = YES;
            }];
        }
    }
}

#pragma mark WKNavigationDelegate
    //开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    

    self.progress.hidden = NO;
    self.progress.transform = CGAffineTransformMakeScale(1.0, 1.5);
    [self.view bringSubviewToFront:self.progress]; // 将progress放到最前面
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
//    self.progress.hidden = YES;
}
//加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    self.progress.hidden = YES;
}
//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许页面跳转
    NSLog(@"%@",navigationAction.request.URL);
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)dealloc{
    
    [self.web removeObserver:self forKeyPath:@"estimatedProgress"];
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
