//
//  MainEntranceCellLayout.m
//  UniversalProject
//
//  Created by zwzh_14 on 2021/8/26.
//  Copyright © 2021 OMT. All rights reserved.
//

#import "MainEntranceCellLayout.h"

@interface MainEntranceCellLayout ()

@property (strong, nonatomic) NSMutableArray<UICollectionViewLayoutAttributes *>  *layoutAttributes;

@end

@implementation MainEntranceCellLayout

#pragma mark - Layout
// 布局前准备
- (void)prepareLayout {
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    // 获取所有布局
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexpath];
        [self.layoutAttributes addObject:attr];
    }
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger item = indexPath.item;
    // 总页数
    NSInteger pageNumber = item / (self.rowCount * self.columnCount);
    // 该页中item的序号
    NSInteger itemInPage = item % (self.rowCount * self.columnCount);
    // item的所在列、行
    NSInteger col = itemInPage % self.columnCount;
    NSInteger row = itemInPage / self.columnCount;
    
    CGFloat x = self.sectionInset.left + (self.itemSize.width + self.minimumInteritemSpacing)*col + pageNumber * self.collectionView.bounds.size.width;
    CGFloat y = self.sectionInset.top + (self.itemSize.height + self.minimumLineSpacing)*row ;
    
    attri.frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
    
    return attri;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.layoutAttributes;
}

- (CGSize)collectionViewContentSize {
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger pageNumber = itemCount / (self.rowCount * self.columnCount);
    if (itemCount%(self.rowCount * self.columnCount)) {
        pageNumber += 1;
    }
    return CGSizeMake(pageNumber * self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

#pragma mark - Getter
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)layoutAttributes {
    if (_layoutAttributes == nil) {
        _layoutAttributes = [NSMutableArray array];
    }
    return _layoutAttributes;
}

//默认2行
- (NSInteger)rowCount {
    if (_rowCount == 0) {

        return 2;
    }
    return _rowCount;
}
//默认4列
- (NSInteger)columnCount {
    if (_columnCount == 0) {

        return 4;
    }
    return _columnCount;
}

@end
