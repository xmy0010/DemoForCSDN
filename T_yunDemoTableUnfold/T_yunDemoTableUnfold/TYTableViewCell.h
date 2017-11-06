//
//  TYTableViewCell.h
//  T_yunDemoTableUnfold
//
//  Created by T_yun on 2017/11/3.
//  Copyright © 2017年 tangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYModel.h"

@interface TYTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@property (weak, nonatomic) IBOutlet UILabel *contentLB;

@property (weak, nonatomic) IBOutlet UIButton *controlBtn;

@property(nonatomic, strong) TYModel *model;

//点击回调
@property(nonatomic, copy) void(^controlBlock)(void);

@end
