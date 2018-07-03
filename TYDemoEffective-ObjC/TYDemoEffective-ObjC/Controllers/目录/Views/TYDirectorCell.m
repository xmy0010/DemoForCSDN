//
//  TYDirectorCell.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/4.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYDirectorCell.h"
#import "TYDirectoryModel.h"


@implementation TYDirectorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TYDirectoryModel *)model{
    
    _model = model;
    
    self.titleLB.text = model.title;
    self.detailLB.text = model.detail;
}

@end
