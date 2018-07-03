//
//  TYNDemoChapter_4Controller.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/20.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYNDemoChapter_4Controller.h"
#import "TYNProtocolModel.h"
#import "TYDemo3DelegateController.h"

@interface TYNDemoChapter_4Controller ()<TYNChapter3Delegate>


@property(nonatomic, strong) UIViewController *cycleVC;

@end

@implementation TYNDemoChapter_4Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self delegateCacheDemo];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//对代理方法实现缓存 不用每次都判断
- (void)delegateCacheDemo{
    
    
    TYDemo3DelegateController *vc = [[TYDemo3DelegateController alloc] init];
    [self showViewController:vc sender:self];
    self.cycleVC = vc;
    vc.delegate = self;
    
    
}


- (void)doThingA{
    
    NSLog(@"%s", __func__);
}

//- (void)doThingB{
//
//    NSLog(@"%s", __func__);
//}

- (void)doThingC{
    
    NSLog(@"%s", __func__);
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
