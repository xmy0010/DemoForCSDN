//
//  TYNDemoChapter_7Controller.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/26.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYNDemoChapter_7Controller.h"
#import "NSTimer+TYNBlocksSupport.h"

@interface TYNDemoChapter_7Controller ()


@property(nonatomic, strong) NSTimer *timer;
@end

@implementation TYNDemoChapter_7Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self enumeratorDemo];
    
//    [self bridgeDemo];
    
    [self timerDemo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    
    [_timer invalidate];
}

- (void)stopTimer{
    
    [_timer invalidate];
    _timer = nil;
}

- (void)startTimer{
    //这样写timer会保留target也就是self,而self也持有了timer，产生保留环。  而打破保留环，要么调用stopTimer函数 要么令系统将此实例回收。除非有对代码完全掌控的把握，否则无法确保stopTimer一定会调用。  如此例没有调用stop直接返回控制器  timer就会一直走
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doSomeThing) userInfo:nil repeats:YES];
}

-(void)doSomeThing{
    
    //此处timer执行的函数
    NSLog(@"timer go");
}

- (void)timerDemo{
    [self startTimer];
    
    //这样先定义了一个弱引用，令其指向self,然后使block捕获这个引用，而不直接去捕获普通的self变量，也就是说self不会为计时器所保留。当block开始执行时，立刻生成strong引用，以保证实例在执行期间持续存活。 采用这种写法之后 如果外界直接本实例的最后一个引用将其释放，则本实例就可为系统所回收，回收过程中还会调用计时器的invalidate方法 这样计时器就不会再执行任务，此处使用weak引用还能令程序更加安全，因为有时开发者可能在写dealloc时忘了调用计时器的invalidate方法 从而导致计时器再次运行，若发生此类情况，则block里的weakSelf变成nil
//    __weak typeof(self) weakSelf = self;
//    self.timer = [NSTimer tyn_scheduledTimerWithTimeInterval:1 block:^{
//
//        TYNDemoChapter_7Controller *strongSelf = weakSelf;
////        [strongSelf dosomething];
//
//    } repoeats:YES];
}

- (void)bridgeDemo{
    
    NSArray *arr = @[@1,@2,@3,@4,@5];
    CFArrayRef cfArray = (__bridge CFArrayRef)arr;
    NSLog(@"Size of array = %li", CFArrayGetCount(cfArray));
}

//利用块枚举进行遍历
- (void)enumeratorDemo{
    
    NSArray *arr = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    
    
    //老式for循环
    for (int i = 0; i < arr.count; i++) {
        
        id number = arr[i];
    }
    
    //快速遍历
    for (id number in arr) {
        
        //do something
    }
    
    //基于block枚举的遍历  //还可以反向遍历
    [arr enumerateObjectsUsingBlock:^(id   numbser, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    
    
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
