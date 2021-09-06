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
    // Do any additional setup after loading the view.
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
    if (self.resultBlock) {
        [self.navigationController popViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"block执行");
            self.resultBlock(result);
        });
//        [self.navigationController popViewControllerAnimated:YES];
    }
}



-(void)dealloc {
    NSLog(@"输入页面销毁");
}


@end
