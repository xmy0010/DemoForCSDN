//
//  TYDemoChapter_1Controller.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/6.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYDemoChapter_1Controller.h"

// static 表示该变量仅在定义此变量的编译单元中可见（OC中一般通常为每个类的实现文件.m）
static const NSTimeInterval kAnimationDuration = 0.3;


//声明在之前.h中 此处为赋值
const NSTimeInterval TYDemoChapter_1AnimationDuration = 0.3;

//补充 const *p【记为const (*P)】  为p指向地址的内容不可改变 但是p指向的地址可以改变  * const p【记为* (const p)】 为p指向的地址不可改变 但是指向地址的内容可以改变


typedef NS_OPTIONS(NSUInteger, TYEnumDemo) {
    
    TYEnumDemoLeft = 1 << 0,
    TYEnumDemoUp = 1 << 1,
    TYEnumDemoRight = 1 << 2,
    TYEnumDemoDown = 1 << 3
};


typedef NS_ENUM(NSUInteger, TYEnumCorlour) {
    
    TYEnumCorlourRed = 0,
    TYEnumCorlourBlack,
    TYEnumCorlourGreen
};

@interface TYDemoChapter_1Controller ()

@end


@implementation TYDemoChapter_1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    [self msgSendDemo];
//    [self literalSytaxDemo];
//    [self enumDemo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 例子

//OC动态 消息机制
- (void)msgSendDemo{
    
    id number = @3;
    //消息机制  编译时不关心接收消息对象的类型 可以编译通过  但是运行时对象和对象的父类不能响应方法 且通过消息转发机制也不能响应 会报错
//    [number appendString:@"str"];
    
    //字符串对象存放堆上  对象指针存在栈上  改变指针的指向 不改变堆上对象的值
    NSString *someString = @"The String";
    NSString *anotherString = someString;
    someString = @"Change";
    NSLog(@"someString = %@, anotherString = %@",someString, anotherString);
    
}

//字面量语法
- (void)literalSytaxDemo{
    
    NSArray *arr1 = [NSArray arrayWithObjects:@1,@3,@5, nil];
    NSArray *arr2 = @[@1,@3,@5];
    BOOL isEqual = [arr1 isEqualToArray:arr2];
    // isEqual == isEqualToArray 区别
//    == 比较两个对象的内存地址
//
//    isEqualToString: 比较两个字符串的内容
//
//    isEqual: 默认情况下是比较两个对象的内存地址，但是有一些系统自带的类(比如Foundation中的NSString,NSArray等)重写了这个方法，改变了这个方法的判断规则(一般改为比较两个对象的内容，不是内存地址)
    NSLog(@"%d", isEqual);  //相等 俩者创建出来的内容上是完全一致的
    
    arr1 = [NSArray arrayWithObjects:@1, @3, nil,@5]; // 遇到nil 会停止 即arr1 = @[@1,@3]
//    arr2 = @[@1, @3, nil, @5]; //编译器会报错
    
}

//枚举
- (void)enumDemo{
    
    //枚举表示状态码  枚举需要组合用NS_OPTIONS定义  不需要时用NS_Enum定义
    TYEnumDemo direction = TYEnumDemoLeft | TYEnumDemoDown;
    TYEnumCorlour corlour = TYEnumCorlourRed;
    
    //switch语句中不用加 default 若是枚举的状态未写完 会有警告
    switch (corlour) {
        case TYEnumCorlourRed:
            
            NSLog(@"Red");
            break;
        case TYEnumCorlourBlack:
            
            NSLog(@"Black");
            break;
        case TYEnumCorlourGreen:
            
            NSLog(@"Green");
            break;
    }
    
    //用“与”运算取出对应位
    if (direction & TYEnumDemoLeft) {
        NSLog(@"left");
    }
    if (direction & TYEnumDemoUp) {
        NSLog(@"up");
    }
    if (direction & TYEnumDemoRight) {
        NSLog(@"right");
    }
    if (direction & TYEnumDemoDown) {
        NSLog(@"bottom");
    }
    
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
