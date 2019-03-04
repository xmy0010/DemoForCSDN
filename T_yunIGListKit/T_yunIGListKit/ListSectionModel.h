//
//  ListSectionModel.h
//  T_yunIGListKit
//
//  Created by T_yun on 2019/1/9.
//  Copyright © 2019年 tangyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListDiffable.h>

//NS_OPTIONS(NSUInteger, XMYSectionType){
//    XMYSectionTypeImage,
//    XMYSectionTypeTitle
//};
//NS_OPTIONS(NSUInteger, XMYImageItemType){
//    XMYImageItemTypeSquareBig = 0,
//    XMYImageItemTypeSquareSmall,
//    XMYImageItemTypeSquareRectangle
//};

typedef enum:NSUInteger {
    XMYSectionTypeImage,
    XMYSectionTypeTitle
} XMYSectionType;

typedef enum: NSUInteger {
    XMYImageItemTypeSquareBig = 0,
    XMYImageItemTypeSquareSmall,
    XMYImageItemTypeSquareRectangle
} XMYImageItemType;

NS_ASSUME_NONNULL_BEGIN

@interface ListItemModel : NSObject <IGListDiffable>

@property (nonatomic, copy) NSString *title;

@end

@interface ImageItemModel : NSObject <IGListDiffable>

@property (nonatomic, assign)  XMYImageItemType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *imageUrl;


@end


@interface ListSectionModel : NSObject <IGListDiffable>

@property (nonatomic, assign)  XMYSectionType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray  *data;


@end

NS_ASSUME_NONNULL_END
