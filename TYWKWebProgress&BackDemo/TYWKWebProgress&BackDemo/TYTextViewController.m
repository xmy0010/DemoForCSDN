//
//  TYTextViewController.m
//  TYWKWebProgress&BackDemo
//
//  Created by zwzh_14 on 2021/9/6.
//  Copyright © 2021 tangyun. All rights reserved.
//

#import "TYTextViewController.h"

@interface TYTextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TYTextViewController



+ (instancetype)controller{
    TYTextViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TYTextViewController"];
    if (vc) {
        return vc;
    }
    return [[TYTextViewController alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"retainCount:%d",[self retainCount]);
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
}

- (void)endEdit {
    [self.view endEditing:YES];
}

/** 1.js调用oc跳转新页面 2.新页面输出之后pop回调用js并将输入的数据传入3.js再执行弹窗
 *说明：正常情况下调用block之后 调pop程序正常运行。
 *     当页面pop与block处理遇到UI展示bug时，可放心先pop后调用block甚至延迟调用block.
 *   本controller对象会在block调用之后才销毁（dealloc）
 *
 *
 *
 *
 **
 **
 **
 **/
///确定按钮点击
- (IBAction)onSureBtn:(id)sender {
    NSString *result = self.textView.text;
    if (result.length == 0) {
        result = @"";
    }
    __weak typeof(self) weakSelf = self;
    if (self.resultBlock) {
        [self.navigationController popViewControllerAnimated:YES];
        //0. 直接执行
        self.resultBlock(result); 

        
        //1.Timer selector
//        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(doResultBlcok) userInfo:nil repeats:NO]; //正常执行
        
        //1.Timer blcok
//        [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
//            //AF等实现（当循序引用时）
//            TYTextViewController *strong = weakSelf;
//            if (strong) {
//                NSLog(@"block执行");
//                strong.resultBlock(result);
//            }
//
//            NSLog(@"block执行");
//            __strong typeof(self) strongSelf = weakSelf;
////            strongSelf.resultBlock(result); //崩溃
////            weakSelf.resultBlock(result); //崩溃
////            self.resultBlock(result); //正常执行
//        }];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            __strong typeof(self) strongSelf = weakSelf;
//            NSLog(@"block执行");
//                    strongSelf.resultBlock(result); //崩溃
//                    weakSelf.resultBlock(result); //崩溃
//                    self.resultBlock(result); //正常执行
//        });
    }
}

/**
 *正常多线程循环引用且
 *1.weak-strong dance
 *
 *
 *
 **
 **
 **
 **/

- (void)doResultBlcok {
    NSString *result = self.textView.text;
    if (result.length == 0) {
        result = @"";
    }
    NSLog(@"block执行");
    self.resultBlock(result);
}


-(void)dealloc {
    NSLog(@"输入页面销毁");
}


@end
