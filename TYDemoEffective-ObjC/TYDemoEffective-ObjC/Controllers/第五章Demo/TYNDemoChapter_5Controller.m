//
//  TYNDemoChapter_5Controller.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/20.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYNDemoChapter_5Controller.h"

@interface TYNDemoChapter_5Controller ()

@end

@implementation TYNDemoChapter_5Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self autoReleasepollDemo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//使用自动释放值降低内存峰值
- (void)autoReleasepollDemo{
    
    
    //疑问 俩个写法对内存的占用差不多。 而且用watch看log观测到 log在赋值之后下一次赋值之前就会释放。也就是一次循环就会释放一次？
    //赋值 ->打印 ->释放 （每次for循环是一个作用域）
//    for (int i = 0; i < 100000; i++) {
//
//        NSString *str = [self logStringWithString:[NSString stringWithFormat:@"%d", i]];
//        NSLog(@"%@", str);
//
//
//        NSNumber *number = @(i);
//    }
    
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < 1000; i++) {

        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"资料 2" ofType:@"txt"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSString *fileContents = [NSString stringWithContentsOfURL:url
                                                          encoding:NSUTF8StringEncoding error:&error];
        
        NSLog(@"");
    }
    
    
    
//    @autoreleasepool{
//
//        NSMutableArray *arr = @[].mutableCopy;
//        for (int i = 0; i < 100000; i++) {
//
//            NSString *str = [self logStringWithString:[NSString stringWithFormat:@"%d", i]];
//            NSLog(@"%@", str);
//            [arr addObject:str];
//
//            NSNumber *number = @(i);
//        }
//        
//    }
    
}

- (NSString *)logStringWithString:(NSString *)str{
    
    NSString *newStr  = [str stringByAppendingString:@"xxxx"];
    return newStr;
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
