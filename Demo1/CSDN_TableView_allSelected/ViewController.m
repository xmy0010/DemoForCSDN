//
//  ViewController.m
//  CSDN_TableView_allSelected
//
//  Created by T_yun on 16/3/18.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

//当前选中的数据
@property (nonatomic, strong) NSMutableArray *selectedData;

@property (nonatomic, assign) BOOL isAllSelected;

@end

@implementation ViewController

- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        
        NSArray  *names = @[@"Mars",
                            @"gogoing",
                            @"TableView",
                            @"runtime",
                            @"blackMagic",
                            @"CSDN",
                            @"This",
                            @"Swift",
                            @"Mars",
                            @"gogoing",
                            @"TableView",
                            @"runtime",
                            @"blackMagic",
                            @"CSDN",
                            @"This",
                            @"Swift"];
        
        _dataArray = @[].mutableCopy;
        [names enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
           
            Model *model = [[Model alloc] initWithID:[NSString stringWithFormat:@"%ld", idx] name:name];
            [_dataArray addObject:model];
        }];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"多选cellDemo";
    
    self.selectedData = @[].mutableCopy;
    [self customTableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selecteAllCells:)];
    
}


#pragma mark Actions
- (void)selecteAllCells:(UIBarButtonItem *)sender {
    if (_isAllSelected == NO) {
        
        _isAllSelected = YES;
        [sender setTitle:@"取消"];
        
        self.selectedData = self.dataArray.mutableCopy;

        for (int i = 0; i < self.dataArray.count; i++) {

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        for (Model *data in self.selectedData) {
            
            NSLog(@"%@", data.name);
        }
        
    } else {
        
        _isAllSelected = NO;
        [sender setTitle:@"全选"];
        self.selectedData = @[].mutableCopy;
        for (int i = 0; i < self.dataArray.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        for (Model *data in self.selectedData) {
            
            NSLog(@"%@", data.name);
        }
    }
    
}

#pragma mark UI

- (void)customTableView {
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.editing = YES;
    table.allowsMultipleSelectionDuringEditing = YES;
    table.tableFooterView = [[UIView alloc] init];
    self.tableView = table;
    
    [self.view addSubview:_tableView];
    
}


#pragma mark <UITableDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return   self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *reuseID = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    Model *model = self.dataArray[indexPath.row];
    cell.textLabel.text =  model.name;
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    
    return cell;
}

#pragma mark <UITableViewDelegate>
//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Model *model = self.dataArray[indexPath.row];

    [self.selectedData addObject:model];
    
    for (Model *data in self.selectedData) {
        
        NSLog(@"%@", data.name);
    }
}
//取消选中
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

    Model *model = self.dataArray[indexPath.row];

    [self.selectedData removeObject:model];
    for (Model *data in self.selectedData) {
        
        NSLog(@"%@", data.name);
    }
}

@end
