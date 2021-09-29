//
//  ViewController.m
//  littleFunctions
//
//  Created by zwzh_14 on 2021/9/23.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>
#import "Person.h"

@interface ViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onBtnClick:(id)sender {
    //    [self createMessage];
    [self objectArrayRemoveDuplicates];
}

#pragma mark - 调用系统短信
- (void)createMessage {
    //模拟电信查话费
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = @[@"10001"];
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = @"108";
        controller.messageComposeDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"查话费"];
    } else {
        NSLog(@"该设备不支持短信功能");
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"用户取消发送");
            break;
        default:
            break;
    }
}

#pragma mark 对象数组添加另一数组并去重
-(void)objectArrayRemoveDuplicates {
    NSMutableArray *origin_arr1 = @[].mutableCopy;
    for (int i = 0; i < 1000; i++) {
        Person *person = [[Person alloc] init];
        person.name = [NSString stringWithFormat:@"name_%d",i];
        person.ID = [NSString stringWithFormat:@"ID_%d",i];
        [origin_arr1 addObject:person];
    }
    
    NSMutableArray *origin_arr2 = @[].mutableCopy;
    for (int i = 0; i < 2000; i++) {
        if (i % 2 == 0) {
            Person *person = [[Person alloc] init];
            person.name = [NSString stringWithFormat:@"name_%d",i];
            person.ID = [NSString stringWithFormat:@"ID_%d",i];
            [origin_arr2 addObject:person];
        }
    }
    
    //    1.嵌套for循环
    NSMutableArray *arr1 = origin_arr1.mutableCopy;
    NSMutableArray *arr2 = origin_arr2.mutableCopy;
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    for (Person *person in arr2) {
        BOOL isRepeat = NO;
        for (Person *anotherPerson in arr1) {
            if ([person.ID isEqualToString:anotherPerson.ID]) {
                isRepeat = YES;
                break;
            }
        }
        if (!isRepeat) {
            [arr1 addObject:person];
        }
    }
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"方法1计算时长 : %f ms", linkTime *1000.0);
    
    //2.对 arr2 进行遍历，将 arr2 中并存在于 arr1 中的对象删除；
    arr1 = origin_arr1.mutableCopy;
    arr2 = origin_arr2.mutableCopy;
    
    startTime = CFAbsoluteTimeGetCurrent();
    NSMutableDictionary *dic = @{}.mutableCopy;
    for (Person *person in arr1) {
        [dic setObject:person forKey:person.ID];
    }
    [arr2 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(Person *person, NSUInteger idx, BOOL * _Nonnull stop) {
        Person *dic_person = dic[person.ID];
        if (dic_person) {
            [arr2 removeObject:person];
        }
    }];
    [arr1 addObjectsFromArray:arr2];
    linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"方法2计算时长 : %f ms", linkTime *1000.0);
    
    
    //3.对 arr2 进行遍历，将 arr2 中不存在于 arr1 中的对象保存到新的数组中；
    arr1 = origin_arr1.mutableCopy;
    arr2 = origin_arr2.mutableCopy;
    
    startTime = CFAbsoluteTimeGetCurrent();
    dic = @{}.mutableCopy;
    for (Person *person in arr1) {
        [dic setObject:person forKey:person.ID];
    }
    //        NSMutableArray *newArr = @[].mutableCopy;
    [arr2 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(Person *person, NSUInteger idx, BOOL * _Nonnull stop) {
        Person *dic_person = dic[person.ID];
        if (!dic_person) {
            //            [newArr addObject:person];
            [arr1 addObject:person];
        }
    }];
    //        [arr1 addObjectsFromArray:newArr];
    linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"方法3计算时长 : %f ms", linkTime *1000.0);
    //
    //4.将arr2先添加到arr1中 再对arr1中重复元素进行删除
    arr1 = origin_arr1.mutableCopy;
    arr2 = origin_arr2.mutableCopy;
    startTime = CFAbsoluteTimeGetCurrent();
    [arr1 addObjectsFromArray:arr2];
    dic = @{}.mutableCopy;
    [arr1 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(Person *person, NSUInteger idx, BOOL * _Nonnull stop) {
        Person *dic_person = dic[person.ID];
        if (!dic_person) {
            [dic setObject:person forKey:person.ID];
        } else {
            [arr1 removeObject:dic_person];
        }
        
    }];
    linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"方法4计算时长 : %f ms", linkTime *1000.0);
}

@end
