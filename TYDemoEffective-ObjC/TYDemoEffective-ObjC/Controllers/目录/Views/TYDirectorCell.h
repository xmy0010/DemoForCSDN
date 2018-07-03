//
//  TYDirectorCell.h
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/4.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYBaseCell.h"
@class TYDirectoryModel;

@interface TYDirectorCell : TYBaseCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UILabel *detailLB;

@property(nonatomic, strong)TYDirectoryModel *model;

@end
