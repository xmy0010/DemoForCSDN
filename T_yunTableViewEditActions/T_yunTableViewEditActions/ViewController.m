//
//  ViewController.m
//  T_yunTableViewEditActions
//
//  Created by T_yun on 2016/12/19.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import "ViewController.h"
#import "TyunModel.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <TyunModel *>*dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"左滑多功能";
    
    [self customTableView];
    
    //线条画满
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 懒加载数据
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        
        _dataArray = @[].mutableCopy;
        NSArray *lastNames = @[@"赵",
                               @"钱",
                               @"孙",
                               @"李"];
        NSArray *firstNames = @[@"虎",@"龙",@"狼",@"豹",@"蛇"];
        //双重循环创建对象
        for (int i = 0; i < lastNames.count; i++) {
            for (int j = 0; j < firstNames.count; j++) {
                
                NSString *name = [NSString stringWithFormat:@"%@%@", lastNames[i], firstNames[j]];
                int ID = i * (int)lastNames.count + j;
                TyunModel *model = [[TyunModel alloc] initWithName:name ID:ID];
                [_dataArray addObject:model];
            }
        }
        
    }
    
    return _dataArray;
}

#pragma mark 定制tableView
- (void)customTableView {

    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] init];
    self.tableView = table;
    
    [self.view addSubview:_tableView];
}

#pragma mark <UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
    }
    
    TyunModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d号", model.ID];
    
    return cell;
}

#pragma Mark 左滑按钮 iOS8以上
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //先删数据 再删UI
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    //添加一个置顶按钮
    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        TyunModel *model = self.dataArray[indexPath.row];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.dataArray insertObject:model atIndex:0];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //
        //            [tableView reloadData];
        //        });
        [tableView setEditing:NO];
    }];
    topAction.backgroundColor = [UIColor blueColor];
    
    //添加一个编辑按钮
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        TyunModel *model = self.dataArray[indexPath.row];
        
        //弹窗输入名字
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改" message:@"请输入新名字" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"此处输入名字";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [tableView setEditing:NO];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *textfield = alert.textFields.firstObject;
            NSString *newName = textfield.text;
            if (newName == nil) {
                
                newName = @"";
            }
            model.name = newName;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
    editAction.backgroundColor = [UIColor greenColor];
    
    return @[deleteAction, topAction, editAction];
}

#pragma 设置线条画满
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
