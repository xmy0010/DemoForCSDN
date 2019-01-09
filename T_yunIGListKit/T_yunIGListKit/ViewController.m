//
//  ViewController.m
//  T_yunIGListKit
//
//  Created by T_yun on 2019/1/9.
//  Copyright © 2019年 tangyun. All rights reserved.
//

#import "ViewController.h"
#import <IGListKit.h>
#import "ListSectionModel.h"
#import "XMYIGListSectionController.h"

@interface ViewController ()<IGListAdapterDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSMutableArray *datas;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ListSectionModel *section1 = [[ListSectionModel alloc] init];
    section1.title = @"section1";
    NSArray *section1Arr = @[@"上报隐患",@"现场签到",@"公告栏"];
    NSMutableArray *arr1 = @[].mutableCopy;
    for (NSString *title in section1Arr) {
        ListItemModel *model = [[ListItemModel alloc] init];
        model.title = title;
        [arr1 addObject:model];
    }
    section1.data = arr1;
    
    ListSectionModel *section2 = [[ListSectionModel alloc] init];
    section2.title = @"section2";
    NSArray *section2Arr = @[@"整改隐患",@"公司拜访",@"公告栏",@"安全部门",@"环保专家"];
    NSMutableArray *arr2 = @[].mutableCopy;
    for (NSString *title in section2Arr) {
        ListItemModel *model = [[ListItemModel alloc] init];
        model.title = title;
        [arr2 addObject:model];
    }
    section2.data = arr2;
    
    self.datas = @[section1, section2].mutableCopy;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    IGListAdapterUpdater *updater = [[IGListAdapterUpdater alloc] init];
    _adapter = [[IGListAdapter alloc] initWithUpdater:updater viewController:self workingRangeSize:0];
    _adapter.collectionView = self.collectionView;
    _adapter.dataSource = self;
    [self.view addSubview:self.collectionView];
    

}


#pragma mark IGListAdapterDataSource
- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    //没有数据时候的view
    UILabel *label = [UILabel new];
    label.text = @"没有数据";
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.datas;
}

-(IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    
    return [XMYIGListSectionController new];
}



@end
