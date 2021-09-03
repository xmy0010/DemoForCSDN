//
//  MainEntranceItemCell.m
//  UniversallyFramework
//
//  Created by lxin on 16/9/5.
//  Copyright © 2016年 liuf. All rights reserved.
//

#import "MainEntranceItemCell.h"

@interface MainEntranceItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation MainEntranceItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

    _imgView.bounds = CGRectMake(0, 0, 44, 44);
    _imgView.backgroundColor = [UIColor yellowColor];
    [_imgView.layer setCornerRadius:44 / 2.0];
    [_imgView.layer setMasksToBounds:YES];
}


- (void)setTitleName:(NSString *)name {
    self.name.text = name;
}


@end
