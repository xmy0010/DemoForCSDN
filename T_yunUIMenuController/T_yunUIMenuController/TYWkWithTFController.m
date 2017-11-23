//
//  TYWKWebController.m
//  T_yunUIMenuController
//
//  Created by T_yun on 2017/11/6.
//  Copyright © 2017年 优谱德. All rights reserved.
//

#import "TYWkWithTFController.h"
#import <WebKit/WebKit.h>
#import "TYTextField.h"

@interface TYWkWithTFController ()

@property(nonatomic, strong)WKWebView *web;

@property(nonatomic, strong) UITextField *tf;

@property(nonatomic, assign) BOOL dismissSelf;

//遮挡
@property(nonatomic, strong) UIView *hudView;


/*
 *
 * 简单说下，当使用WKWebView且当前试图控制器需要用到输入框时。可根据事件的传递机制来动态控制试图控制器是否可以取消第一响应。从而达到目的。
 *
 *
 *
 */

@end

@implementation TYWkWithTFController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WK带输入框";
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self becomeFirstResponder];
    UIMenuController * menu = [UIMenuController sharedMenuController];
    UIMenuItem *item0 = [[UIMenuItem alloc]initWithTitle:@"自定义复制" action:@selector(copyContent:)];
    UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"添加笔记" action:@selector(addNotes:)];
    [menu setMenuItems:@[item0,item2]];
    NSString *string = @"<font size=\"8\">我字体大小为8<p>我饿神你打孙努牍按攒啊那输电脑城爱的拿出你U爱得深沉你那堵车那鱼那是大餐暖U盾那USUC你暖大怒擦苏暖戴春宁爱上当出纳孙U爱速度阿奴UN阿斯赌场怒那U盾守财奴那USD怒撒U耳机孔那段时间啊啊会计师的脑筋asd 加的那就是你缴纳手机电脑缴纳手机电脑就拿手机都能看见你觉得那可就呢我矫情无 撒娇的那就看你会计师那就看杰克丹尼就能看 那几款那几款你看见那看见看的那是可敬的年卡那可就你今年爱看见你看见卡萨丁你看见你看看就你看大口径你看看看缴纳可接纳及第三单身的房间爱手弩牛奶你看见的那颗缴纳的框架内加上那你就卡萨诺的房间开三孔目测福我文件卡那可就把第三方去看女警n哈哈哈哈收到货或者是你的是哪点餐就那啥的就看你傻就开车那就看你就看到陈建安金撒的决出那升级你加上你的处境阿森纳爱神的箭送奶茶山东济南阿萨德就能进大家蛇年大吉你都尽撒那就哪家的刹那间的难上加难就是难懂陈建安初三见到陈建安擦几十年擦拭就刹那间你觉得呢擦肩送奶茶时间内就暗示的成绩按察就你家是大年初九收藏那手机内存几年级三次就爱上你缴纳的几十年差三年产假你家电脑城就爱上你从今年初就爱上你的擦拭决出那上架的擦时间内擦拭今年初就暗示你的处境阿森纳缴纳决出那撒娇刹那间那就是大年初九你</p></font>";
    CGRect frame = self.view.bounds;
    frame.origin.y = 150;
    frame.size.height -= 150;
    WKWebView *web = [[WKWebView alloc] initWithFrame:frame];
    [web loadHTMLString:string baseURL:nil];
    self.web = web;
    [self.view addSubview:web];
    
    
    //输入框
    TYTextField *tf = [[TYTextField alloc] initWithFrame:CGRectMake(50, 100, 300, 40)];
    tf.backgroundColor = [UIColor greenColor];
    _tf = tf;
    tf.tapBlock = ^{
        
        //设置可取消第一响应
        _dismissSelf = YES;
        
        //遮挡
        _hudView.userInteractionEnabled = YES;
    };
    [self.view addSubview:tf];
    
    //遮挡
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    _hudView = view;
    view.userInteractionEnabled = NO;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapView:)]];
    [self.view addSubview:view];
    
 
    
    //监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuShow) name:UIMenuControllerDidHideMenuNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuHide) name:UIMenuControllerWillHideMenuNotification object:nil];
    
}



- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.dismissSelf = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark Notifs

//出现
- (void)menuShow{
    
//    NSLog(@"show");
}

//消失
- (void)menuHide{
    
//    NSLog(@"hide");
}

#pragma mark Actions
- (void)onTapView:(UITapGestureRecognizer *)tap{

    //点击遮挡 不允许取消第一响应
    _hudView.userInteractionEnabled = NO;
    _dismissSelf = NO;
    [self becomeFirstResponder];
    NSLog(@"");
}


#pragma mark --menutViewController
/**
 * 通过这个方法告诉UIMenuController它内部应该显示什么内容
 * 返回YES，就代表支持action这个操作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    
    //区别 输入框传入的呼出框  和 WKWebView传入的呼出框
    if (_dismissSelf) {
        
        return YES;
    } else{
    
        if (action == @selector(addNotes:)) {
            return YES; // YES ->  代表我们只监听copy: / addNotes:方法
        }
        
        return NO; // 除了上面的操作，都不支持
    }
    
    

}
//  说明控制器可以成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canResignFirstResponder {
    
    if (_dismissSelf) {
        
        return YES;
    }
    return NO;
}

- (void)addNotes:(UIMenuController *)menu {
    
    NSLog(@"");
    __weak typeof(self) weakSelf = self;
    //    Document.getSelection()  window.getSelection()
    [self.web evaluateJavaScript:@"window.getSelection().toString()" completionHandler:^(id _Nullable content, NSError * _Nullable error) {
        NSString *selectContent = (NSString *)content;
        //            NSLog(@"选中-----%@", selectContent);
        
        
        //让输入框可以响应
        _dismissSelf = YES;
        
        //点击之后可以在输入框中输入东西
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加备注" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"输入想要添加的备注";
            
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSArray *textfields = alert.textFields;
            UITextField *tf = textfields.firstObject;
            
            NSLog(@"内容:%@, 备注:%@", selectContent,tf.text);
            
            //让UIMenuController的弹窗恢复正常
            _dismissSelf = NO;
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    
    
    
    
}
- (void)copyContent:(UIMenuController *)menu {
    
    NSLog(@"自定义复制");
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
