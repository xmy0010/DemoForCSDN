//
//  ViewController.m
//  T_yunUIMenuController
//
//  Created by T_yun on 16/10/27.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import "ViewController.h"
#import "TyunWebView.h"
#import "TYWKWebController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI
- (void)createUI{

    NSString *string = @"<p>我饿神你打孙努牍按攒啊那输电脑城爱的拿出你U爱得深沉你那堵车那鱼那是大餐暖U盾那USUC你暖大怒擦苏暖戴春宁爱上当出纳孙U爱速度阿奴UN阿斯赌场怒那U盾守财奴那USD怒撒U耳机孔那段时间啊啊会计师的脑筋asd 加的那就是你缴纳手机电脑缴纳手机电脑就拿手机都能看见你觉得那可就呢我矫情无 撒娇的那就看你会计师那就看杰克丹尼就能看 那几款那几款你看见那看见看的那是可敬的年卡那可就你今年爱看见你看见卡萨丁你看见你看看就你看大口径你看看看缴纳可接纳及第三单身的房间爱手弩牛奶你看见的那颗缴纳的框架内加上那你就卡萨诺的房间开三孔目测福我文件卡那可就把第三方去看女警n哈哈哈哈收到货或者是你的是哪点餐就那啥的就看你傻就开车那就看你就看到陈建安金撒的决出那升级你加上你的处境阿森纳爱神的箭送奶茶山东济南阿萨德就能进大家蛇年大吉你都尽撒那就哪家的刹那间的难上加难就是难懂陈建安初三见到陈建安擦几十年擦拭就刹那间你觉得呢擦肩送奶茶时间内就暗示的成绩按察就你家是大年初九收藏那手机内存几年级三次就爱上你缴纳的几十年差三年产假你家电脑城就爱上你从今年初就爱上你的擦拭决出那上架的擦时间内擦拭今年初就暗示你的处境阿森纳缴纳决出那撒娇刹那间那就是大年初九你</p>";
    
    TyunWebView *web = [[TyunWebView alloc] initWithFrame:self.view.bounds content:string];
//    [web loadHTMLString:string baseURL:nil];
    [self.view addSubview:web];
    
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 300, 40)];
    tf.backgroundColor = [UIColor greenColor];
    tf.placeholder = @"如果不加判断 返回无法使用输入框";
    [self.view addSubview:tf];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"使用WkWeb" style:UIBarButtonItemStyleDone target:self action:@selector(onWkweb)];
    self.navigationItem.rightBarButtonItem = item;
}


//用WKWebView实现
- (void)onWkweb{

    TYWKWebController *vc = [[TYWKWebController alloc] init];
    [self showViewController:vc sender:nil];
}
@end
