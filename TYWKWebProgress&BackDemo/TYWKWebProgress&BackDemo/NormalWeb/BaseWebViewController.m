//
//  BaseWebViewController.m
//  ThePartyBuild
//
//

#import "BaseWebViewController.h"

static NSArray *menuItems;

@interface BaseWebViewController ()<WKNavigationDelegate,NSXMLParserDelegate>


//@property (nonatomic, strong) SKPlaceholderView *placeholderView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initCustomWebView];

    [self loadHtml5WebViewurlString:self.urlString];
//    [self loadHtml5WebViewurlString:@"http://10.100.44.17:8020/stdk/entry.html?__hbt=1630481483075"];

    
}

- (void)viewDidAppear:(BOOL)animated{

//    UIButton *red = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    red.backgroundColor = [UIColor redColor];
//    [red addTarget:self action:@selector(onRed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:red];
}

- (void)onRed{

    [self loadHtml5WebViewurlString:@"http://192.168.0.187:8088/Frequency/20171213/7163a663-4621-4333-a5b1-ee08dbe71f57.mp3"];
}
#pragma mark -- setter
- (void)setUrlID:(NSString *)urlID {
    
    if ([urlID containsString:@"http"]) {
        _urlString = urlID;
    } else {
//        NSString *urlString = [NSString stringWithFormat:@"%@/rest/article/info/%@",InterfaceIPAddress,urlID];
//        _urlString = urlString;
    }
}
- (void)setNewsTitle:(NSString *)newsTitle {
    _newsTitle = newsTitle;
    self.navigationItem.title = newsTitle;
}

#pragma mark -- getter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
- (void)initCustomWebView {
   
    self.navigationItem.title = @"详情";
    //UIMenuController
    [self becomeFirstResponder];
    UIMenuController * menu = [UIMenuController sharedMenuController];
    menuItems = [UIMenuController sharedMenuController].menuItems;
    
    UIMenuItem *item0 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyContent:)];
    UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"添加笔记" action:@selector(addNotes:)];
    [menu setMenuItems:@[item0,item2]];
    
    //    updateVisibleContentRects
    CGFloat kScreen_Width = [UIScreen mainScreen].bounds.size.width;
    CGFloat kScreen_Height = [UIScreen mainScreen].bounds.size.height;
//    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, 150)];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64)];
    webView.scrollView.bounces = NO;
    webView.allowsBackForwardNavigationGestures = YES;
    webView.scrollView.scrollEnabled = NO;
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:webView];
    webView.navigationDelegate = self;

    
    _webView = webView;
//    if ([UserOperation shareInstance].netState == NetworkConditionNotReachable) {
//        [_webView addSubview:self.placeholderView];
//    }

    [self loadWebView];
}
- (void)loadWebView {

    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
//    NSString *token = [UserOperation shareInstance].token_user;
//    [request addValue:token forHTTPHeaderField:@"token"];
    [_webView loadRequest:request];
}
- (void)loadHtml5WebViewurlString:(NSString *)urlString {
    
//    NSString * strUrl = [Helper stringTransformCoding:urlString];
//    DDLogDebug(@"%@",strUrl);
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    
//    DDLogInfo(@"URL -- %@",webView.URL);
//    if (_placeholderView) {
//        [self.placeholderView setHidden:YES];
//    }
    NSString *doc = @"document.body.outerHTML";
    [webView evaluateJavaScript:doc completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
        if (error) {
//            DDLogDebug(@"JSError:%@",error);
        }
//        DDLogInfo(@"html:%@",htmlStr);

        NSData *data =[htmlStr dataUsingEncoding:NSUTF8StringEncoding];
        //1.创建NSXMLParser
        NSXMLParser *XMLParser = [[NSXMLParser alloc] initWithData:data];
        //2.设置代理
        [XMLParser setDelegate:self];
        //3.开始解析
        [XMLParser parse];
    }] ;
}





#pragma mark -- kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"title"]) {
        
        NSString *forwardTitle = change[@"new"];
        if (forwardTitle.length > 7) {
            self.navigationItem.title = [NSString stringWithFormat:@"%@...",[forwardTitle substringToIndex:7]];
        } else {
            self.navigationItem.title = forwardTitle;
        }
        
//        DDLogInfo(@"%@",forwardTitle);
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"])  {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1)
        {
            [self.progressView setProgress:1 animated:YES];
            self.progressView.hidden = YES;
        } else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}
//- (SKPlaceholderView *)placeholderView {
//    if(!_placeholderView) {
//        
//        _placeholderView = [[SKPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, CGRectGetHeight(self.webView.frame)) placeholderType:SKPlaceholderViewSimpleType];
//        [_placeholderView setDelegate:self];
//        _placeholderView.imageName = @"defaultPlaceholder_noNetwork_icon";
//        _placeholderView.titleLabel.text = @"网络异常，点击屏幕重新加载";
//        _placeholderView.titleLabel.textColor = Color_9;
//        [self.webView addSubview:_placeholderView];
//    }
//    return _placeholderView;
//}
- (UIProgressView *)progressView {
    if (!_progressView) {
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 0)];
        
        progressView.tintColor = [UIColor whiteColor];
        progressView.trackTintColor = [UIColor clearColor];
        [self.navigationController.view addSubview:progressView];
        self.progressView = progressView;
    }
    return _progressView;
}
#pragma mark -SKPlaceholderViewdelegate
- (void)placeholderViewButtonActionDetected:(UIButton *)sender {
    
    [self loadWebView];
}
#pragma mark - NSXMLParserDelegate
//1.开始解析XML文件
-(void)parserDidStartDocument:(NSXMLParser *)parser{
//    DDLogDebug(@"开始解析XML文件");
}
//2.解析XML文件中所有的元素
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
//    DDLogDebug(@"解析XML文件中所有的元素:elementName:%@,attributeDict:%@",elementName,attributeDict);
    [self.dataArray addObject:attributeDict];
}
//3.XML文件中每一个元素解析完成
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
//    DDLogDebug(@"XML文件中每一个元素解析完成:elementName:%@,qName:%@",elementName,qName);
}
//4.XML所有元素解析完毕
-(void)parserDidEndDocument:(NSXMLParser *)parser{

    //除了body没有其他元素说明网页出错
//    if (self.dataArray.count < 2) {
//        [self.placeholderView setHidden:NO];
//    }
}
#pragma mark --menutViewController
/**
 * 通过这个方法告诉UIMenuController它内部应该显示什么内容
 * 返回YES，就代表支持action这个操作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    NSLog(@"%@", NSStringFromSelector(action));
    if (action == @selector(copyContent:) ||
        action == @selector(addNotes:)) {
        return YES; // YES ->  代表我们只监听copy: / addNotes:方法
    }
    return NO; // 除了上面的操作，都不支持
}
//  说明控制器可以成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canResignFirstResponder {
    return NO;
}

- (void)addNotes:(UIMenuController *)menu {

    //将剪切板文字赋值给label
//    [SKHUDManager showLoading];
    __weak typeof(self) weakSelf = self;
//    Document.getSelection()  window.getSelection()
    [self.webView evaluateJavaScript:@"window.getSelection().toString()" completionHandler:^(id _Nullable content, NSError * _Nullable error) {
        NSLog(@"%s %@,**%@,%@", __func__, menu,content,self.urlString);
        NSString *selectContent = (NSString *)content;
        NSLog(@"%@", selectContent);
        //暂时在这里处理添加笔记的操作
//        [InterfaceManager addNotesTitle:weakSelf.newsTitle content:selectContent success:^(id result) {
//            if ([ThePartyHelper showPrompt:YES returnCode:result]) {
//                [SKHUDManager showBriefAlert:@"笔记添加成功"];
//            }
//        } failed:^(id error) {
//        }];
    }];
}
- (void)copyContent:(UIMenuController *)menu {
    
    [self.webView evaluateJavaScript:@"window.getSelection().toString()" completionHandler:^(id _Nullable content, NSError * _Nullable error) {
        [UIPasteboard generalPasteboard].string = content;
        NSLog(@"%@", content);

    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIMenuController sharedMenuController].menuItems = menuItems;

}

#pragma mark - dealloc
- (void)dealloc {
    
    //移除 kvo
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    if (_progressView) [_progressView removeFromSuperview];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
