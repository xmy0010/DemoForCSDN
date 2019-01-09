//
//  ListSectionModel.m
//  T_yunIGListKit
//
//  Created by T_yun on 2019/1/9.
//  Copyright © 2019年 tangyun. All rights reserved.
//

#import "ListSectionModel.h"

@implementation ListItemModel

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    ListItemModel *model = (ListItemModel *)object;
    return self.title == model.title;
}

@end

@implementation ListSectionModel

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    ListSectionModel *model = (ListSectionModel *)object;
    __block BOOL isEqual = YES;
    isEqual = self.title == model.title && self.data.count == model.data.count;
    if (isEqual) {
        [self.data enumerateObjectsUsingBlock:^(ListItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            isEqual = [obj isEqualToDiffableObject:model.data[idx]];
            if (!isEqual) {
                *stop = YES;
            }
        }];
    }
    
    return isEqual;
}

@end
