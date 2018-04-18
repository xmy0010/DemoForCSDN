//
//  ViewController.m
//  TYWKWebProgress&BackDemo
//
//  Created by T_yun on 2018/3/22.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "ViewController.h"
#import "TYUIWebJSController.h"
#import "TYWKWebJSController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goUIWeb:(id)sender {
    TYUIWebJSController *vc = [[TYUIWebJSController alloc] init];
    [self showViewController:vc sender:nil];
    
}
- (IBAction)goWKWeb:(id)sender {
    
    TYWKWebJSController *vc = [[TYWKWebJSController alloc] init];
    [self showViewController:vc sender:nil];
}




@end
