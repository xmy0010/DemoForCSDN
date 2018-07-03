//
//  UICollectionView+TYEmptyData.h
//  zmgk_LeZheng
//
//  Created by T_yun on 2017/6/15.
//  Copyright © 2017年 zmgk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (TYEmptyData)

- (void)collectionViewDisplayWitMsg:(NSString *) message andImageName:(NSString *)imgName ifNecessaryForRowCount:(NSUInteger) rowCount;


@end
