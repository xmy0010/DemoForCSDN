//
//  ViewController.m
//  T_yunCollectionLayout
//
//  Created by T_yun on 2019/3/5.
//  Copyright © 2019年 T_yun. All rights reserved.
//

#import "ViewController.h"
#import "MainEntranceCellLayout.h"
#import "MainEntranceItemCell.h"

#define CellIdentifier @"MainEntranceItemCell"
#define MainEntranceItemHeight 75

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) MainEntranceCellLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initCollectionView];
}


- (void)initCollectionView {

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.layout =[[MainEntranceCellLayout alloc] init];
    [self setCollectionViewFlowLayout];
    self.collectionView.collectionViewLayout = _layout;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
}

- (UICollectionViewFlowLayout *)setCollectionViewFlowLayout
{
    CGFloat itemHeight = MainEntranceItemHeight;
    _layout.columnCount = 5;
    _layout.rowCount = 3;
    ///注意此处itemSize的宽根据每列有多少个item计算得出
    _layout.itemSize = CGSizeMake(SCREEN_WIDTH /5.0, itemHeight);
    _layout.footerReferenceSize  = CGSizeMake(0.1, 0.1);
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.sectionInset            = UIEdgeInsetsMake(0.1, 0.1, 0.1, 0.1);
    _layout.minimumInteritemSpacing = 0.1;
    _layout.minimumLineSpacing      = 10;
    
    
    return _layout;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 22;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainEntranceItemCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                        forIndexPath:indexPath];
    [cell setTitleName:[NSString stringWithFormat:@"第%ld个",indexPath.row]];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"点击了第%ld个",indexPath.row);
}


@end
