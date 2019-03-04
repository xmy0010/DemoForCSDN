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
#import "XMYIGListImageSectionController.h"

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
    section1.type = XMYSectionTypeTitle;
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
    section2.type = XMYSectionTypeTitle;
    section2.title = @"section2";
    NSArray *section2Arr = @[@"整改隐患",@"公司拜访",@"公告栏",@"安全部门",@"环保专家"];
    NSMutableArray *arr2 = @[].mutableCopy;
    for (NSString *title in section2Arr) {
        ListItemModel *model = [[ListItemModel alloc] init];
        model.title = title;
        [arr2 addObject:model];
    }
    section2.data = arr2;
    
    ListSectionModel *section3 = [[ListSectionModel alloc] init];
    section3.title = @"section3";
    section3.type = XMYSectionTypeImage;
    NSArray *section3Types = @[@0,@2,@2,@1,@1,@1];
    NSArray *titles = @[@"新款照片书",@"12寸精装对裱册",@"方款蝴蝶精装对表册",@"精品杂志册",@"超级照片书",@"硬壳精装册"];
    NSMutableArray *arr3 = @[].mutableCopy;
    for (NSString *title in titles) {
        NSInteger index = [titles indexOfObject:title];
        ImageItemModel *model = [[ImageItemModel alloc] init];
        model.title = title;
        model.detail = [title stringByAppendingString:@"简要描述"];
        model.type = [section3Types[index] integerValue];
        [arr3 addObject:model];
    }
    section3.data = arr3;
    
    self.datas = @[section1, section2, section3].mutableCopy;
    
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
    ListSectionModel *sectionModel = (ListSectionModel *)object;
    if (sectionModel.type == XMYSectionTypeImage) {
       
        return [XMYIGListImageSectionController new];
    } else {
       
        return [XMYIGListSectionController new];
    }
}



@end
