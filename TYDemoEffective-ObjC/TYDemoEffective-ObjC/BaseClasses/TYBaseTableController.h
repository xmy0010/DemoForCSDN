//
//  TYBaseTableController.h
//  zmgk_LeZheng
//
//  Created by T_yun on 2017/5/3.
//  Copyright © 2017年 zmgk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYBaseTableController : UITableViewController

//cell线条铺满
@property (nonatomic, assign) BOOL fullLine;

//section header是否 禁止悬浮
@property(nonatomic, assign) BOOL forbidSectionFlow;

//默认返回
- (void)defaultLeftItemPressed;

//弹窗提示信息
- (void)showTip:(NSString *)message;



@end
