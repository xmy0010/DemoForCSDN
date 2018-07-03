//
//  TYDirectorTableViewController.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/4.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYDirectorTableViewController.h"
#import "TYContentShowViewController.h"
#import "TYDemoChapter_1Controller.h"

#import "TYChapterCell.h"


@interface TYDirectorTableViewController ()

@property(nonatomic, strong) NSArray *dataArray;

@property(nonatomic, strong) NSArray *pageNumberInfo;

@end

@implementation TYDirectorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Demo" style:UIBarButtonItemStylePlain target:self action:@selector(onRightItem)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 展示Demo页
- (void)onRightItem{
    
    //用类的名称 来获取类对象 然后创建实例对象
    
    NSString *name = @"TYDemoChapter_";
    if (_Chapter >= 2) {
        
        //看了第三章 命名规则  苹果宣布保留所有开头俩个字母的命名 一般自定义类需开头三个字母
        name = @"TYNDemoChapter_";
    }
    
    NSString *className = [NSString stringWithFormat:@"%@%ldController",name, (long)(_Chapter + 1)];
    Class class = NSClassFromString(className);
    TYBaseViewController *vc = [[class alloc] init];
    vc.title = @"请查看源代码";
    [self.navigationController pushViewController:vc animated:YES];
//    [self showViewController:vc sender:nil];
//    switch (_Chapter) {
//        case 0:{
//
//            TYDemoChapter_1Controller *vc = [[TYDemoChapter_1Controller alloc] init];
//            [self showViewController:vc sender:self];
//        }
//
//            break;
//        case 1:{
//
//            TYDemoChapter_1Controller *vc = [[TYDemoChapter_1Controller alloc] init];
//            [self showViewController:vc sender:self];
//        }
//
//            break;
//        default:
//            break;
//    }
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TYDirectoryModel *model = self.dataArray[indexPath.row];
    
    CGFloat height = model.cellHeight;
    if (height < 44) {
        
        return 44;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"Cell";
    TYChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[TYChapterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    TYDirectoryModel *model = self.dataArray[indexPath.row];
    cell.titleLB.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
  
    
    TYDirectoryModel *model = self.dataArray[indexPath.row];
    TYContentShowViewController *vc = [[TYContentShowViewController alloc] init];
    vc.section = model.section;
    if (model.section > 27) {
        
        [self showTip:@"请自行查看书籍"];
        return;
    }
    vc.pageNumber = [self.pageNumberInfo[model.section] integerValue];
    vc.title = model.title;
    
    
    [self showViewController:vc sender:self];
}


- (NSArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [self getDataArrayWithChapter];
    }
    
    return _dataArray;
}

//根据章节生成目录
- (NSArray *)getDataArrayWithChapter{
    
    NSArray *titles = @[@"了解Objective-C语言的起源",
                        @"在类的头文件中尽量少引入其他头文件",
                        @"多用字面量语法，少用与之等价的方法",
                        @"多用类型常量，少用#define预处理指令",
                        @"用枚举表示状态、选项、状态码",
                        @"理解’属性‘这一概念",
                        @"在对象内部尽量直接访问实例变量",
                        @"理解'对象等同性'这一概念",
                        @"以’类族模式‘隐藏实现细节",
                        @"在既有类中使用关联对象存放自定义数据",
                        @"理解objc_msgSend的作用",
                        @"理解消息转发机制",
                        @"用’方法调配技术‘调式’黑盒方法‘",
                        @"理解’类对象‘的用意",
                        @"用前缀避免命名空间冲突",
                        @"提供’全能初始化方法‘",
                        @"实现description方法",
                        @"尽量使用不可变对象",
                        @"使用清晰而协调的命名方式",
                        @"为私有方法名加前缀",
                        @"理解Objective-C错误模型",
                        @"理解NSCopying协议",
                        @"通过委托与数据源协议进行对象间通信",
                        @"将类的实现代码分散到便于管理的数个分类之中",
                        @"总是为第三方类的分类名称加前缀",
                        @"勿在分类中声明属性",
                        @"使用’class-continuation‘分类隐藏实现细节",
                        @"通过协议提供匿名对象",
                        @"理解引用计数",
                        @"以ARC简化引用计数",
                        @"在dealloc方法中只释放引用并解除监听",
                        @"编写’异常安全代码‘时留意内存管理问题",
                        @"以弱引用避免保留环",
                        @"以’自动释放池块‘降低内存峰值",
                        @"用’僵尸对象‘调试内存管理问题",
                        @"不要使用retainCount",
                        @"理解’块‘这一概念",
                        @"为常用的块类型创建typedef",
                        @"用handler块降低代码分散程度",
                        @"用块引用其所属对象时不要出现保留环",
                        @"多用派发队列，少用同步锁",
                        @"多用GCD，少用performSelector系列方法",
                        @"掌握GCD及操作队列的使用时机",
                        @"通过Dispatch Group机制，根据系统资源状况来执行任务",
                        @"使用dispatch_once来执行只需运行一次的线程安全代码",
                        @"不要使用dispatch_get_current_queue",
                        @"熟悉系统框架",
                        @"多用块枚举，少用for循环",
                        @"对自定义其内存管理语义的collection使用无缝桥接",
                        @"构建缓存时选用NSCache，而非NSDictionnary",
                        @"精简initialize与load的实现代码",
                        @"别忘了NSTimer会保留其目标对象"];
    
    NSMutableArray *tempData = @[].mutableCopy;
    [titles enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TYDirectoryModel *model = [[TYDirectoryModel alloc] initWithTile:[NSString stringWithFormat:@"第%ld条 %@", idx + 1, obj] detail:nil];
        model.section = idx + 1;
        [tempData addObject:model];
    }];
    
    NSRange range = NSMakeRange(0, 1);
    switch (_Chapter) {
        case 0:{
            
            range = NSMakeRange(0, 5);
            break;
        }
        case 1:{
            
            range = NSMakeRange(5, 9);
            break;
        }
        case 2:{
            
            range = NSMakeRange(14, 8);
            break;
        }
        case 3:{
            
            range = NSMakeRange(22, 6);
            break;
        }
        case 4:{
            
            range = NSMakeRange(28, 8);
            break;
        }
        case 5:{
            
            range = NSMakeRange(36, 10);
            break;
        }
        case 6:{
            
            range = NSMakeRange(46, 6);
            break;
        }
    }
    
    
    return [tempData subarrayWithRange:range];
}

//每小节的页码信息
- (NSArray *)pageNumberInfo{
    if (!_pageNumberInfo) {
        
        _pageNumberInfo = @[
                            //第一章
                            @0,
                            @4,
                            @4,
                            @5,
                            @4,
                            @6,
                            
                            //第二章
                            @6,
                            @3,
                            @6,
                            @5,
                            @4,
                            @5,
                            @5,
                            @5,
                            @4,
                            
                            //第三章
                            @5,
                            @6,
                            @5,
                            @6,
                            @3,
                            @3,
                            @7,
                            @3,
                            
                            //第四章
                            @8,
                            @4,
                            @3,
                            @3,
                            @7,
                            @4
                            
                            //第五章
                            ];
    }
    
    return _pageNumberInfo;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
