//
//  TYGestureLockController.m
//  TYGestureLockDemo
//
//  Created by T_yun on 2018/3/12.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYGestureLockController.h"
#import "TYLockView.h"

@interface TYGestureLockController ()
@property (weak, nonatomic) IBOutlet TYLockView *lockView;

@end

@implementation TYGestureLockController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lockView.lockFinishBlcok = ^(NSString *path) {
      
        
        NSString *tip = @"";
        if ([path isEqualToString:@"012345678"]) {
            
            tip = @"密码正确";
            NSLog(@"密码正确");
        } else{
            
            tip = @"密码错误";
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:tip message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    };
    
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
