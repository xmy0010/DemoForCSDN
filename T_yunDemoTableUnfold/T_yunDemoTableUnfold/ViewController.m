//
//  ViewController.m
//  T_yunDemoTableUnfold
//
//  Created by T_yun on 2017/11/3.
//  Copyright © 2017年 tangyun. All rights reserved.
//

#import "ViewController.h"
#import "TYModel.h"
#import "TYTableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initUI];
    NSString *baseContent = @"Do any additional setup after loading the view, typically from a nib, Do any additional setup after loading the view, typically from a nib";
    _dataArray = @[].mutableCopy;
    for (int index = 0; index < 10; index++) {
        
        int random = arc4random() % 5 + 1;
        NSString *name = [NSString stringWithFormat:@"name %d", index];
        NSMutableString *content = @"".mutableCopy;
        int i = 0;
        while (i < random) {
            
            i++;
            [content appendString:baseContent];
        }
        
        TYModel *model = [[TYModel alloc] initWithName:name content:content];
        [_dataArray addObject:model];
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI
- (void)initUI{

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}


#pragma mark TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    TYModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"Cell";
    TYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[TYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.model = _dataArray[indexPath.row];
    cell.controlBlock = ^(){
    
        [self.tableView reloadData];
    };
    
    
    return cell;
}


@end
