//
//  ListSectionModel.h
//  T_yunIGListKit
//
//  Created by T_yun on 2019/1/9.
//  Copyright © 2019年 tangyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListDiffable.h>


NS_ASSUME_NONNULL_BEGIN

@interface ListItemModel : NSObject <IGListDiffable>

@property (nonatomic, copy) NSString *title;

@end

@interface ListSectionModel : NSObject <IGListDiffable>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray <ListItemModel *> *data;

@end

NS_ASSUME_NONNULL_END
