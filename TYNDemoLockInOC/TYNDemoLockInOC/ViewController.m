//
//  ViewController.m
//  TYNDemoLockInOC
//
//  Created by T_yun on 2018/6/22.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
#import <os/lock.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;


@property(nonatomic, assign) int ticketNumber;

@property(nonatomic, strong) NSLock *lock;


@end

@implementation ViewController

dispatch_semaphore_t signal_time;
pthread_mutex_t theLock;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.ticketNumber = 50;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setTicketNumber:(int)ticketNumber{
    
    _ticketNumber = ticketNumber;
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSString *title = [NSString stringWithFormat:@"剩余%d张票", ticketNumber];
        if (ticketNumber == 0) {
            
            title = @"票已售完";
        }
        self.label.text = title;
    });
}

- (IBAction)oneTicketBooking:(id)sender {
    
    if (![self preparatoryStage]) {
        
        return;
    }
    //一个队列 一个线程
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
       
        [self saleTicket];
    }];
}

- (IBAction)twoTicketBooking:(id)sender {
    
    if (![self preparatoryStage]) {
        
        return;
    }


    //俩个队列  每个里面一个线程
    //1.创建队列代表车票售卖窗口1
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    //    NSOperationQueue *queue1 = [NSOperationQueue mainQueue];//如果加入主队了则安全的 因为其为串行队列  但是耗时操作会阻塞

    queue1.maxConcurrentOperationCount = 1;

    //2.创建队列代表车票售卖窗口2
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;

    //创建卖票操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{

        [self saleTicket];
    }];

    //创建卖票操作
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{

        [self saleTicket];
    }];

    //开始
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
    

}

- (IBAction)fiveTicketBooking:(id)sender {
    
    if (![self preparatoryStage]) {
        
        return;
    }
    
    
    
    //俩个队列  每个里面多个线程
    //1.创建队列代表车票售卖窗口1
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    //    NSOperationQueue *queue1 = [NSOperationQueue mainQueue];//如果加入主队了则安全的 因为其为串行队列  但是耗时操作会阻塞
    
    queue1.maxConcurrentOperationCount = 1;
    
    //2.创建队列代表车票售卖窗口2
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;
    
    //创建卖票操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        
        [self saleTicket];
    }];
    
    //创建卖票操作
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        
        [self saleTicket];
    }];
    
    //创建卖票操作
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        
        [self saleTicket];
    }];
    
    //创建卖票操作
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        
        [self saleTicket];
    }];
    //创建卖票操作
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        
        [self saleTicket];
    }];
    

    
    //开始
    [queue1 addOperation:op1];
    [queue1 addOperation:op2];
    [queue2 addOperation:op3];
    [queue2 addOperation:op4];
    [queue2 addOperation:op5];


}



//OSSpinLock和dispatch_semaphore的效率远远高于其他。
//
//@synchronized和NSConditionLock效率较差。
//
//鉴于OSSpinLock的不安全，所以我们在开发中如果考虑性能的话，建议使用dispatch_semaphore。
//
//如果不考虑性能，只是图个方便的话，那就使用@synchronized。

- (void)saleTicket{
    

    
//    [self saleTicketNoSafe];
    [self saleTicketWithSynchornized];
//    [self saleTicketWithDispatch_semaphore];  //注意在准备函数里的条件
//    [self saleTicketWithNSLock];        //注意在准备函数里的条件
//    [self saleTicketWithPthread_mutex]; //注意在准备函数里的条件
}


//准备阶段
- (BOOL)preparatoryStage{
    //先复位
    if (self.ticketNumber == 0) {
        
        self.ticketNumber = 50;
        
    } else if(self.ticketNumber != 50){
        
        return NO;
    }
    
//    signal_time = dispatch_semaphore_create(1);
    
//    self.lock = [[NSLock alloc] init];
    
     pthread_mutex_init(&theLock, NULL); //静态创建
    
    
    
    return YES;
}

#pragma Mark 非线程安全
- (void)saleTicketNoSafe{
    
    while (1) {
        
        if (self.ticketNumber > 0) {
            
            self.ticketNumber--;
            [NSThread sleepForTimeInterval:0.2];
            NSLog(@"剩余票数:%d 窗口：%@", self.ticketNumber, [NSThread currentThread]);
        }
        
        if (self.ticketNumber <= 0) {
            
            NSLog(@"本次出票失败");
            break;
        }
    }
}



#pragma mark @synchronized
- (void)saleTicketWithSynchornized{
    
    
    while (1) {
        
        @synchronized(self){
            
            if (self.ticketNumber > 0) {
                
                self.ticketNumber--;
                [NSThread sleepForTimeInterval:0.2];
                NSLog(@"剩余票数:%d 窗口：%@", self.ticketNumber, [NSThread currentThread]);
            }
            
        }
        if (self.ticketNumber <= 0) {
            
            NSLog(@"本次出票失败");
            break;
        }
    }

}

#pragma mark dispatch_semaphore
- (void)saleTicketWithDispatch_semaphore{
    

    while (1) {
        
        dispatch_semaphore_wait(signal_time, DISPATCH_TIME_FOREVER);
            
            //*****
        if (self.ticketNumber > 0) {
                
            self.ticketNumber--;
            [NSThread sleepForTimeInterval:0.2];
            NSLog(@"剩余票数:%d 窗口：%@", self.ticketNumber, [NSThread currentThread]);
        }
            //*****

        if (self.ticketNumber <= 0) {
            
            dispatch_semaphore_signal(signal_time);

            NSLog(@"本次出票失败");
            break;
        }
        dispatch_semaphore_signal(signal_time);

    
    }

}


#pragma Mark NSLock
//类似的有NSRecursiveLock递归锁 和条件锁NSConditionLock 后面有介绍 NSCondition
- (void)saleTicketWithNSLock{
    
    
    while (1) {
        
        [_lock lock];
            if (self.ticketNumber > 0) {
                
                self.ticketNumber--;
                [NSThread sleepForTimeInterval:0.2];
                NSLog(@"剩余票数:%d 窗口：%@", self.ticketNumber, [NSThread currentThread]);
            }
        
        [_lock unlock];
        if (self.ticketNumber <= 0) {
            
            NSLog(@"本次出票失败");
            break;
        }
    }

}

#pragma Mark pthread_mutex
//此种方法也有pthread_mutex(recursive) 递归锁
- (void)saleTicketWithPthread_mutex{
    
    while (1) {
        
        pthread_mutex_lock(&theLock);
        if (self.ticketNumber > 0) {
            
            self.ticketNumber--;
            [NSThread sleepForTimeInterval:0.2];
            NSLog(@"剩余票数:%d 窗口：%@", self.ticketNumber, [NSThread currentThread]);
        }
        
        pthread_mutex_unlock(&theLock);
        if (self.ticketNumber <= 0) {
            
            NSLog(@"本次出票失败");
            break;
        }
    }

}

#pragma Mark OSSpinLock
//此方法在不再安全
//https://blog.ibireme.com/2016/01/16/spinlock_is_unsafe_in_ios/

@end
