//
//  XMYIGListImageSectionController.m
//  T_yunIGListKit
//
//  Created by T_yun on 2019/3/1.
//  Copyright © 2019年 tangyun. All rights reserved.
//

#import "XMYIGListImageSectionController.h"
#import "LWorkTableCommonHeader.h"
#import "ListSectionModel.h"
#import "XMYImageCell_ square.h"
#import "XMYImageCell_ rectangle.h"

@interface XMYIGListImageSectionController ()<IGListSupplementaryViewSource>
@property (nonatomic, strong) ListSectionModel *model;

@end

@implementation XMYIGListImageSectionController


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
    
    ImageItemModel *model = self.model.data[index];
    if (model.type == XMYImageItemTypeSquareBig) {
       
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 2 - 10;
        return CGSizeMake(width, width);
    } else if (model.type == XMYImageItemTypeSquareSmall) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 3 - 10;
        return CGSizeMake(width, width);
    } else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 10;

        return CGSizeMake(width, width / 2);
    }
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    
    ImageItemModel *model = self.model.data[index];
    if (model.type == XMYImageItemTypeSquareRectangle) {
        
        XMYImageCell__rectangle *cell = [self.collectionContext dequeueReusableCellOfClass:[XMYImageCell__rectangle class] forSectionController:self atIndex:index];
        cell.titleLb.text = model.title;
        cell.detailLb.text = model.detail;
        cell.backgroundColor = [UIColor redColor];
        return cell;
    } else {
        XMYImageCell__square *cell = [self.collectionContext dequeueReusableCellOfClass:[XMYImageCell__square class] forSectionController:self atIndex:index];
        cell.titleLb.text = model.title;
        cell.detailLb.text = model.detail;
        cell.backgroundColor = [UIColor blueColor];
        return cell;
    }
    
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
