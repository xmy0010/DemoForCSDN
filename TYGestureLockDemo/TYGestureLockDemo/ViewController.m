//
//  ViewController.m
//  TYGestureLockDemo
//
//  Created by T_yun on 2018/3/8.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "ViewController.h"
#import <math.h>

//四个象限
typedef NS_OPTIONS(NSInteger, TYQuadrant) {
    
    TYQuadrantFirst = 1, //第一象限
    TYQuadrantSecend,
    TYQuadrantThird,
    TYQuadrantFourth
};
//八个方向
typedef NS_OPTIONS(NSInteger, TYDirection) {
    
    TYDirectionNone = 0,     //对单点的操作
    TYDirectionLeftDown = 1, //左下
    TYDirectionLeft,
    TYDirectionLeftUp,
    TYDirectionUp,
    TYDirectionRightUp,
    TYDirectionRight,
    TYDirectionRightDown,
    TYDirectionDown
};

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *gestureLB;

//存储开始时的点
@property(nonatomic, assign) CGPoint beginPoint;
@property (weak, nonatomic) IBOutlet UIView *bgView;

//存储移动过程中的点
@property(nonatomic, strong) NSMutableArray *movePoints;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self tapGesture]; //点击
//    [self swipeGesture]; //轻扫
//    [self pinchGesture];
//    [self panGesture];
    [self rotationGesture];
    [self longPressGesture];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark Tap
- (void)tapGesture{
    
    //一个手指单击 一个手机双击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    //一个手指双击
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap2];
    
    
    //注意  此函数为 后者失败之后才会响应前者
    [tap requireGestureRecognizerToFail:tap2];
    
    //俩个手指单击
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTwoFingerTap:)];
    [self.view addGestureRecognizer:tap3];
    tap3.numberOfTouchesRequired = 2;
    //tap2 和 tap3都出现时  取消tap2
    [tap2 requireGestureRecognizerToFail:tap3];

}

//单个点击
- (void)singleTap:(UITapGestureRecognizer *)tap{
    
    _gestureLB.text = @"一个手指单击";
}

//双击
- (void)doubleTap:(UITapGestureRecognizer *)sender{
    
    _gestureLB.text = @"一个手指双击";
}

//
- (void)singleTwoFingerTap:(UITapGestureRecognizer *)sender{
    
    _gestureLB.text = @"俩个手指单击";
}

#pragma mark Swipe
//轻扫手势
- (void)swipeGesture{
    
    self.view.multipleTouchEnabled = YES;
    
    //不同方向需分开添加
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe];
    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipe1.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe1];
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipe2.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe2];
    
    UISwipeGestureRecognizer *swipe3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipe3.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipe3];
    
    UISwipeGestureRecognizer *swipe4 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipe3.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe4];
    
    swipe.cancelsTouchesInView = NO;
    swipe1.cancelsTouchesInView = NO;
    swipe2.cancelsTouchesInView = NO;
    swipe3.cancelsTouchesInView = NO;
    swipe4.cancelsTouchesInView = NO;
//
//    swipe.delaysTouchesBegan = YES;
//    swipe1.delaysTouchesBegan = YES;
//    swipe2.delaysTouchesBegan = YES;
//    swipe3.delaysTouchesBegan = YES;


//    cancelsTouchesInView：默认YES.意思就是说一旦手势被识别，那么就调用[touchView touchesCancelled:withEvent]
//    delaysTouchesBegan：默认NO.意思就是再手势识别成功之前，touchObj还是要分发到touchView.设置为YES的时候就表示从手势识别成功之前touchObj不给touchView分发
//delaysTouchesEnded:默认YES:在手势识别成功之前，touchesEnded不会被调用。设置为NO:在手势识别成功之前，touchesEnded会被调用。
    
}
-(void)swipeAction:(UISwipeGestureRecognizer *)sender{
    
    NSString *action = @"";
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionDown:
            action = @"向下轻扫";
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            action = @"向左轻扫";
            break;
        case UISwipeGestureRecognizerDirectionUp:
            action = @"向上轻扫";
            break;
        case UISwipeGestureRecognizerDirectionRight:
            action = @"向右轻扫";
            break;
    }
    NSLog(@"%@",action);

    _gestureLB.text = action;
}

#pragma mark Pich
//捏合
- (void)pinchGesture{
    
    //初始化
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self.view addGestureRecognizer:pinch];
}

-(void)pinchAction:(UIPinchGestureRecognizer *)sender{
    
    float scale = sender.scale;
    sender.view.transform = CGAffineTransformScale(sender.view.transform, scale, scale);
    if (scale > 1) {
        
        _gestureLB.text = @"放大";
    } else{
        
        _gestureLB.text = @"缩小";
    }
}

#pragma mark Pan拖动
- (void)panGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [_gestureLB addGestureRecognizer:pan];
    
}
- (void)panAction:(UIPanGestureRecognizer *)pan{
    //移动的坐标值
    CGPoint translation = [pan translationInView:self.view];
    //移动后的坐标
    pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
    
    //通过重置坐标和速度
    [pan setTranslation:CGPointZero inView:self.view];
    _gestureLB.text = @"把我放哪儿啊";
    
}

#pragma mark Rotation 旋转
- (void)rotationGesture{
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
    [_gestureLB addGestureRecognizer:rotation];
}

- (void)rotationAction:(UIRotationGestureRecognizer *)rotation{
    
    rotation.view.transform = CGAffineTransformRotate(rotation.view.transform, rotation.rotation);
    
}
#pragma mark LongPress 长按
- (void)longPressGesture{
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.view addGestureRecognizer:longPress];
}
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    
    _gestureLB.text = @"长按";
}

//
////获取起始点
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    UITouch *touch = [touches anyObject];
//
//    CGPoint touchPoint = [touch locationInView:self.view];
//
//    self.beginPoint = touchPoint;
//    NSLog(@"开始%f==%f",touchPoint.x,touchPoint.y);
//
//    //清零移动过程的点  移除所有上次绘制的点
//    _movePoints = @[].mutableCopy;
//    [self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    UITouch *touch = [touches anyObject];
//
//    CGPoint touchPoint = [touch locationInView:self.view];
//    [_movePoints addObject:[NSValue valueWithCGPoint:touchPoint]];
//
//    NSLog(@"移动%f==%f",touchPoint.x,touchPoint.y);
//}
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    UITouch *touch = [touches anyObject];
//
//    CGPoint endPoint = [touch locationInView:self.view];
//
//    NSLog(@"结束%f==%f",endPoint.x,endPoint.y);
//
//
//    //3.绘制手势经过的点
//    NSMutableArray *temp = _movePoints.mutableCopy;
//    [temp insertObject:[NSValue valueWithCGPoint:self.beginPoint] atIndex:0];
//    [temp addObject:[NSValue valueWithCGPoint:endPoint]];
//    [self drewAllPointsWithArray:temp];
//
//
//    TYDirection direction = [self getDirectionByBegin:self.beginPoint end:endPoint];
//
//    NSString *text = @"";
//    switch (direction) {
//        case TYDirectionNone:
//
//            text = @"无法识别";
//            break;
//        case TYDirectionLeftDown:
//
//            text = @"向左下滑动";
//            break;
//        case TYDirectionLeft:
//
//            text = @"向左滑动";
//            break;
//        case TYDirectionLeftUp:
//
//            text = @"向左上滑动";
//            break;
//        case TYDirectionUp:
//
//            text = @"向上滑动";
//            break;
//        case TYDirectionRightUp:
//
//            text = @"向右上滑动";
//            break;
//        case TYDirectionRight:
//
//            text = @"向右滑动";
//            break;
//        case TYDirectionRightDown:
//
//            text = @"向右下滑动";
//            break;
//        case TYDirectionDown:
//
//            text = @"向下滑动";
//            break;
//    }
//
//    _gestureLB.text = text;
//    NSLog(@"当前操作方向%d", direction);
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    NSLog(@"取消");
//}


//已起点为坐标原点建立平面直角坐标系 判断出该轻扫的方向
//分为 左、上、右、下、左下、左上、右上、右下八个方向 初步定为X轴正半轴正负10°区间为左，Y轴正半轴正负10°区间为上，其余方向以此类推。
- (TYDirection)getDirectionByBegin:(CGPoint)beginPoint end:(CGPoint)endPoint{
    

    
    
    
    //单点操作 不会响应swipe手势 初步定义俩点之前的距离小于等于1为单点操作
    double distance = sqrt((endPoint.x - beginPoint.x) * (endPoint.x - beginPoint.x) + (endPoint.y - beginPoint.y) * (endPoint.y - beginPoint.y));
    if (distance < 1) {
        
        return TYDirectionNone;
    }
    
    //正上下左右方向
    if (endPoint.x == beginPoint.x) {
        if (endPoint.y < beginPoint.y) {
           
            NSLog(@"正上方");
            return TYDirectionUp;
        }
        
        NSLog(@"正下方");
        return TYDirectionDown;
    }
    if (endPoint.y == beginPoint.y) {
        if (endPoint.x > beginPoint.x) {
            
            NSLog(@"正右方");
            return TYDirectionRight;
        }
        
        NSLog(@"正左方");
        return TYDirectionLeft;
    }
    //反正切 算出夹角
    double alpha = [self getArctanPointA:beginPoint pointB:endPoint];
    
    //先判断整个运动轨迹是否是一条线段（不能是曲线） 通过首位俩个点确定一条一元一次函数 循环经过的点 如果有任意一点不在该函数上 则说明为曲线（实际此方法不可行）
    NSLog(@"夹角%f", alpha);
    
    double maxAlpha = 90;
    double minAlpha = 0;
    //去除90°和0° 在去除一个最大值一个最小值之后 其余度数相差在10以内则默认为直线
    for (NSValue *value in _movePoints) {
        
        
        CGPoint tempPoint = [value CGPointValue];
        double tempAlpha = [self getArctanPointA:beginPoint pointB:tempPoint];
        NSLog(@"alpha == %f", tempAlpha);
        
        //去除 90°和0°  找出最大与最小之间的差距
        if (tempAlpha == 90 || tempAlpha == 0) {
            
            continue;
        }
        
        //初始值
        if (maxAlpha == 90 && minAlpha == 0) {
                
            minAlpha = tempAlpha;
            maxAlpha = tempAlpha;
        }

        if (tempAlpha > maxAlpha) {
            
            maxAlpha = tempAlpha;
        }
        if (tempAlpha < minAlpha) {
            
            minAlpha = tempAlpha;
        }
    }
    for (NSValue *value in _movePoints) {
        
        CGPoint tempPoint = [value CGPointValue];
        double tempAlpha = [self getArctanPointA:beginPoint pointB:tempPoint];
        NSLog(@"alpha == %f", tempAlpha);
        
        //去除去掉最大值和最小值之后
        if (tempAlpha == maxAlpha || tempAlpha == minAlpha) {
            
            continue;
        }
        if (tempAlpha > maxAlpha) {
            
            maxAlpha = tempAlpha;
        }
        if (tempAlpha < minAlpha) {
            
            minAlpha = tempAlpha;
        }
    }
    
    if (maxAlpha != 90 && minAlpha != 0) {
        
//        double differential = maxAlpha - minAlpha;
//        if (differential > 20) {
//            
//            //曲线
//            return TYDirectionNone;
//        }
    }
    
    
    //求平面直角坐标系某点与X轴正半轴的夹角P(a,b)
    //    第一象限：θ=arctan|b|/|a|，
    //    第二象限：θ=180°-arctan|b|/|a|，
    //    第三象限：θ=180°+arctan|b|/|a|，
    //    第四象限：θ=360°-arctan|b|/|a|，
    TYQuadrant quadrant = [self getQuadrantByBegin:beginPoint end:endPoint];

    switch (quadrant) {
        case TYQuadrantFirst:

            break;
        case TYQuadrantSecend:

            alpha = 180 - alpha;
            break;
        case TYQuadrantThird:
            
            alpha = 180 + alpha;
            break;
        case TYQuadrantFourth:

            alpha = 360 - alpha;
            break;
    }
    
    //根据之前指定的规则 -10°（350°）到10°属于右 10°到80度属于右上 以此类推
    if ((alpha <= 10 && alpha > 0)  || (alpha > 350 && alpha <= 360)) {
        
        return TYDirectionRight;
    }
    if (alpha <= 80 && alpha > 10) {
        
        return TYDirectionRightUp;
    }
    if (alpha <= 100 && alpha > 80) {
        
        return TYDirectionUp;
    }
    if (alpha <= 170 && alpha > 100) {
        
        return TYDirectionLeftUp;
    }
    if (alpha <= 190 && alpha > 170) {
        
        return TYDirectionLeft;
    }
    if (alpha <= 260 && alpha > 190) {
        
        return TYDirectionLeftDown;
    }
    if (alpha <= 280 && alpha > 160) {
        
        return TYDirectionDown;
    }
    if (alpha <= 350 && alpha > 280) {
        
        return TYDirectionRightDown;
    }
    
    //其他可能未判断到的边际条件 暂时返回无
    return TYDirectionNone;
}

//获取起点为坐标原点之后 终点所在哪个象限
- (TYQuadrant)getQuadrantByBegin:(CGPoint)beginPoint end:(CGPoint)endPoint{

    //注意平面直角坐标系和iOS屏幕Y轴正方形是相反的
    CGFloat sideA = -(endPoint.y - beginPoint.y);
    CGFloat sideB = endPoint.x - beginPoint.x;
    
    if (sideA > 0) {
        if (sideB > 0) {
            return TYQuadrantFirst;
        }
        return TYQuadrantSecend;
    }
    if (sideB > 0) {
        
        return TYQuadrantFourth;
    }
    return TYQuadrantThird;
}

//计算俩个点连线与x轴的夹角
- (double)getArctanPointA:(CGPoint)beginPoint pointB:(CGPoint)endPoint{
    
    double sideA = fabs(endPoint.y - beginPoint.y);
    double sideB = fabs(endPoint.x - beginPoint.x);
    double alpha = atan(sideA / sideB);
    alpha = alpha * 180 / M_PI;
    
    return alpha;
}

//绘制所有点
- (void)drewAllPointsWithArray:(NSMutableArray *)points{
    
    
    for (NSValue *value in points) {
        
        CGPoint center = value.CGPointValue;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        label.backgroundColor = [UIColor redColor];
        label.layer.cornerRadius = 2.5;
        label.center = center;
        [self.bgView addSubview:label];
    }
 
}

@end
