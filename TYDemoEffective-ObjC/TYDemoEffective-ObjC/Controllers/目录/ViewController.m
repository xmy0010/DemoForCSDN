//
//  ViewController.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/4.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "ViewController.h"
#import "TYDirectoryModel.h"
#import "TYDirectorCell.h"
#import "TYDirectorTableViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"目录";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Table Delegate&Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    TYDirectoryModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"Cell";
    TYDirectorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[TYDirectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.dataArray[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TYDirectoryModel *model = self.dataArray[indexPath.row];
    TYDirectorTableViewController *vc = [[TYDirectorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.Chapter = indexPath.row;
    vc.title = [NSString stringWithFormat:@"第%ld章 %@", indexPath.row + 1, model.title];
    [self showViewController:vc sender:self];
}


#pragma mark lazy load
- (NSArray *)dataArray{
    if (!_dataArray) {
        
        NSArray *titles = @[@"熟悉Objective-C",
                       @"对象、消息、运行期",
                       @"接口与API设计",
                       @"协议与分类",
                       @"内存管理",
                       @"块与大中枢派发",
                       @"系统框架"];
        NSArray *details = @[@"通论该语音的核心概念",
                             @"对象之间能够关联与交互，这是面向对象语言的重要特性。本章讲述这些特征，并深入研究代码在运行期的行为",
                             @"很少有那种写完就不再复用的代码。即使代码不向更多人公开，也已然有可能用在自己的多个项目中。本章讲解如何编写与Objective-C搭配得宜的类。",
                             @"协议与分类是俩个需要掌握的重要语言特性。若运用得当，则可令代码易读、易维护且少出错。本章将帮助读者精通这俩个概念。",
                             @"Objective-C语言以引用计数来管理内存，这令许多初学者纠结，要是用过以'垃圾收集器'（garbage collector）来管理内存的语言，那么更会如此。‘自动引用计数’机制缓解了此问题，不过使用时有很多重要的注意事项，以确保对象模型正确，不致内存泄露。本章提醒读者注意内存管理中易犯的错误。",
                             @"苹果公司引入了'块'这一概念，其语法类似于C语言中的‘闭包’（closure）。在Objective-C语言中，我们通常用块来实现一些原来需要很多样板代码才能完成的事情，块还能实现‘代码分离’（code separation）。‘大中枢派发’（Grand Central Dispatch,GCD）提供了一套用于多线程环境的简单接口。‘块’可视为GCD的任务，根据系统资源状况，这些任务也许能并发执行。本章将将会读者如何充分运用这俩项核心技术。",
                             @"大家通常会用Objective-C来开发Mac OS X或iOS程序。在这俩种情况下都有一套完整的系统框架可供使用，前者名为Cocoa,后者名为Cocoa Touch。本章将总览这些框架，并深入研究其中某些类。"];
        
        NSMutableArray *tempArray = @[].mutableCopy;
        for (int i = 0; i < titles.count; i++) {
            
            NSString *title = titles[i];
            NSString *detail = details[i];
            
            TYDirectoryModel *model = [[TYDirectoryModel alloc] initWithTile:title detail:detail];
            [tempArray addObject:model];
        }
        _dataArray = tempArray.copy;
        
    }
    
    return _dataArray;
}

@end
