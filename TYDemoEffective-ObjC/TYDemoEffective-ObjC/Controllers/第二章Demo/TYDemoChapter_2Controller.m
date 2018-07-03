//
//  TYDemoChapter_2Controller.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/6.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYDemoChapter_2Controller.h"
#import "TYPersonModel.h"
#import "TYSmithPerson.h"
//#import <objc/runtime.h>
#import <objc/message.h>
#import "TYSmithPerson.h"
#import "NSString+EOCMethodSwizzling.h"


//导入类别 里面实现了关联对象 添加公有属性
#import "UIViewController+AccociatedObjects.h"

@interface TYDemoChapter_2Controller ()

@property(nonatomic, strong) TYPersonModel *person;

@property(nonatomic, strong) NSNumber *nonatomicNumber;

@property(atomic, strong) NSNumber *atomicNumber;


@end


__weak NSArray *string_weak_assign = nil;
__weak NSArray *string_weak_retain = nil;
__weak NSArray *string_weak_copy = nil;


__weak id weakObjc = nil;


@implementation TYDemoChapter_2Controller



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self methodSwizzlingDemo];
    
//    [self messageForwardingDemo];
    //
//    [self associatedReleaseDemo];
    
    [self propertyDemo];
    
//    [self equalDemo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//方法调配技术
//https://stackoverflow.com/questions/5339276/what-are-the-dangers-of-method-swizzling-in-objective-c
- (void)methodSwizzlingDemo{
    //1.不是原子性 应该放在+load方法中（此方法是程序启动是串行执行） 不能放在+initialize中
    //2.更改非拥有代码 该使用不仅仅是改变类的一个实例 而是所有实例。
    //3.可能的命名冲突
    //4.重命名方法可能改变了它的参数
    //5.比如 UIButton UIView UIControll都对setFrame方法进行交换扩展。 调用迅速问题 解决办法是交换放在在+load方法中调用 与1一样

    NSString *string = @"This iS tHe String";
    NSString *lowercaseString = [string lowercaseString];
    
}



//消息转发机制（三步）具体见例子类内部实现
- (void)messageForwardingDemo{
    
    
    //例子里面实现了 动态添加setter和getter方法来将属性放入内部
    //EOC例子 编写一个类似于字典的对象  它里面可以容纳其他对象 只不过通过属性来存取其中的数据
    //思路为开发者来添加属性定义 并将其声明为@dynamic 而类则会自动处理相关属性值的存放和获取操作
//    TYPersonModel *person = [[TYPersonModel alloc] init];
//    person.date = [NSDate dateWithTimeIntervalSince1970:0];
//    NSLog(@"person.date=%@", person.date);
    
    //一个完整的消息转发各个阶段的例子
    TYPersonModel *person = [[TYPersonModel alloc] init];
    TYPersonModel *anotherPerson = [[TYPersonModel alloc] init];
    [person beFriendWith:anotherPerson];
//
////    SEL sel = @selector(beFriendWith:);
////    IMP methodPoint = [person methodForSelector:sel];
////    [person performSelector:sel withObject:anotherPerson];
//    //报错Build Setting--> Apple LLVM 6.0 - Preprocessing--> Enable Strict Checking of objc_msgSend Calls  改为 NO
////    objc_msgSend(person,@selector(beFriendWith:),anotherPerson);
    [anotherPerson performSelector:@selector(gotoSchool) withObject:nil];
    
}

- (void)gotoSchool{
    
    NSLog(@"ViewController's go to school");
}

//研究关联对象 的释放时机
-(void)associatedReleaseDemo{
    
    
    self.associatedObject_assign = @[@"assign"];
    self.associatedObject_retain = @[@"retain"];
    self.associatedObject_copy = @[@"copy"];
    
    string_weak_assign = self.associatedObject_assign;
    string_weak_retain = self.associatedObject_retain;
    string_weak_copy = self.associatedObject_copy;
    
}

- (void)logAssioatedObj{
    
    NSLog(@"self.associatedObjct_assign:%@", self.associatedObject_assign);
    NSLog(@"self.associatedObjct_retain:%@", self.associatedObject_retain);
    NSLog(@"self.associatedObjct_copy:%@", self.associatedObject_copy);

}

//对象等同性
- (void)equalDemo{
    
    TYPersonModel *person = [[TYPersonModel alloc] init];
    TYPersonModel *person1 = [[TYPersonModel alloc] init];

    TYSmithPerson *smith = [[TYSmithPerson alloc] init];
    
    person.nonatomicNumber = @1;
    person.atomicNumber = @2;
    person.obj = @0;
    person.lastName = @"Smith";
    
    person1.nonatomicNumber = @1;
    person1.atomicNumber = @2;
    person1.obj = @0;
    person1.lastName = @"Smith";
    
    smith.nonatomicNumber = @1;
    smith.atomicNumber = @2;
    smith.obj = @0;
    smith.lastName = @"Smith";
    
    
    BOOL isEqual = [person isEqual:smith];
    BOOL isEqual1 = [person isEqual:person1];

    NSUInteger personHash = [person hash];
    NSUInteger person1Hash = [person1 hash];
    NSUInteger smithHash = [smith hash];
    
//    NSLog(@"%lud\n%lud\n%lud", personHash, person1Hash, smithHash);//若使用系统hash 三者均不相等  重写之后 同类同属性实例对象相等  父子类同属性实例对象不等
//    NSLog(@"%d  %d", isEqual, isEqual1); //若使用系统isEqual方法  均为NO   重写之后 前者NO 后者yes
    NSLog(@"---**********防干扰分割线**********-");
    
    
    
    //hash方法何时会调用
    //下面例子可以得出 hash方法在对象放入set中和作为key放入字典中会调用
    NSMutableArray *array1 = [NSMutableArray array];
    [array1 addObject:person];
    NSMutableArray *array2 = [NSMutableArray array];
    [array2 addObject:person1];
    NSLog(@"array end -------------------------------");
    
    NSMutableSet *set1 = [NSMutableSet set];
    [set1 addObject:person];
    NSMutableSet *set2 = [NSMutableSet set];
    [set2 addObject:person1];
    NSLog(@"set end -------------------------------");
    
    
    
    NSString *kKey1 = @"key1";
    NSString *kKey2 = @"key2";
    NSString *kValue1 = @"value1";
    NSString *kValue2 = @"value2";
    NSMutableDictionary *dictionaryValue1 = [NSMutableDictionary dictionary];
    [dictionaryValue1 setObject:person forKey:kKey1];
    NSMutableDictionary *dictionaryValue2 = [NSMutableDictionary dictionary];
    [dictionaryValue2 setObject:person1 forKey:kKey2];
    NSLog(@"dictionary value end -------------------------------");
    
    //此处需注意 自定义类用作可以时 需要实现 copyWithZone方法
    NSMutableDictionary *dictionaryKey1 = [NSMutableDictionary dictionary];
    [dictionaryKey1 setObject:kValue1 forKey:person];
    NSMutableDictionary *dictionaryKey2 = [NSMutableDictionary dictionary];
    [dictionaryKey2 setObject:kValue2 forKey:person1];
    NSLog(@"dictionary key end -------------------------------");
    NSLog(@"---**********防干扰分割线**********-");

    
    //等同性判断执行深度， 例如NSArray检测  先看俩个数组中对象个数是否相同  相同在对应位置的俩个对象上调用其“isEqual”方法，若都相同 则俩个数组相等。有时候我们可以用唯一标识符的方式判断等同性 就可以不必每个属性都判断特别是唯一标识符属性设置为readonly时
    NSMutableSet *set = [NSMutableSet set];
    NSMutableArray *array = @[@1,@2].mutableCopy;
    [set addObject:array];
    NSLog(@"set= %@", set);
    //此时set中含有一个数组对象 数组中包含俩个对象。   再向set中加入一个数组， 此数组与前一个数组所有的对象相同，顺序也相同（带加入数组与set中已有数组是相等的）;
    NSMutableArray *arrayB = @[@1,@2].mutableCopy;
    [set addObject:arrayB];
    NSLog(@"set = %@", set);
    //此时的set里仍然只有之前的那个数组对象 不会改变 如果添加不同的数组
    
    NSMutableArray *arrayC = @[@1].mutableCopy;
    [set addObject:arrayC];
    NSLog(@"set = %@", set);
    //此时set中有俩个对象了 分别指之前的那个数组和刚加入的数组C，如果此时改变数组C来与之前的数组相同
//    arrayC = @[@1,@2].mutableCopy; //如果用这个方法 会造成set中的值不变 因为arrayC重新赋值 相当于对之前那个数组C指向的内存强引用释放  而那块内存仍然被set强引用 所有不会释放。  arrayC也不再set中了 除非重新加入set
    [arrayC addObject:@2];
    NSLog(@"set = %@", set);
    //set中包含了俩个彼此相等的数组（set的语义是不允许出现这种情况的，因为我们修改了set种已有对象 如果此时拷贝set
    NSSet *setB = [set copy];
    NSLog(@"setB = %@", setB);
    //复制过后的setB中又只剩一个对象， 所以需要注意将对象放入collection之后改变其内容造成的后果

    
}

//属性相关
-(void)propertyDemo{
    
    
    //在对象内部尽量直接访问实例对象 初始化方法里面直接访问实例对象
    //子类重写了设置方法  所有初始化里面直接访问实例对象的情况下 不会设置该属性
    TYSmithPerson *person = [[TYSmithPerson alloc] initWithLastName:@"Base"];
    person.lastName = @"Smith";
    
    NSMutableString *str = @"strxxx".mutableCopy;
    person.myCopyString = str;
    person.strongString = str;
    //1.
//    str = @"11111".mutableCopy;
//    NSLog(@"%@, %@", person.myCopyString, person.strongString); //strxxx strxxx 改变了str指针指向，但其原来指向的内存内容没变。
    //2.
    [str appendString:@"111232"];
    NSLog(@"%@, %@", person.myCopyString, person.strongString); //strxxx strxxx111232 这就是copy修饰符对字符串进行一次copy的作用
    //3.
//    BOOL isCopyAppended =  [person.myCopyString performSelector:@selector(appendString:) withObject:@"0"]; //此方法会crash 因为myCopyString经过copy之后是NSString对象
    [person.strongString performSelector:@selector(appendString:) withObject:@"0"]; //strongString虽然声明是NSString对象 但实际上使用NSMutableString赋值的

    
    
    
    //分别用lldb 里面watchpoint工具（查看内存变化） assign修饰的NSArray创建就被释放 NSString没有
    TYSmithPerson *smith = [[TYSmithPerson alloc] init];
    smith.assignString = [NSString stringWithFormat:@"%@dd",@"x"];
//    weakObjc = smith.assignString;
    
    smith.assignArray = [NSArray arrayWithObjects:@"1",@"2", nil];
    weakObjc = smith.assignArray;
    
    //1.weak修饰的创建则被释放
    id __weak _obj = [[NSObject alloc] init];
    id __weak _obj1 = _obj;
    
//    NSLog(@"%@", _obj1);
    id tmp = _obj1;
//    NSLog(@"1 %@", tmp);
//    NSLog(@"2 %@", tmp);
//    NSLog(@"3 %@", tmp);
//    NSLog(@"4 %@", tmp);
//    NSLog(@"5 %@", tmp);
    
   //2.
//    1，自己生成的对象自己所持有，
//    2，非自己生成的对象自己也能持有，
//    3，不再需要自己持有的对象时释放，
//    4，非自己持有的对象无法释放。
    id __strong obj1 = [[NSObject alloc] init];
    
    id __strong obj2 = [[NSObject alloc] init];
    
    id __strong obj3 = nil;
    obj1 = obj2;
//    NSLog(@"%@ -- %@",obj1,obj2);//输出 <NSObject: 0x60c000003e60> -- <NSObject: 0x60c000003e60>
    obj3 = obj1;
//    NSLog(@"%@ -- %@",obj3,obj1);
    
    
    //3.
    TYPersonModel *test0 = [[TYPersonModel alloc] init]; //A对象
    TYPersonModel *test1 = [[TYPersonModel alloc] init];//B对象
    
    //此时B对象的持有者为test1 和 A对象的成员变量obj，B对象被两条强指针指向
//    [test0 setObj:test1];
    
    //此时A对象的持有者为test0 和 B对象的成员变量obj，A对象被两条强指针指向
//    [test1 setObj:test0];
    /*
     test0 超出其作用域 ，所以其强引用失效，自动释放对象A;
     test1 超出其作用域 ，所以其强引用失效，自定释放对象B;
     
     此时持有象A的强引用的变量为B对象的成员变量obj；
     此时持有对象B的强引用的变量为A对象的成员变量obj;
     
     因为都还被一条强指针指向，所以内存泄漏！
     */
    
    
    //4.__weak修饰的指针被释放为nil strong修饰的指针还在
    id __weak objc = [[NSObject alloc] init];
    id  objc1 = objc;
//    NSLog(@"4.%@--%@", objc, obj1);
    
    
    TYPersonModel *person1 = [[TYPersonModel alloc] init];
    person1.atomicNumber = @20;
    person1.nonatomicNumber = @20;
    _person = person1;
    self.nonatomicNumber = @20;
    self.atomicNumber = @20;
}



#pragma mark  互斥锁
//对比下面俩个例子
//后两行是一样的，不写的话默认就是atomic。
//
//atomic 和 nonatomic 的区别在于，系统自动生成的 getter/setter 方法不一样。如果你自己写 getter/setter，那 atomic/nonatomic/retain/assign/copy 这些关键字只起提示作用，写不写都一样。
//
//对于atomic的属性，系统生成的 getter/setter 会保证 get、set 操作的完整性，不受其他线程影响。比如，线程 A 的 getter 方法运行到一半，线程 B 调用了 setter：那么线程 A 的 getter 还是能得到一个完好无损的对象。
//
//而nonatomic就没有这个保证了。所以，nonatomic的速度要比atomic快。
//
//不过atomic可并不能保证线程安全。如果线程 A 调了 getter，与此同时线程 B 、线程 C 都调了 setter——那最后线程 A get 到的值，3种都有可能：可能是 B、C set 之前原始的值，也可能是 B set 的值，也可能是 C set 的值。同时，最终这个属性的值，可能是 B set 的值，也有可能是 C set 的值。
//保证数据完整性——这个多线程编程的最大挑战之一——往往还需要借助其他手段。（比如下面例子中加互斥锁）

static int count = 20000000;
static int count1 = 20000000;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{    

    [self logAssioatedObj];
//    [self getSetDemo];
//    [self atomicDemo];
//    [self ticketDemo];
}

- (void)getSetDemo{
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{

        [self _getValue];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{

        [self _setValue];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{

        [self _setValue1];
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        
        //还原值
        _person.atomicNumber = @(20);
        _person.nonatomicNumber = @(20);
    });
    
//    [self performSelectorInBackground:@selector(_getValue) withObject:nil];
//    [self performSelectorInBackground:@selector(_setValue) withObject:nil];
//    [self performSelectorInBackground:@selector(_setValue1) withObject:nil];
//
//    //还原值
//    _person.atomicNumber = @(20);
//    _person.nonatomicNumber = @(20);
}

- (void)atomicDemo{

    // 建立了 两个子线程。
    [self performSelectorInBackground:@selector(numberChange) withObject:nil];
    [self performSelectorInBackground:@selector(numberChange) withObject:nil];
    [self performSelectorInBackground:@selector(numberChange) withObject:nil];
}


- (void)ticketDemo{
    
    // 建立了 两个子线程。
    [self performSelectorInBackground:@selector(waste:) withObject:@"aaa"];
    [self performSelectorInBackground:@selector(waste:) withObject:@"bbb"];
    [self performSelectorInBackground:@selector(waste:) withObject:@"ccc"];
    
}

//存取数据
- (void)_setValue{
    
    int i = arc4random() % 8;
    float time = i / 100.;
    [NSThread sleepForTimeInterval:time];

    count--;
    _person.atomicNumber = @(count);
    _person.nonatomicNumber = @(count);
}

- (void)_setValue1{
    
    int i = arc4random() % 8;
    float time = i / 100.;
    [NSThread sleepForTimeInterval:time];
    
    
    count1--;
    _person.atomicNumber = @(-count1);
    _person.nonatomicNumber = @(-count1);
}

- (void)_getValue{
    
    int i = arc4random() % 8;
    float time = i / 100.;
    [NSThread sleepForTimeInterval:time];
    NSLog(@"%@,%@", _person.atomicNumber, _person.nonatomicNumber);
}



//数字变化
- (void)numberChange{
    
    while (count > 0) {
    
        count--;
        [NSThread sleepForTimeInterval:0.1];  //(自己可以将让程序睡眠)
        NSNumber *atomicNumber = _person.atomicNumber;
        atomicNumber = @([atomicNumber intValue] - 1);
        _person.atomicNumber = atomicNumber;
        
        
        NSNumber *nonatomicNumber = _person.nonatomicNumber;
        nonatomicNumber = @([nonatomicNumber intValue] - 1);
        _person.nonatomicNumber = nonatomicNumber;
        NSLog(@"%@--%@",_person.atomicNumber, _person.nonatomicNumber);
    
    }
}

// 卖票
- (void)waste:(NSString *)str{
    
    
//    互斥锁的优缺点
//    优点：能有效防止因多线程抢夺资源造成的数据安全问题
//    缺点：需要消耗大量的CPU资源
//    互斥锁的使用前提：多条线程抢夺同一块资源
//    相关专业术语：线程同步
//    线程同步的意思是：多条线程在同一条线上执行（按顺序地执行任务）
//    互斥锁，就是使用了线程同步技术
    
    //不加互斥锁 //  三个子线程同时访问数据，  就会出现数据错乱
//    while (count > 0) {
//
//        count--;
//        [NSThread sleepForTimeInterval:0.1];  //(自己可以将让程序睡眠)
//        NSLog(@"%@___%i___%@",str,count,[NSThread currentThread]);
//
//    }
    // 加互斥锁，影响系统的性能。
    @synchronized(self)
    {
        
        while (count > 0) {
            count--;
            [NSThread sleepForTimeInterval:0.1];  //(自己可以将让程序睡眠)
            NSNumber *nonatomicNumber = self.nonatomicNumber;
            nonatomicNumber = @([nonatomicNumber intValue] - 1);
            self.nonatomicNumber = nonatomicNumber;
            //                NSLog(@"%@___%i___%@",str,count,[NSThread currentThread]);
            
            NSNumber *atomicNumber = self.atomicNumber;
            atomicNumber = @([atomicNumber intValue] - 1);
            self.atomicNumber = atomicNumber;
            NSLog(@"%@    %@", self.atomicNumber, self.nonatomicNumber);
        }
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
