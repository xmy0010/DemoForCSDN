//
// Created by 鲁成龙 on 2018-12-29.
// Copyright (c) 2018 Catnip. All rights reserved.
//

#import "LWorkTableButtonCell.h"

@implementation LWorkTableButtonCell

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]){
		[self configSubview];
	}
	return self;
}

- (void)configSubview{
	UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
	button.titleLabel.font = [UIFont systemFontOfSize:14];
	button.userInteractionEnabled = NO;
	[self.contentView addSubview:button];
	self.button = button;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.button.frame = self.contentView.bounds;
}

@end
