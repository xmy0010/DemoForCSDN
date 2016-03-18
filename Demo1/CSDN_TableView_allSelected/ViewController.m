//
//  ViewController.m
//  CSDN_TableView_allSelected
//
//  Created by T_yun on 16/3/18.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;


@property (nonatomic, assign) BOOL isAllSelected;

@end

@implementation ViewController

- (NSArray *)dataArray {

    if (_dataArray == nil) {
        
        _dataArray = @[@"Mars",
                       @"gogoing",
                       @"TableView",
                       @"runtime",
                       @"blackMagic",
                       @"CSDN",
                       @"This",
                       @"Swift"];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"多选cellDemo";
    
    [self customTableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selecteAllCells:)];
    
}


#pragma mark Actions
- (void)selecteAllCells:(UIBarButtonItem *)sender {
    if (_isAllSelected == NO) {
        
        _isAllSelected = YES;
        [sender setTitle:@"取消"];
        
        for (int i = 0; i < self.dataArray.count; i++) {

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    } else {
        
        _isAllSelected = NO;
        [sender setTitle:@"全选"];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    
    return cell;
}

#pragma mark <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSArray *subviews = cell.subviews;
}


@end
