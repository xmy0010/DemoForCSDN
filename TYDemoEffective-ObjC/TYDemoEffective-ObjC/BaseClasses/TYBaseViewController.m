//
//  TYBaseViewController.m
//  zmgk_LeZheng
//
//  Created by T_yun on 2017/5/2.
//  Copyright © 2017年 zmgk. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYBaseViewController ()

@end

@implementation TYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //置空重新获取imei判断
    self.view.backgroundColor = CORLOR_BG;
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    
    //设置navi的返回按钮
    [self setBackNavigationItem];
    

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 设置默认返回
- (void)setBackNavigationItem {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 44);
    [button setImage:[UIImage imageNamed:@"qt_left"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(defaultLeftItemPressed) forControlEvents:UIControlEventTouchUpInside];
    [button  setImageEdgeInsets: UIEdgeInsetsMake (0, -10, 0, 0)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    
    self.navigationItem.leftBarButtonItem = item;
    
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:CORLOR_3,
                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [[UINavigationBar appearance] setBarTintColor:HexRGB(0xf6f6f6)];
//    //设置阴影
//    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
////
//    [self.navigationController navigationBar].layer.shadowColor = CORLOR_6.CGColor; //shadowColor阴影颜色
//    [self.navigationController navigationBar].layer.shadowOffset = CGSizeMake(2.0f , 2.0f); //shadowOffset阴影偏移x，y向(上/下)偏移(-/+)2
//    [self.navigationController navigationBar].layer.shadowOpacity = 0.25f;//阴影透明度，默认0
//    [self.navigationController navigationBar].layer.shadowRadius = 4.0f;//阴影半径
//    self.navigationController.navigationBar.translucent = NO;
    
    
}

- (void)defaultLeftItemPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showTip:(NSString *)message{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        [alert dismissViewControllerAnimated:YES completion:nil];
//    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showTip:(NSString *)message block:(void (^)())block{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    //    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        [alert dismissViewControllerAnimated:YES completion:nil];
    //    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:block]];
    [self presentViewController:alert animated:YES completion:nil];
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
