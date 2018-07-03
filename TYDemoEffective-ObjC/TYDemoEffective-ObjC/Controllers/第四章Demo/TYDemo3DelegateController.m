//
//  TYDemo3DelegateController.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/19.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYDemo3DelegateController.h"
#import "TYNDemoChapter_3Controller.h"

@interface TYDemo3DelegateController ()

typedef struct {
    
    unsigned int doA : 1;
    unsigned int doB : 1;
    unsigned int doC : 1;
} DelegateFlags;

@property(nonatomic, assign) DelegateFlags delegateFlags;

@end


@implementation TYDemo3DelegateController

- (void)dealloc{
    
    NSLog(@"TYDemo3DelegateController释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(50, 100 * (i + 1), 100, 50);
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.backgroundColor = [UIColor redColor];
        [self.view addSubview:btn];
    }
}

- (void)btnclick:(UIButton *)sender{
    
    int tag = sender.tag;
    if (tag == 0) {
        
        if (_delegateFlags.doA) {
            
            [_delegate doThingA];
        }
    }
    if (tag == 1) {
        
        if (_delegateFlags.doB) {
            
            [_delegate doThingB];
        }
    }
    if (tag == 2) {
        
        if (_delegateFlags.doC) {
            
            [_delegate doThingC];
        }
    }
}

- (void)setDelegate:(id<TYNChapter3Delegate>)delegate{
    
    _delegate = delegate;
    _delegateFlags.doA = [self.delegate respondsToSelector:@selector(doThingA)];
    _delegateFlags.doB = [self.delegate respondsToSelector:@selector(doThingB)];
    _delegateFlags.doC = [self.delegate respondsToSelector:@selector(doThingC)];

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
