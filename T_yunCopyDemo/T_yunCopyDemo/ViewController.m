//
//  ViewController.m
//  T_yunCopyDemo
//
//  Created by T_yun on 2018/6/14.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "ViewController.h"
#import "TYNPerson.h"
#import "TYNFriend.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self copyTest];
//    [self mutableCopyTest];
//    [self collectionCopyTest];
    
//    [self mutableCollectionCopyTest];
    
//    [self multiDeepCopy];
    
    [self customModelCopy];
    
//    [self customModelWithCollectionPropertyCopy];
    
//    [self collectionWithcustomModelEntityCopy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//不可变 非容器类拷贝
- (void)copyTest{
    
    NSString *str1 = @"不可变字符串";
    NSString *str2 = str1.copy;
    NSString *str3 = [str1 mutableCopy];
    NSString *str4 = [NSString stringWithString:str1];
    
    
    //可变拷贝之后 str3指针地址不同于其他，为深拷贝 其他浅拷贝
    NSLog(@"str1_p : %p,class:%@", str1, [str1 class]);
    NSLog(@"str2_p : %p,class:%@", str2, [str2 class]);
    NSLog(@"str3_p : %p,class:%@", str3, [str3 class]);
    NSLog(@"str4_p : %p,class:%@", str4, [str4 class]);
    
}

//可变非容器类拷贝
- (void)mutableCopyTest{
    
    NSMutableString *str1 = @"可变字符串".mutableCopy;
    
    NSString *str2 = str1.copy;
    
    NSMutableString *str3 = str1.mutableCopy;
    
    NSMutableString *str4 = [[NSMutableString alloc] initWithString:str1];
    
    //四个地址各不相同 均为深拷贝
    NSLog(@"str1_p : %p,class:%@", str1, [str1 class]);
    NSLog(@"str2_p : %p,class:%@", str2, [str2 class]);
    NSLog(@"str3_p : %p,class:%@", str3, [str3 class]);
    NSLog(@"str4_p : %p,class:%@", str4, [str4 class]);

}

//不可变容器类拷贝
- (void)collectionCopyTest{
    
    NSString *str1 = @"111111";
    NSString *str2 = @"222222";
    NSString *str3 = str1;
    
    NSArray *arr1 = @[str1, str2, str3];
    NSArray *arr2 = arr1.copy;
    NSMutableArray *arr3 = arr1.mutableCopy;
    NSArray *arr4 = [NSArray arrayWithArray:arr1];
    //深拷贝方法
    NSArray *arr5 = [[NSArray alloc] initWithArray:arr1 copyItems:YES];
    
    
    //arr1和arr2的地址相同浅拷贝  其他的均不相同深拷贝（单层次） 单数组里面的对象都是地址相同的 均指向str1,str2,str3.  需要说明的是 方法五会深层次拷贝数组里面的对象，参照里面对象自身的copy方法，由第一个函数中得出不可变NSString的copy方法为浅拷贝 固此处会与其他数组相同
    //需要注意 同样不可的string用[NSString stringWithString:str1]创建出来为浅拷贝  而NSArray为深拷贝
    NSLog(@"%@", [self logArray:arr1 deep:0]);
    NSLog(@"%@", [self logArray:arr2 deep:0]);
    NSLog(@"%@", [self logArray:arr3 deep:0]);
    NSLog(@"%@", [self logArray:arr4 deep:0]);
    NSLog(@"%@", [self logArray:arr5 deep:0]);

}

//可变容器拷贝
- (void)mutableCollectionCopyTest{
 
    NSString *str1 = @"111111";
    NSString *str2 = @"222222";
    NSString *str3 = str1;
    
    NSMutableArray *arr1 = @[str1, str2, str3].mutableCopy;
    NSMutableArray *arr2 = arr1.copy;
    NSMutableArray *arr3 = arr1.mutableCopy;
    //深拷贝方法
    NSArray *arr4 = [[NSArray alloc] initWithArray:arr1 copyItems:YES];
    
    
    //各个数组的地址均不同 但里面的对象也均为相同
    NSLog(@"%@", [self logArray:arr1 deep:0]);
    NSLog(@"%@", [self logArray:arr2 deep:0]);
    NSLog(@"%@", [self logArray:arr3 deep:0]);
    NSLog(@"%@", [self logArray:arr4 deep:0]);
}


//研究深拷贝的层次关系
- (void)multiDeepCopy{
    
    
    NSString *str1 = @"11111";
    NSString *str2 = @"2222".mutableCopy;
    
    NSArray *obj1 = @[str1,str2];
    NSMutableArray *obj2 = @[obj1].mutableCopy;
    NSArray *obj3 = @[obj2];
    NSMutableArray *obj4 = @[obj3].mutableCopy;
    
    
    NSArray *arr1 = @[obj4];
//    NSMutableArray *arr2 = arr1.copy;
//    NSMutableArray *arr3 = arr1.mutableCopy;
    //深拷贝方法
//    NSArray *arr4 = [[NSArray alloc] initWithArray:arr1 copyItems:YES];
    
    NSMutableArray *arr5 = [[NSMutableArray alloc] initWithArray:arr1 copyItems:YES];
    
    NSLog(@"%@", [self logArray:arr1 deep:0]);
//    NSLog(@"%@", [self logArray:arr2 deep:0]);
//    NSLog(@"%@", [self logArray:arr3 deep:0]);
//    NSLog(@"%@", [self logArray:arr4 deep:0]);
    NSLog(@"%@", [self logArray:arr5 deep:0]);

    //arr1地址和arr2相等 其他不等
    //第一层  arr1 arr2 arr3里面各元素地址相等  arr4中第一个元素，第三个元素相等 第二个元素，第四个元素不等
    //第二层 arr1 arr2 arr3 arr4 里面的数组元素 里面的元素相同
    //arr5与 arr4一样
    
}

//自定义model的拷贝
- (void)customModelCopy{
    
    NSString *str1 = @"11111";
    NSString *str2 = @"22222";
    NSString *str3 = @"33333";
    NSMutableString *str4 = @"33333".mutableCopy;
//    TYNPerson *person = [[TYNPerson alloc] initWithName:str1 bestFriend:nil];
//    TYNPerson *person1 = [[TYNPerson alloc] initWithName:str2 bestFriend:person];
//    TYNPerson *person2 = [[TYNPerson alloc] initWithName:str3 bestFriend:person1];
//    TYNPerson *person3 = [[TYNPerson alloc] initWithName:str4 bestFriend:person2];

    
    TYNFriend *person = [[TYNFriend alloc] initWithName:str1 bestFriends:nil];
    TYNFriend *person1 = [[TYNFriend alloc] initWithName:str2 bestFriends:@[person,@[str2],@[str2].mutableCopy].mutableCopy];
    TYNFriend *person2 = [[TYNFriend alloc] initWithName:str3 bestFriends:@[person1,@[str3],@[str3].mutableCopy].mutableCopy];
    TYNFriend *person3 = [[TYNFriend alloc] initWithName:str4 bestFriends:@[person2,@[str4],@[str4].mutableCopy].mutableCopy];
    
    TYNPerson *personcopy = person3.copy;
    //实现自定义类的description方法  方便查看打印（打印里面memory为内存地址）
    NSLog(@"%@", person3);
    NSLog(@"%@", personcopy);
    
    //详解请看 类的copyWithZone方法
    
}

//自定义model 里面有属性为colletion 且容器里放了本类实例对象
- (void)customModelWithCollectionPropertyCopy{
    
    NSString *str1 = @"11111";
    NSString *str2 = @"22222";
    NSString *str3 = @"33333";
    NSString *str4 = @"33333";
    TYNFriend *person = [[TYNFriend alloc] initWithName:str1 bestFriends:nil];
    TYNFriend *person1 = [[TYNFriend alloc] initWithName:str2 bestFriends:@[person].mutableCopy];
    TYNFriend *person2 = [[TYNFriend alloc] initWithName:str3 bestFriends:@[person1].mutableCopy];
    TYNFriend *person3 = [[TYNFriend alloc] initWithName:str4 bestFriends:@[person2].mutableCopy];
    
    TYNFriend *personcopy = person3.copy;
    //实现自定义类的description方法  方便查看打印（打印里面memory为内存地址）
    NSLog(@"%@", person3);
    NSLog(@"%@", personcopy);
    
    //详解请看 类的copyWithZone方法
}

//容器里面装自定义对象
- (void)collectionWithcustomModelEntityCopy{
    
    NSString *str1 = @"11111";
    NSString *str2 = @"22222";
    NSString *str3 = @"33333";
    NSString *str4 = @"33333";
//    TYNPerson *person = [[TYNPerson alloc] initWithName:str1 bestFriend:nil];
//    TYNPerson *person1 = [[TYNPerson alloc] initWithName:str2 bestFriend:person];
//    TYNPerson *person2 = [[TYNPerson alloc] initWithName:str3 bestFriend:person1];
//    TYNPerson *person3 = [[TYNPerson alloc] initWithName:str4 bestFriend:person2];
//
//
//    NSArray *arr1 = @[person3];
//
//    NSArray *arr2 = [[NSArray alloc] initWithArray:arr1 copyItems:YES];
    
    //可用断点查看 arr1和arr2地址不同且里面每个entity及entity包含的自定义对象属性往下任意一层均不同
    


    TYNFriend *person = [[TYNFriend alloc] initWithName:str1 bestFriends:nil];
    TYNFriend *person1 = [[TYNFriend alloc] initWithName:str2 bestFriends:@[person].mutableCopy];
    TYNFriend *person2 = [[TYNFriend alloc] initWithName:str3 bestFriends:@[person1].mutableCopy];
    TYNFriend *person3 = [[TYNFriend alloc] initWithName:str4 bestFriends:@[person2].mutableCopy];
    
    NSArray *arr1 = @[person3];
    NSArray *arr2 = [[NSArray alloc] initWithArray:arr1 copyItems:YES];
    
    //断点查看与上面同理
    
}


#pragma mark  自实现一个log 打印数组地址 已经数组里面内容的地址
//后面的参数表示深度为几层 默认为0
- (NSString *)logArray:(NSArray *)arr deep:(NSInteger)deep{

    
    NSMutableString *log = @"".mutableCopy;
    for (int i = 0; i < deep; i++) {
        
        //增加水平制表符
        [log appendFormat:@"\t"];
    }
    [log appendFormat:@"<%@ %p>", [arr class], arr];
    
    for (id obj in arr) {
        
        [log appendString:@"\n"];

        if ([obj isKindOfClass:[NSArray class]]) {
            
            NSString *subArraylog =  [self logArray:obj deep:deep + 1];
            [log appendString:subArraylog];
        } else{
            
            for (int i = 0; i < deep; i++) {
                
                //增加水平制表符
                [log appendFormat:@"\t"];
            }
            [log appendFormat:@"%@ %p", [obj class], obj];
        }
    }
    [log appendString:@"\n"];

    
    return log;
}


@end
