//
//  MainEntranceCellLayout.h
//  UniversalProject
//
//  Created by zwzh_14 on 2021/8/26.
//  Copyright © 2021 OMT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainEntranceCellLayout : UICollectionViewFlowLayout



/** 单页行数(若未设置默认为4) */
@property (assign, nonatomic) NSInteger  rowCount;
/** 单页列数(若未设置默认为2)   */
@property (assign, nonatomic) NSInteger  columnCount;

@end

NS_ASSUME_NONNULL_END
