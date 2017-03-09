//
//  MYAnimationView.m
//  TyunStackDemos
//
//  Created by T_yun on 2017/1/12.
//  Copyright © 2017年 优谱德. All rights reserved.
//

#import "MYAnimationView.h"
#import "AnimOperation.h"

@interface MYAnimationView () <CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, assign) CGFloat originY;

@property (nonatomic, assign) CGFloat imageWidth;

@property (nonatomic, assign) BOOL isDrawed;


//用来循环记录 八个动画
@property (nonatomic, assign) NSInteger animationCount;

//计数次数
@property (nonatomic, assign) NSInteger numberCount;

//并行队列
@property (nonatomic, strong) NSOperationQueue *myQueue;

@end

@implementation MYAnimationView

- (instancetype)initWithOriginY:(CGFloat)originY imageWidth:(CGFloat)imageWidth{

 
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if (self = [super initWithFrame:CGRectMake(-imageWidth, 0, screenWidth + imageWidth, screenHeight)]) {
        
        //初始赋值
        self.animationDuration = 0.15;
        self.animationCount = 0;
        self.imageName = @"1";
        
        self.originY = originY;
        self.imageWidth = imageWidth;
     }

    return self;
}

- (NSOperationQueue *)myQueue {

    if (_myQueue == nil) {
        
        _myQueue = [[NSOperationQueue alloc] init];
        _myQueue.maxConcurrentOperationCount = 1;
    }
    
    return _myQueue;
}

//只能执行一次
- (void)drawView{
    
    if (_isDrawed) {
        
        return;
    }
    _isDrawed = YES;

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat originY = self.originY;
    CGFloat imageWidth = self.imageWidth;
    //算法
    //贝塞尔公式
    //    CGFloat kScale = (kScreenWidth / 320);
    CGPoint point0 = CGPointMake(0, originY);
    CGPoint point1 = CGPointMake(screenWidth / 2 - 10, originY - 100);
    CGPoint point2 = CGPointMake(screenWidth + imageWidth, originY - 100);
    //iOS坐标系与平面直角坐标系Y轴相反  取point0为平面直角坐标系原点重新构造
    CGPoint rcsPoint0 = CGPointMake(0, 0); //Rectangular coordinate system
    CGPoint rcsPoint1 = CGPointMake(point1.x, point0.y - point1.y);
    CGPoint rcsPoint2 = CGPointMake(point2.x, point0.y - point2.y);
    //二次贝塞尔
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point0];
    [path addQuadCurveToPoint:point2 controlPoint:point1];
    
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.position = CGPointMake(0, 0);
    pathLayer.lineWidth = 2;
    pathLayer.strokeColor = [UIColor greenColor].CGColor;
    pathLayer.fillColor = nil;
    pathLayer.path = path.CGPath;
    [self.layer addSublayer:pathLayer];
    
    //减去圆角
    UIImageView *firstImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, point0.y - imageWidth / 2, imageWidth, imageWidth)];
    CGFloat offsetY = [self getYWithX:imageWidth / 2 point0:rcsPoint0 point1:rcsPoint1 point2:rcsPoint2];
    firstImage.center = CGPointMake(imageWidth / 2, point0.y - offsetY);
    
    
    //添加前五个圆 一个隐藏在最前面
    self.imagesArray = @[].mutableCopy;
    for (CGFloat i = 0; i < 5; i++) {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth * i, point0.y - offsetY, imageWidth, imageWidth)];
        //x相邻算上高度差 缝隙太大 后面减一个i
        CGFloat centerX = (imageWidth) * i + imageWidth / 2 - i;
        CGFloat offsetY = [self getYWithX:centerX point0:rcsPoint0 point1:rcsPoint1 point2:rcsPoint2];
        imageView1.center = CGPointMake(centerX, point0.y - offsetY);
        imageView1.contentMode = UIViewContentModeScaleAspectFill;
        imageView1.layer.cornerRadius = 20;
        imageView1.layer.masksToBounds = YES;
        imageView1.image = [UIImage imageNamed:@"1"];
        [self addSubview:imageView1];
        [self.imagesArray addObject:imageView1];
    }
    //添加后面四个圆
    UIImageView *lastView = [[UIImageView alloc] initWithFrame:CGRectMake(point2.x, point2.y - imageWidth / 2, imageWidth, imageWidth)];
    CGFloat lastOffsetY = [self getYWithX:point2.x + imageWidth / 2 point0:point0 point1:point1 point2:point2];
    lastView.center = CGPointMake(point2.x - imageWidth / 2,point0.y - lastOffsetY);
    for (int i = 0; i < 4; i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(point2.x, point2.y - imageWidth / 2, imageWidth, imageWidth)];
        CGFloat centerX = point2.x + (imageWidth / 2) - i * imageWidth - 0.5 * i; //加0.5的缝隙
        if (i != 0) {
            
            CGFloat offsetY = [self getYWithX:centerX point0:rcsPoint0 point1:rcsPoint1 point2:rcsPoint2];
            image.center = CGPointMake(centerX, point0.y - offsetY);
        }
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.layer.cornerRadius = 20;
        image.layer.masksToBounds = YES;
        image.image = [UIImage imageNamed:@"1"];
        [self addSubview:image];
        [self.imagesArray insertObject:image atIndex:5];//后四个按X坐标大小顺序
    }
    
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen)];
    [self addGestureRecognizer:tap];
    
    //添加滑动事件(右滑)
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;  //向右滑动
    [self addGestureRecognizer:swipe];

    //添加左滑事件
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft; // 向左滑动
    [self addGestureRecognizer:swipeLeft];
}

//算出曲线上x坐标对应的Y
- (CGFloat)getYWithX:(CGFloat)X point0:(CGPoint)point0 point1:(CGPoint)point1 point2:(CGPoint)point2 {
    
    //B(t) = (1-t^2)*P0 + 2t(1-t)*P1 + t^2*P2
    //Bx = t^2(P2x - P0x - 2P1x) + 2tP1x + P0x
    //解二元一次方程
    CGFloat a, b, c, delt, x1 , x2, t, resultY;
    a = point2.x - point0.x - 2*point1.x; //二次系数
    b = 2 * point1.x; //一次系数
    c = point0.x - X; //0次系数
    
    //当二次系数为0的时候
    if (a == 0) {
        
        t = (X - point0.x) / (2 * point1.x);
        resultY = 2 * t * point1.y + point0.x;
        
        return resultY;
    } else {
        
        delt = b * b - 4 * a * c;
        x1 = (-b + sqrt(delt)) / (2 * a);
        x2 = (-b - sqrt(delt)) / (2 * a);
        
        t = x1 > 0 && x1 < 1 ? x1 : x2; //根的取值范围应在【0，1】
        resultY = (t * t) * (point2.y - point0.y - 2 * point1.y) + 2 * t * point1.y + point0.y;
        
        return resultY;
    }
    
}


//点击屏幕和右滑
- (void)tapScreen {

    //计数回调
    if (self.countBlock) {
        
        self.countBlock(YES);
    }
    AnimOperation *op = [AnimOperation animOperationWithView:self isLeft:NO finishedBlock:^(BOOL result) {
        
    }];
    
    [self.myQueue addOperation:op];
//    [self addAnimations];
}

//左滑
- (void)swipeToLeft {

    //计数回调
    if (self.countBlock) {
        
        self.countBlock(NO);
    }
    AnimOperation *op = [AnimOperation animOperationWithView:self isLeft:YES finishedBlock:^(BOOL result) {
        
    }];
    
    [self.myQueue addOperation:op];
}

- (void)addAnimationsIsLeft:(BOOL)isLeft {
    
    NSArray *tempArr = @[];
    if (!isLeft) {
        
        tempArr = self.imagesArray.copy;
    } else {
    
        tempArr= [[self.imagesArray reverseObjectEnumerator] allObjects];
    }
    
    for (int index = 0; index < tempArr.count - 1; index++) {
        
        UIImageView *frontImage = tempArr[index];
        UIImageView *backImage = tempArr[index + 1];
        CGPoint point0 = frontImage.center;
        CGPoint point2 = backImage.center;
        CGPoint point1 = CGPointMake((point2.x - point0.x) / 2 - 5 + point0.x, point2.y);
//        NSLog(@"从%f到%f", point0.x, point2.x);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:point0];
        [path addQuadCurveToPoint:point2 controlPoint:point1];
        
        //关键帧动画
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.delegate = self;
        moveAnim.path = path.CGPath;
        moveAnim.duration = self.animationDuration;
        //    moveAnim.calculationMode = kCAAnimationCubic;
        moveAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        moveAnim.fillMode = kCAFillModeForwards;
        moveAnim.removedOnCompletion = YES;
        [frontImage.layer addAnimation:moveAnim forKey:nil];
    }
    
}
- (void)animateWithCompleteBlock:(completeBlock)completed isLeft:(BOOL)isLeft {

    [self addAnimationsIsLeft:isLeft];
    self.completeBlock = completed;
 
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    if (++self.animationCount % 8 == 0) {
        
        self.animationCount = 0;
        if (self.completeBlock) {
            self.completeBlock(YES);
        }
    }

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
