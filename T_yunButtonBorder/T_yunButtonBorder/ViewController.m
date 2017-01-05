//
//  ViewController.m
//  T_yunButtonBorder
//
//  Created by T_yun on 2017/1/5.
//  Copyright © 2017年 优谱德. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *m_btnEthinic = @[].mutableCopy;
    for (int i = 0; i < 8; i++) {
        
        UIButton *btnEthnicity = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnEthnicity setTitle:[NSString stringWithFormat:@"btn%d", i] forState:UIControlStateNormal];
        btnEthnicity.frame = CGRectMake(50, 50 + 40 * i, 50, 20);
        btnEthnicity.backgroundColor = [UIColor redColor];
        [btnEthnicity addTarget:self action:@selector(btnEthnicityTouchDown:) forControlEvents: UIControlEventTouchDown];
        [btnEthnicity addTarget:self action:@selector(btnEthnicityTouchUp:) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview:btnEthnicity];
        [m_btnEthinic addObject:btnEthnicity];
    }
}


- (void)btnEthnicityTouchDown:(UIButton *)sender {
    
    NSLog(@"down");
    sender.layer.borderWidth = 2;
    sender.layer.cornerRadius = 10;
    sender.layer.borderColor = [UIColor greenColor].CGColor;
}

- (void)btnEthnicityTouchUp:(UIButton *)sender {
    
    NSLog(@"up");
    sender.layer.borderWidth = 0;
    sender.layer.cornerRadius = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
