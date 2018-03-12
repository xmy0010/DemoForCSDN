//
//  TYLockView.m
//  TYGestureLockDemo
//
//  Created by T_yun on 2018/3/12.
//  Copyright © 2018年 tangyun. All rights reserved.
//




#import "TYLockView.h"

//const 定义只读变量名 在其他类中不能声明同样的变量名
CGFloat const btnCount = 9;
CGFloat const btnWidth = 70;

int const columCount = 3;
#define kScreenWidth     [UIScreen mainScreen].bounds.size.width

@interface TYLockView()
@property(nonatomic, strong) NSMutableArray *selectedBtns;

@property(nonatomic, assign) CGPoint currentPoint;

@end

@implementation TYLockView

- (NSMutableArray *)selectedBtns{
    
    if (_selectedBtns == nil) {
        
        _selectedBtns = @[].mutableCopy;
    }
    return _selectedBtns;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addButtons];
    }
    return self;
}

//xib创建 sb创建
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self addButtons];
    }
    return self;
}

- (void)addButtons{
    
    CGFloat height = 0;
    for (int i = 0; i < btnCount; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = [UIColor greenColor];
        btn.layer.cornerRadius = btnWidth / 2;
        btn.userInteractionEnabled = NO;
//        [btn setBackgroundImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>]
        int row = i / columCount; //第几行
        int column = i % columCount; //第几列
        //边距
        CGFloat margin = (kScreenWidth - columCount *btnWidth) / (columCount + 1);
        //x轴
        CGFloat btnX = margin + column * (btnWidth + margin);
        //y轴
        CGFloat btnY = 50 + row * (btnWidth + margin);
        
        btn.tag = i;
        btn.frame = CGRectMake(btnX, btnY, btnWidth, btnWidth);
        height = btnWidth + btnY;
        [self addSubview:btn];
    }
    
    self.frame = CGRectMake(0, 100, kScreenWidth, height + 100);
}

#pragma Mark 私有方法
- (CGPoint)pointWithTouch:(NSSet *)touches{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    return point;
}
- (UIButton *)buttonWithPoint:(CGPoint )point{
    
    for (UIButton *btn in self.subviews) {
        //判断某点 是否在某矩形框内
        if (CGRectContainsPoint(btn.frame, point)) {
            
            return btn;
        }
    }
    return nil;
}

#pragma mark 触摸方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //1.拿到触摸的点
    CGPoint point = [self pointWithTouch:touches];
    //2.根据触摸的点拿到相应的按钮
    UIButton *btn = [self buttonWithPoint:point];
    //3.设置状态
    if (btn && ![self.selectedBtns containsObject:btn]) {
        
        btn.backgroundColor = [UIColor yellowColor];
        [self.selectedBtns addObject:btn];
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //1.拿到触摸的点
     CGPoint point = [self pointWithTouch:touches];

    //2.根据触摸的点拿到相应的按钮
    UIButton *btn = [self buttonWithPoint:point];
    //3.设置状态
    if (btn && ![self.selectedBtns containsObject:btn]) {
        
        btn.backgroundColor = [UIColor yellowColor];
        [self.selectedBtns addObject:btn];
    }else{
        self.currentPoint = point;
    }
    
    //当时图发生变化 调用
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    if (_lockFinishBlcok) {
        
        NSMutableString *path = @"".mutableCopy;
        for (UIButton *btn in self.selectedBtns) {
            
            [path appendFormat:@"%ld", btn.tag];
        }
        _lockFinishBlcok(path);
    }
    
    //清空状态
    //makeObjectsPerformSelector 像数组中的每个参数发送setBackgroundColor:方法 后面参数
    [self.selectedBtns makeObjectsPerformSelector:@selector(setBackgroundColor:)withObject:[UIColor greenColor]];
    [self.selectedBtns removeAllObjects];
    [self setNeedsDisplay];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self touchesEnded:touches withEvent:event];
}

#pragma mark 绘图

- (void)drawRect:(CGRect)rect{
    
    if (self.selectedBtns.count == 0) {
        
        return;
    }
    
    //贝塞尔曲线画
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 8;
    path.lineJoinStyle = kCGLineCapRound;
    [[UIColor colorWithRed:32 / 255. green:210 / 255. blue:254 / 255. alpha:0.5] set];
    for (int i = 0; i < self.selectedBtns.count; i++) {
        
        UIButton *btn = self.selectedBtns[i];
        if (i == 0) {
            [path moveToPoint:btn.center]; //起点
        } else{
            [path addLineToPoint:btn.center];//连线
        }
        
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
