//
//  TYNDemoChapter_3Controller.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/12.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYNDemoChapter_3Controller.h"
#import "TYDemo3DelegateController.h"
#import "TYNInitModel.h"




@interface TYNDemoChapter_3Controller ()<TYNChapter3Delegate>



@end

@implementation TYNDemoChapter_3Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self initAndDescriptionDemo];
    
//    [self copyDemo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//对象实现拷贝
- (void)copyDemo{
    
    TYNInitModel *model1 = [[TYNInitModel alloc] initWithP1:@"p11" P2:@"p21" P3:@"p31"];
    TYNInitModel *model2 = [[TYNInitModel alloc] initWithP1:@"p12" P2:@"p22" P3:@"p32"];
    TYNInitModel *model3 = [[TYNInitModel alloc] initWithP1:@"p13" P2:@"p23" P3:@"p33"];
    
    TYNInitModel *model4 = [[TYNInitModel alloc] initWithP1:@"p14" P2:@"p24" P3:@"p34"];
    
    TYNInitModel *model5 = [[TYNInitModel alloc] initWithP1:@"p15" P2:@"p25" P3:@"p35"];
    [model4 addFriend:model5];
    [model2 addFriend:model4];

    
    [model1 addFriend:model2];
    [model1 addFriend:model3];

    NSLog(@"%@", model1);
    
    
    //浅拷贝   对面里面的容器friends地址不一样 但是里面装的指针指向相同的对象地址
    TYNInitModel *modelCopy = model1.copy;
    NSLog(@"%@", modelCopy);
    
    
    
//    NSArray *arr = [[NSArray alloc] initWithArray:model1.friends copyItems:YES];
    //俩个数组里面对象的地址是不相等的。
    
    //深拷贝
    TYNInitModel *deepCopy = model1.deepCopy;
    
    
    NSLog(@"%@", deepCopy);
    
    //到此处  model1与 modelCopy地址不同  其_intenalFriends地址不同  里面的俩元素地址相同
    // model1与 deepCopy地址不同  其_intenalFriends地址不同  里面的俩元素地址不同  里面的第一个元素的里面的_intenalFriends里的元素相同 都是model4
    //（如果在copyWithZone里面写为深拷贝）  则每一层都会深拷贝 固自己写的深拷贝方法不如在copyWithZone里面写深拷贝
}


//全能初始化方法和实现描述
-(void)initAndDescriptionDemo{
    
    TYNInitModel *model = [[TYNInitModel alloc] initWithP1:@"111" P2:@"2222" P3:@"333"];
    
    NSLog(@"%@", model);
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
