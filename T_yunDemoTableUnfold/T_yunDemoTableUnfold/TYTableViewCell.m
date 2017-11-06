//
//  TYTableViewCell.m
//  T_yunDemoTableUnfold
//
//  Created by T_yun on 2017/11/3.
//  Copyright © 2017年 tangyun. All rights reserved.
//

#import "TYTableViewCell.h"

@implementation TYTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(TYModel *)model{

    _model = model;
    _nameLB.text = model.name;
    _contentLB.text = model.content;
    
    _controlBtn.hidden = NO;
    switch (model.type) {
        case TYCellTypeNone:
            
            _controlBtn.hidden = YES;
            _contentLB.numberOfLines = 5;
            break;
        case TYCellTypeFold:{
        
            [_controlBtn setTitle:@"收起" forState:UIControlStateNormal];
            _contentLB.numberOfLines = 0;
        }
            break;
        case TYCellTypeUnfold:{
            
            [_controlBtn setTitle:@"展开" forState:UIControlStateNormal];
            _contentLB.numberOfLines = 5;
        }
            break;
    }
}

//点击展开 收起按钮
- (IBAction)onControlBtn:(id)sender {
    
    if (_model.type == TYCellTypeFold) {
        
        _model.type = TYCellTypeUnfold;
    } else{
    
        _model.type = TYCellTypeFold;
    }
    if (_controlBlock) {
        
        _controlBlock();
    }
    
}
@end
