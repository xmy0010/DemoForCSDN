//
//  UITableView+EmptyData.h
//  LezhengForCompany
//
//  Created by 智美高科 on 2016/12/7.
//  Copyright © 2016年 zmgk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)


- (void)tableViewDisplayWitMsg:(NSString *) message andImageName:(NSString *)imgName ifNecessaryForRowCount:(NSUInteger) rowCount;
- (void)tableViewDisplayWitMsg:(NSString *) message andImageName:(NSString *)imgName ifNecessaryForRowCount:(NSUInteger) rowCount offsetY:(NSInteger)offsetY;
@end
