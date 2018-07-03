//
//  UICollectionView+TYEmptyData.m
//  zmgk_LeZheng
//
//  Created by T_yun on 2017/6/15.
//  Copyright © 2017年 zmgk. All rights reserved.
//

#import "UICollectionView+TYEmptyData.h"

@implementation UICollectionView (TYEmptyData)

- (void)collectionViewDisplayWitMsg:(NSString *)message andImageName:(NSString *)imgName ifNecessaryForRowCount:(NSUInteger)rowCount{
//
//    float width = self.bounds.size.width;
//    float height = self.bounds.size.height;
//    UIView *backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    
//    //    backgroundview.backgroundColor = [UIColor_Hex colorWithHexString:@"f2f0ec"];
//    //    UIImageView *centerview = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-125, height/2-125, 250, 250)];
//    //    centerview.image = [UIImage imageNamed:@"list_back_1"];
//    //    [backgroundview addSubview:centerview];
//    //    UIImageView *boomview = [[UIImageView alloc]initWithFrame:CGRectMake(0, height-80, width, 80)];
//    //    boomview.image = [UIImage imageNamed:@"list_back_2"];
//    //    [backgroundview addSubview:boomview];
//    if (rowCount == 0) {
//        // 没有数据的时候，UILabel的显示样式
//        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-150, height/2-200, 300,300)];
//        imageview.image = [UIImage imageNamed:imgName];
//        [backgroundview addSubview:imageview];
//        imageview.contentMode = UIViewContentModeCenter;
//        UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, height/2+25, width-30 , 20)];
//        messageLabel.text = message;
//        messageLabel.font = [UIFont systemFontOfSize:16];
//        messageLabel.textColor = HexRGB(0xcccccc);
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        [backgroundview addSubview:messageLabel];
//        
//        self.backgroundView = backgroundview;
//    } else {
//        // 有数据的时候，
//        self.backgroundView = backgroundview;
//        //        [self.bgView removeFromSuperview];
//    }
}

@end
