//
//  ViewController.m
//  T_yunSortArrayWithCustomObjs
//
//  Created by T_yun on 2016/12/23.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import "ViewController.h"
#import "MYPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //随机生成模拟初始数据
    NSMutableArray<MYPerson *> *originArray = @[].mutableCopy;
    for (int index = 0; index < 10; index++) {
        
        NSInteger random = arc4random() % 99;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:random * 100000];
        MYPerson *person = [[MYPerson alloc] initWithBirthDate:date];
        [originArray addObject:person];
        NSLog(@"第%d个:%@", index, date);
    }
    
    
    NSArray *sortedArray1 = [self sortedWithCompareMethod:originArray];
    
    NSArray *sortedArray2 = [self sortedWithNSSortDescriptor:originArray];
    
    #pragma mark 方法3.Blocks(shiny!)
    NSArray *sortedArray3 = [originArray sortedArrayUsingComparator:^NSComparisonResult(MYPerson *personA, MYPerson *personB) {
       
        return [personA.birthDate compare:personB.birthDate];
    }];
    
    NSLog(@"***********************");
    [self logArray:sortedArray1];
    NSLog(@"***********************");
    [self logArray:sortedArray2];
    NSLog(@"***********************");
    [self logArray:sortedArray3];
}

#pragma mark 方法1.Compare method
- (NSArray *)sortedWithCompareMethod:(NSArray *)originArray {

    //利用选择器比较 需要自定义对象实现compare方法
    return  [originArray sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark 方法2.NSSortDescriptor(better)
- (NSArray *)sortedWithNSSortDescriptor:(NSArray *)originArray {

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"birthDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    return [originArray sortedArrayUsingDescriptors:sortDescriptors];
}

//打印
- (void)logArray:(NSArray *)array {

    for (int index = 0; index < array.count; index++) {
        
        MYPerson *person = array[index];
        NSLog(@"第%d个为:%@", index, person.birthDate);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
