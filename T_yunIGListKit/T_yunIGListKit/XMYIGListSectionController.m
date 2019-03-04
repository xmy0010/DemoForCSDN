//
//  IGListSectionController.m
//  T_yunIGListKit
//
//  Created by T_yun on 2019/1/9.
//  Copyright © 2019年 tangyun. All rights reserved.
//

#import "XMYIGListSectionController.h"
#import "ListSectionModel.h"
#import "LWorkTableButtonCell.h"
#import "LWorkTableCommonHeader.h"


@interface XMYIGListSectionController ()<IGListSupplementaryViewSource>

@property (nonatomic, strong) ListSectionModel *model;

@end

@implementation XMYIGListSectionController

- (instancetype)init {
    if (self = [super init]) {
        self.supplementaryViewSource = self;
        self.minimumLineSpacing = 5;
        self.minimumInteritemSpacing = 5;
    }
    return self;
}

- (NSInteger)numberOfItems {
   
    return self.model.data.count;
}
- (NSArray<NSString *> *)supportedElementKinds {
    return @[UICollectionElementKindSectionHeader];
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width / 4 - 1, 100);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    LWorkTableButtonCell *cell = [self.collectionContext dequeueReusableCellOfClass:[LWorkTableButtonCell class] forSectionController:self atIndex:index];
    ListItemModel *model = self.model.data[index];
    [cell.button setTitle:model.title forState:UIControlStateNormal];
    
    return cell;
}

- (void)didUpdateToObject:(id)object {
    _model = object;
}

- (UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind atIndex:(NSInteger)index {
  
    LWorkTableCommonHeader *header = [self.collectionContext dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader forSectionController:self nibName:@"LWorkTableCommonHeader" bundle:nil atIndex:index];
    header.title.text = self.model.title;
    return header;
}

- (CGSize)sizeForSupplementaryViewOfKind:(nonnull NSString *)elementKind atIndex:(NSInteger)index {
    CGSize result = CGSizeMake(self.collectionContext.containerSize.width, 40);
    return result;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%ld", index);
}

@end
