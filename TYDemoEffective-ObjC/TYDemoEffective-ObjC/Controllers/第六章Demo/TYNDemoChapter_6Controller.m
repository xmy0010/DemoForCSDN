//
//  TYNDemoChapter_6Controller.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/21.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYNDemoChapter_6Controller.h"
#import "TYNOperation.h"

typedef int (^TYNSomeBlock) (BOOL flag, int value);

@interface TYNDemoChapter_6Controller ()

@property(nonatomic, strong) NSLock *lock;
@property(nonatomic, strong) NSLock *lock1;

@property(nonatomic, strong) NSLock *ticketLock;
@property(nonatomic, strong) dispatch_queue_t syncQueue;

@property(nonatomic, strong) dispatch_queue_t syncQueue4;


@property(nonatomic, assign) int ticketSurplusCount;

@property(nonatomic, copy) NSString *str1;
@property(nonatomic, copy) NSString *str2;
@property(nonatomic, copy) NSString *str3;

@property(nonatomic, copy) NSString *str4;


@end

@implementation TYNDemoChapter_6Controller
@synthesize str1 = _str1;
@synthesize str2 = _str2;
@synthesize str3 = _str3;
@synthesize str4 = _str4;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self blockDemo];
//    [self blockDemo1];
//    [self blockDemo2];
    
//    [self safeCodeDemo];
    
//    [self operationDemo];
//    [self queueDemo];
    
//    [self dispatchGroupDemo];
    
//    [self dispatchGroupDemo1];
//    [self dispatchGroupDemo2];
    
    [self dispathchDemo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//区别    并发队列                         串行队列                            主队列
//同步(sync)    没有开启新线程，串行执行任务    没有开启新线程，串行执行任务    主线程调用：死锁卡住不执行
//                                                                  其他线程调用：没有开启新线程，串行执行任务
//异步(async)    有开启新线程，并发执行任务    有开启新线程(1条)，串行执行任务    没有开启新线程，串行执行任务


- (void)dispathchDemo{
    //    主队列是一种特殊的串行队列  所有放在主队列的任务 都会放到主线程中执行
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    
    //串行队列
    dispatch_queue_t sQueue = dispatch_queue_create("com.TYN1.NET", DISPATCH_QUEUE_SERIAL);
    
    
//    //主线程调用 同步任务会死锁
//    dispatch_sync(dispatch_get_main_queue(), ^{
//
//        NSLog(@"死锁");
//    });
    
    
    

    
    
    //并发队列 GCD默认提供全局并发队列（Global Dispatch Queue）
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

//    [self barrier];
    
    
    
//    [self apply];
    [self groupWait];
}


/**
 * 队列组 dispatch_group_wait
 */
- (void)groupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
}

/**
 * 快速迭代方法 dispatch_apply
 */
//通常我们会用 for 循环遍历，但是 GCD 给我们提供了快速迭代的函数dispatch_apply。dispatch_apply按照指定的次数将指定的任务追加到指定的队列中，并等待全部队列执行结束。
//如果是在串行队列中使用 dispatch_apply，那么就和 for 循环一样，按顺序同步执行。可这样就体现不出快速迭代的意义了。
//我们可以利用并发队列进行异步执行。比如说遍历 0~5 这6个数字，for 循环的做法是每次取出一个元素，逐个遍历。dispatch_apply 可以 在多个线程中同时（异步）遍历多个数字。
//还有一点，无论是在串行队列，还是异步队列中，dispatch_apply 都会等待全部任务执行完毕，这点就像是同步操作，也像是队列组中的 dispatch_group_wait方法。
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}


/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_barrier_sync(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
}



- (void)dispatchGroupDemo2{
    
    
    //说明 1. 异步执行的block里面如果又有异步任务 那么notif会先完成，
    dispatch_queue_t dispatchQueue = dispatch_queue_create("com.TYN.net", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    //3.如果用enter和leave则不会有这个困扰，notif会在任务一二之后
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatchQueue, ^{
       
//        //2.如果下面也类似这样那么norif会在任务一任务二之后
//        dispatch_group_async(group ,globalQueue, ^{
//
//            sleep(5);
//            NSLog(@"任务一");
//        });
        
        dispatch_async(globalQueue, ^{
           
            sleep(5);
            NSLog(@"任务一");
            dispatch_group_leave(group);
        });
    });
    
    
    dispatch_group_enter(group);

    dispatch_group_async(group, dispatchQueue, ^{
       
        dispatch_group_async(group, globalQueue, ^{
           
            dispatch_async(globalQueue, ^{
                
                sleep(8);
                NSLog(@"任务二");
                dispatch_group_leave(group);
            });
        });
    });
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        NSLog(@"都完成");
    });
}

- (void)dispatchGroupDemo1{
    
    
    
    //一个enter对应一个leave 类似引用计数一样   为0时触发所有结束
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        sleep(5);
        NSLog(@"任务一");
        dispatch_group_leave(group);
    });
    
    
    dispatch_group_enter(group);
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
       
        sleep(8);
        NSLog(@"任务二");
        dispatch_group_leave(group);
    });
    
    
    //说明  如果第一个同步 第二个异步 打印5s -> 8S
        //如果都同步               打印5s -> 8s
        //如果第一个异步 第二个同步  打印5s -> 3s
        //如果都异步  打印5s -> 3s
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
       
        NSLog(@"完成");
    });
}

//dispatch group 是GCD的一项特性 能够把任务分组
- (void)dispatchGroupDemo{

    //创建队列和组
    dispatch_queue_t queue = dispatch_queue_create("com.TYDemo.net", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    //任务
    dispatch_group_async(group, queue, ^{
       
        sleep(1);
        NSLog(@"First Complete");
    });
    
    dispatch_group_async(group, queue, ^{
       
        sleep(3);
        NSLog(@"Second Complete");
    });
    
    dispatch_group_notify(group, queue, ^{
       
        NSLog(@"dispatch_group_notify Complete");
    });
    
    
//    //这样会崩溃
//    dispatch_sync(dispatch_get_main_queue(), ^{
//
//        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//        NSLog(@"dispatch_group_wait Complete");
//    });

    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC));
    NSLog(@"dispatch_group_wait Complete");
    
    //需要注意的：dispatch_group_wait是同步的所以不能放在主线程执行。
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//
//        dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC));
//        NSLog(@"dispatch_group_wait Complete");
//
//    });
}


int globalA = 1;


- (void)queueDemo{
    
    dispatch_queue_t q = dispatch_get_main_queue();
    
    NSLog(@"卡死了吗？");
    
    //在主线程里面 有串行执行会卡死
//    卡死的原因是循环等待，主队列的东西要等主线程执行完，而因为是同步执行不能开线程，所以下面的任务要等上面的任务执行完，所以卡死。这是排列组合中唯一一个会卡死的组合。
//    dispatch_sync(q, ^{
//        NSLog(@"我来了");
//    });
    
    NSLog(@" come here");
}

- (void)blockDemo{
    
    void (^block)(void);
    BOOL condition = YES;
    //这样写法错误  因为定义在if和else语句中的俩个block都分配在栈内存中。编译器会给每个block分配好栈内存，然而等离开了相应的范围后，编译器有可能把分配给block的内存覆写。 于是俩个block都只能保证在对应的if或else语句范围内有效。这样写出来可以编译，运行会时而正确，时而不正确。 编译器未覆写的时候正确 覆写则会崩溃
    
    //注  写了10000次循环 没有出现崩溃现象。  ARC环境下以上说法有一定的问题
    //在ARC默认情况下,Block的内存存储在堆中,ARC会自动进行内存管理,程序员只需要避免循环引用即可
    //// 当Block变量出了作用域,Block的内存会被自动释放
    //在Block的内存存储在堆中时,如果在Block中引用了外面的对象,会对所引用的对象进行强引用,但是在Block被释放时会自动去掉对该对象的强引用,所以不会造成内存泄漏
//    for (int i = 0; i < 10000; i++) {
//
//        condition = arc4random()%2;
//        if (condition) {
//
//            block = ^{
//                NSLog(@"YES");
//            };
//        } else{
//
//            block = ^{
//
//                NSLog(@"NO");
//            };
//        }
//        block();
//    }

    
    //解决办法是  可以给blcok发送copy消息拷贝。这样可以把块从栈赋值到堆上，拷贝后的block可以在定义它的那个范围之外使用，而且一旦赋值到堆上，block就成了带引用计数的对象。后续的复制操作都不会真的执行复制，只是在递增block的引用计数 于是应该写作：
//    if (condition) {
//
//        block = [^{
//            NSLog(@"TES");
//        } copy];
//    } else{
//
//        block = [^{
//
//            NSLog(@"NO");
//        } copy];
//    }
//    block();
    
    
    
    //除了栈block和堆block 还有一种全局blcok.  这种block不会捕捉任何状态（比如外围的变量等）。运行时也无须有状态来参与，block使用的整个内存区域，在编译期已经完全确定，因为，全局block可以声明在全局内存里，而不需要在每次用到的时候于栈中创建。 另外，全局block的拷贝操作是个空操作，因为全局block决不可能为系统所回收，实际上相当于单例
    void(^globalBlock)(void) = ^{
        
        NSLog(@"this is a globalBlock");
    };
    
    
    //block 在实现时就会对它引用到的它所在方法中定义的栈变量进行一次只读拷贝，然后在 block 块内使用该只读拷贝；换句话说block截获自动变量的瞬时值；或者block捕获的是自动变量的副本。
    
   // 由于block捕获了自动变量的瞬时值，所以在执行block语法后，即使改写block中使用的自动变量的值也不会影响block执行时自动变量的值。
    int a = 1;
    void(^block1)(void) = ^{
      
//        a++;   //编译器报错  block中不能修改局部变量 可以访问
        NSLog(@"%d,",a);    //打印出来是1
    };
    a = 5;
    block1();
    
    int (^block2)(void) = ^{
        
        globalA++;     //可以修改和访问全局变量
        return globalA;
    };
    globalA = 5;
    int b = block2();  //6
    
    
    __block int a1 = 1;
    void(^block3)(void) = ^{
        
        NSLog(@"------%d", a1);  //打印出来是5
    };
    a1 = 5;
    block3();  //因为是在此处调用   调用之前已经修改了变量的值  注意区分局部变量的情况
    
    
}


//介绍block的种类
-(void) blockDemo1{
    
    void (^blk)(void) = ^{//没有截获自动变量的Block
        NSLog(@"Stack Block");
    };
    blk();
    NSLog(@"%@",[blk class]);//打印:__NSGlobalBlock__
    


    
    int i = 1;
    void (^captureBlk)(void) = ^{//截获自动变量i的Block
        NSLog(@"Capture:%d", i);
    };
    captureBlk();
    NSLog(@"%@",[captureBlk class]);//打印：__NSMallocBlock__
    
    //可以看到截获了自动变量的Block打印的类是NSGlobalBlock，表示存储在全局数据区。
    //捕获自动变量的Block打印的类却是设置在堆上的NSMallocBlock，而非栈上的NSStackBlock
    
    

    
    
    
    
    //栈上的block自动复制到堆上的情况
//    调用Block的copy方法
//    将Block作为函数返回值时
//    将Block赋值给__strong修改的变量时
//    向Cocoa框架含有usingBlock的方法或者GCD的API传递Block参数时
}

- (void)blockDemo2{
    
//    TYNSomeBlock block = ^(BOOL flag, int value){
//
//        if (flag) {
//
//            return value++;
//        } else{
//
//            return value--;
//        }
//    };
//
//    int b = block(YES, 2);
    
    [self dealNumberWithBlock:^int(BOOL flag, int value) {
       
        if (flag) {
            
             value++;
        } else{
            
             value--;
        }
        NSLog(@"%d", value);
        return value;
    }];
}

- (void)dealNumberWithBlock:(TYNSomeBlock)block{

    
    BOOL flag = arc4random() %2;
    int value = arc4random() % 6;
    NSLog(@"flag = %d, value = %d", flag, value);
    int b =  block(flag, value);
    NSLog(@"b=%d", b);
    
    //打印顺序
//    2018-06-21 15:56:59.584182+0800 TYDemoEffective-ObjC[94344:17000120] flag = 1, value = 4
//    2018-06-21 15:56:59.584334+0800 TYDemoEffective-ObjC[94344:17000120] 5
//    2018-06-21 15:56:59.584491+0800 TYDemoEffective-ObjC[94344:17000120] b=5
}


//同步锁安全机制实现方法
- (void)safeCodeDemo{
    
    //1.同步块   synchronization block
    @synchronized(self){
        //safe
    }
    
    
    //2.NSLock对象
    self.lock = [[NSLock alloc] init];
    self.lock1 = [[NSLock alloc] init];

    [_lock lock];
    //safe
    [_lock unlock];
    
    
    //3.串行同步队列 serial synchronization queue
    self.syncQueue = dispatch_queue_create("com.TYNEffectiveDemo.syncQueue",NULL);
    
    
    //4.多个获取方法可以并发执行 而获取方法和设置方法之间不能并发执行
    self.syncQueue4 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}


//实现1
- (void)setStr1:(NSString *)str1{
    
    @synchronized(self){
        _str1 = str1;
    }
}
- (NSString *)str1{
    
    @synchronized(self){
        return _str1;
    }
}


//实现2
- (void)setStr2:(NSString *)str2{
    
    [_lock lock];
    _str2 = str2;
    [_lock unlock];
}

- (NSString *)str2{
    
    [_lock1 lock];
    return _str2;
    [_lock1 unlock];
}

//实现3
- (void)setStr3:(NSString *)str3{
    
    dispatch_sync(_syncQueue, ^{
       
        _str3 = str3;
    });
    
    //可以把设置方法写成并发 因为设置方法不需要返回值 所有不一定非得同步 这样写可以提升执行速度。  但是犹豫异步派发执行 需要拷贝block,若是拷贝时间明显超过执行block的世界，这这种做法更慢
//    dispatch_async(_syncQueue, ^{
//
//        _str3 = str3;
//    });
}

- (NSString *)str3{
    
    __block NSString *localStr3;
    dispatch_sync(_syncQueue, ^{
       
        localStr3 = _str3;
    });
    
    return localStr3;
}

//实现4
//如果这样实现 还无法正确同步。 所有读取操作与写入操作都会在同一队列上执行。不过由于是并发队列，所以读取和写入操作可以随时执行。而我们恰恰不想让这些操作随意执行。 此问题可以用栅栏解决（barrier）
//在队列中，栅栏block必须单独执行，不能与其他block并行。 这只对并发队列有意义，因为串行队列中的block总是按顺序逐个来执行的。并发队列如果发现接下来要处理的block是栅栏block 那么就一直要等当前所有并发block都执行完毕，才会单独执行这个栅栏block.待栅栏block执行过后 再安正常方式继续向下
- (NSString *)str4{
    
    __block NSString *localStr4;
    dispatch_sync(_syncQueue4, ^{
       
        localStr4 = _str4;
    });
    
    return localStr4;
}
- (void)setStr4:(NSString *)str4{
    
//    dispatch_async(_syncQueue4, ^{
//
//        _str4 = str4;
//    });
    //栅栏 block
    dispatch_barrier_async(_syncQueue4, ^{
       
        _str4 = str4;
    });
}


//利用NSOperationQueue操作优点
//1.取消某个操作  cancel方法表示此任务不需执行，已经启动的无法取消 GCD无法取消（只能在应用程序层自己实现取消功能）
//2.指定操作之间的依赖关系 一个操作可以依赖其他多个操作
//3.NSOperation是对象，可以通过KVO来监听 如isCancelled（是否取消）isFinished（是否完成）
//4.指定操作的优先级。   GCD的优先级是针对整个队列来说的，不是针对每个block，
//5.可以重用NSOperation对象
- (void)operationDemo{
    
//    2018-06-22 10:41:53.366400+0800 TYDemoEffective-ObjC[97679:17632314] 1-----<NSThread: 0x60800006dc80>{number = 1, name = main}
//    2018-06-22 10:41:55.367926+0800 TYDemoEffective-ObjC[97679:17632314] 1-----<NSThread: 0x60800006dc80>{number = 1, name = main}
    //在没有使用NSOperationQueue，在主线中单独使用子类NSInvocationOperation执行一个操作的情况下，操作是在当前线程执行的，并没有开启新线程
//    [self userInvocationOperation];
    
    
//    2018-06-22 10:45:15.533316+0800 TYDemoEffective-ObjC[97739:17641953] 1-----<NSThread: 0x60c00026b980>{number = 3, name = (null)}
//    2018-06-22 10:45:17.537582+0800 TYDemoEffective-ObjC[97739:17641953] 1-----<NSThread: 0x60c00026b980>{number = 3, name = (null)}
    //如果在其他线程中执行操作  在其他线程中单独使用子类NSInvocationOperation，操作是在当前调用的其他线程执行的 没有开启新线程
//    [NSThread detachNewThreadSelector:@selector(userInvocationOperation) toTarget:self withObject:nil];
    
    
    
//    2018-06-22 10:49:45.284200+0800 TYDemoEffective-ObjC[97811:17654420] 1------<NSThread: 0x604000077740>{number = 1, name = main}
//    2018-06-22 10:49:47.285686+0800 TYDemoEffective-ObjC[97811:17654420] 1------<NSThread: 0x604000077740>{number = 1, name = main}
    //和上边 NSInvocationOperation 使用一样。因为代码是在主线程中调用的，所以打印结果为主线程。如果在其他线程中执行操作，则打印结果为其他线程。
//    [self userBlockOperation];
    
    
    //加多个操作
//    [self userBlockOperationAddExecution];
   
    
    //可以看出：在没有使用 NSOperationQueue、在主线程单独使用自定义继承自 NSOperation 的子类的情况下，是在主线程执行操作，并没有开启新线程。
//    [self useCustomOperation];
    
    
    
/*****************************NSOperationQueue队列******************************************/
//   NSOperationQueue 一共有两种队列：主队列、自定义队列。其中自定义队列同时包含了串行、并发功能。下边是主队列、自定义队列的基本创建方法和特点。
    
    //添加到主队列中的操作 都会放到主线程
//    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    //添加到自定义队列中的操作，就会自动放到子线程执行  同时包含了串行、并发功能
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    
//    使用 NSOperation 子类创建操作，并使用 addOperation: 将操作加入到操作队列后能够开启新线程，进行并发执行
//    [self addOperationToQueue];
    
    
    //设置最大并发数
//    [self setMaxConcurrentOperationCount];
    
    //添加依赖
//    [self addDependency];
    
    //设置优先级
//    [self setQueuePriority];
    
    //线程之间的通信
//    [self communication];
    
    
    //模拟线程不安全售票
    [self initTicketStatusNotSave];
}




//使用子类 NSInvocationOperation
- (void)userInvocationOperation{
    
    //1.创建NSInvocationOperation对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    //调用start方法开始执行操作
    [op start];
}

/**
 * 任务1
 */

-(void)task1{
    
    for (int i = 0; i < 2; i++) {
        
        [NSThread sleepForTimeInterval:2]; //模拟耗时操作
        NSLog(@"1-----%@", [NSThread currentThread]); //打印当前线程
    }
}

-(void)task2{
    
    for (int i = 0; i < 2; i++) {
        
        [NSThread sleepForTimeInterval:2]; //模拟耗时操作
        NSLog(@"2-----%@", [NSThread currentThread]); //打印当前线程
    }
}


//使用子类NSBlockOperation
- (void)userBlockOperation{
    
    //1.创建NSBlockOperation对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
       
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1------%@", [NSThread currentThread]);
        }
    }];
    
    
    
    [op start];
}

-(void)userBlockOperationAddExecution{
    
    //1.创建NSBlockOperation对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1------%@", [NSThread currentThread]);
        }
    }];
    
    
//    这些操作（包括 blockOperationWithBlock 中的操作）可以在不同的线程中同时（并发）执行。只有当所有相关的操作已经完成执行时，才视为完成。
    //如果添加的操作多的话，blockOperationWithBlock: 中的操作也可能会在其他线程（非当前线程）中执行，这是由系统决定的，并不是说添加到 blockOperationWithBlock: 中的操作一定会在当前线程中执行。（可以使用 addExecutionBlock: 多添加几个操作试试）。
    
//    一般情况下，如果一个 NSBlockOperation 对象封装了多个操作。NSBlockOperation 是否开启新线程，取决于操作的个数。如果添加的操作的个数多，就会自动开启新线程。当然开启的线程数是由系统来决定的。
    
    //可以看出：使用子类 NSBlockOperation，并调用方法 AddExecutionBlock: 的情况下，blockOperationWithBlock:方法中的操作 和 addExecutionBlock: 中的操作是在不同的线程中异步执行的。而且，这次执行结果中 blockOperationWithBlock:方法中的操作也不是在当前线程（主线程）中执行的。从而印证了blockOperationWithBlock: 中的操作也可能会在其他线程（非当前线程）中执行。
    
    
    //2.如果要添加额外操作
    [op addExecutionBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2------%@", [NSThread currentThread]);
        }
    }];
    
    [op addExecutionBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3------%@", [NSThread currentThread]);
        }
    }];
    
    [op addExecutionBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4------%@", [NSThread currentThread]);
        }
    }];
    
    [op addExecutionBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"5------%@", [NSThread currentThread]);
        }
    }];
    
    [op addExecutionBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"6------%@", [NSThread currentThread]);
        }
    }];
    
    [op addExecutionBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"7------%@", [NSThread currentThread]);
        }
    }];
    
    
    [op addExecutionBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"8------%@", [NSThread currentThread]);
        }
    }];
    
    //开始
    [op start];
}


//使用自定义线程
- (void)useCustomOperation{
    
    TYNOperation *op = [[TYNOperation alloc] init];
    
    [op start];
}


//将创建好的操作加入到队列中
- (void)addOperationToQueue{
    
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    
    //2.创建操作
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];

    
    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    
    
    //3.加入队列
    [queue addOperation:op];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    
    
    //另外一种方式为直接在加入队列的block里面创建操作  与上面的一样
//    [queue addOperationWithBlock:^{
//
//        for (int i = 0; i < 2; i++) {
//            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
//            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
//        }
//    }];
    
}


//设置最大并发数
//注意：这里 maxConcurrentOperationCount 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数。而且一个操作也并非只能在一个线程中运行。
//maxConcurrentOperationCount 默认情况下为-1，表示不进行限制，可进行并发执行。
//maxConcurrentOperationCount 为1时，队列为串行队列。只能串行执行。
//maxConcurrentOperationCount 大于1时，队列为并发队列。操作并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整为 min{自己设定的值，系统设定的默认最大值}。
- (void)setMaxConcurrentOperationCount {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
//    queue.maxConcurrentOperationCount = 1; //串行队列
    queue.maxConcurrentOperationCount = 2; //并发队列
//    queue.maxConcurrentOperationCount = 9; //并发队列

    [queue addOperationWithBlock:^{
       
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-----%@", [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-----%@", [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3-----%@", [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4-----%@", [NSThread currentThread]);
        }
    }];
}


//操作依赖
//- (void)addDependency:(NSOperation *)op; 添加依赖，使当前操作依赖于操作 op 的完成。
//- (void)removeDependency:(NSOperation *)op; 移除依赖，取消当前操作对操作 op 的依赖。
//@property (readonly, copy) NSArray<NSOperation *> *dependencies; 在当前操作开始执行之前完成执行的所有操作对象数组。
- (void)addDependency{
    
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    queue.maxConcurrentOperationCount = 3;

    
    //2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-----%@", [NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-----%@", [NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        
        for (int i = 0; i < 2; i++) {
            
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3-----%@", [NSThread currentThread]);
        }
    }];
    
    //3，添加依赖  先执行后者
    [op2 addDependency:op1];
    
    //4.添加操作到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}


//设置优先级
//NSOperation 提供了queuePriority（优先级）属性，queuePriority属性适用于同一操作队列中的操作，不适用于不同操作队列中的操作。默认情况下，所有新创建的操作对象优先级都是NSOperationQueuePriorityNormal。但是我们可以通过setQueuePriority:方法来改变当前操作在同一队列中的执行优先级。
//typedef NS_ENUM(NSInteger, NSOperationQueuePriority) {
//    NSOperationQueuePriorityVeryLow = -8L,
//    NSOperationQueuePriorityLow = -4L,
//    NSOperationQueuePriorityNormal = 0,
//    NSOperationQueuePriorityHigh = 4,
//    NSOperationQueuePriorityVeryHigh = 8
//};
//queuePriority 属性决定了进入准备就绪状态下的操作之间的开始执行顺序。并且，优先级不能取代依赖关系。
//如果一个队列中既包含高优先级操作，又包含低优先级操作，并且两个操作都已经准备就绪，那么队列先执行高优先级操作。比如上例中，如果 op1 和 op4 是不同优先级的操作，那么就会先执行优先级高的操作。
//如果，一个队列中既包含了准备就绪状态的操作，又包含了未准备就绪的操作，未准备就绪的操作优先级比准备就绪的操作优先级高。那么，虽然准备就绪的操作优先级低，也会优先执行。优先级不能取代依赖关系。如果要控制操作间的启动顺序，则必须使用依赖关系。
- (void)setQueuePriority{
    
    
    //优先级并不能保证先后顺序
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    
    //2.创建操作
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    op.queuePriority = NSOperationQueuePriorityHigh;
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    op2.queuePriority = NSOperationQueuePriorityNormal;

    
    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    op3.queuePriority = NSOperationQueuePriorityLow;
    
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"5---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    op5.queuePriority = NSOperationQueuePriorityVeryLow;
//    [op5 addDependency:op2];
    
    
    
    //3.加入队列
    [queue addOperation:op];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op5];
}

//在 iOS 开发过程中，我们一般在主线程里边进行 UI 刷新，例如：点击、滚动、拖拽等事件。我们通常把一些耗时的操作放在其他线程，比如说图片下载、文件上传等耗时操作。而当我们有时候在其他线程完成了耗时操作时，需要回到主线程，那么就用到了线程之间的通讯。
- (void)communication{
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
        
        //回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           
            //比如进行UI操作之类
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
            }
        }];
    }];
    
}

//模拟线程不安全卖票
- (void)initTicketStatusNotSave{
    
    NSLog(@"currentThread-----%@", [NSThread currentThread]);
    self.ticketSurplusCount = 50;
    
    //1.创建队列代表车票售卖窗口1
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
//    NSOperationQueue *queue1 = [NSOperationQueue mainQueue];//如果加入主队了则安全的 因为其为串行队列  但是耗时操作会阻塞

    queue1.maxConcurrentOperationCount = 1;
    
    //2.创建队列代表车票售卖窗口2
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;
    
    //创建卖票操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
       
        [self saleTicketNotSafe];
    }];
    
    //创建卖票操作
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        
        [self saleTicketNotSafe];
    }];
    
    //开始
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
    
    self.ticketLock = [[NSLock alloc] init];
//   在不考虑线程安全，不使用 NSLock 情况下，得到票数是错乱的，这样显然不符合我们的需求，所以我们需要考虑线程安全问题。
    
}

- (void)saleTicketNotSafe{
    

        
  
    while (1) {
        
        //    [self.ticketLock lock];  //1.
        //    @synchronized(self) {    //2.
        
        
        if (self.ticketSurplusCount > 0) {
            
            self.ticketSurplusCount--;
            NSLog(@"剩余票数:%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        }
        
        //    }
        //    [self.ticketLock unlock];
        
        if(self.ticketSurplusCount <= 0){
            NSLog(@"所有火车票售完");
            break;
        }
    }

}


// NSOperation 常用属性和方法
//
//取消操作方法
//- (void)cancel; 可取消操作，实质是标记 isCancelled 状态。
//判断操作状态方法
//- (BOOL)isFinished; 判断操作是否已经结束。
//- (BOOL)isCancelled; 判断操作是否已经标记为取消。
//- (BOOL)isExecuting; 判断操作是否正在在运行。
//- (BOOL)isReady; 判断操作是否处于准备就绪状态，这个值和操作的依赖关系相关。
//操作同步
//- (void)waitUntilFinished; 阻塞当前线程，直到该操作结束。可用于线程执行顺序的同步。
//- (void)setCompletionBlock:(void (^)(void))block; completionBlock 会在当前操作执行完毕时执行 completionBlock。
//- (void)addDependency:(NSOperation *)op; 添加依赖，使当前操作依赖于操作 op 的完成。
//- (void)removeDependency:(NSOperation *)op; 移除依赖，取消当前操作对操作 op 的依赖。
//@property (readonly, copy) NSArray<NSOperation *> *dependencies; 在当前操作开始执行之前完成执行的所有操作对象数组。
// NSOperationQueue 常用属性和方法
//
//取消/暂停/恢复操作
//- (void)cancelAllOperations; 可以取消队列的所有操作。
//- (BOOL)isSuspended; 判断队列是否处于暂停状态。 YES 为暂停状态，NO 为恢复状态。
//- (void)setSuspended:(BOOL)b; 可设置操作的暂停和恢复，YES 代表暂停队列，NO 代表恢复队列。
//操作同步
//- (void)waitUntilAllOperationsAreFinished; 阻塞当前线程，直到队列中的操作全部执行完毕。
//添加/获取操作`
//- (void)addOperationWithBlock:(void (^)(void))block; 向队列中添加一个 NSBlockOperation 类型操作对象。
//- (void)addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait; 向队列中添加操作数组，wait 标志是否阻塞当前线程直到所有操作结束
//- (NSArray *)operations; 当前在队列中的操作数组（某个操作执行结束后会自动从这个数组清除）。
//- (NSUInteger)operationCount; 当前队列中的操作数。
//获取队列
//+ (id)currentQueue; 获取当前队列，如果当前线程不是在 NSOperationQueue 上运行则返回 nil。
//+ (id)mainQueue; 获取主队列。


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
