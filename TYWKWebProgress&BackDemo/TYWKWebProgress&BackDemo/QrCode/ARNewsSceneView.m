//
//  ARNewsSceneView.m
//  UniversalQRCode
//
//  Created by lxin on 2019/1/16.
//  Copyright © 2019 OMT. All rights reserved.
//

#import "ARNewsSceneView.h"
#import <CoreMotion/CoreMotion.h>
#import <GLKit/GLKit.h>

// 弱引用self
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
@interface ARNewsSceneView() {
    int _index;
    dispatch_source_t _timer;
}

@property (nonatomic, strong, readwrite) SCNNode *cameraNode;

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation ARNewsSceneView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initCamera];
    return self;
}

- (void)initCamera {
    SCNScene *scene = [SCNScene scene];
    self.scene = scene;
    self.cameraNode = [SCNNode node];
    self.cameraNode.camera = [SCNCamera camera];
    self.cameraNode.camera.zNear = 10;
    self.cameraNode.camera.zFar = 50000;
    if (@available(iOS 11.0, *)) {
        self.cameraNode.camera.fieldOfView = 56;
    }
    self.cameraNode.position = SCNVector3Make(0, 0, 0);
    [self.scene.rootNode addChildNode:self.cameraNode];
    self.backgroundColor = UIColor.clearColor;
    
    self.motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.gyroAvailable) {
        self.motionManager.gyroUpdateInterval = 0.2;
        WS(weakSelf);
        [self.motionManager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [weakSelf.motionManager stopGyroUpdates];
                    NSLog(@"获取陀螺仪数据出现错误: %@", error);
                } else {
                    [weakSelf.cameraNode setOrientation:[weakSelf orientationFromCMQuaternion:motion.attitude.quaternion]];
                }
            });
        }];
    } else {
        NSLog(@"当前设备不支持陀螺仪！");
    }
}

- (SCNQuaternion)orientationFromCMQuaternion:(CMQuaternion)q {
    GLKQuaternion gq1 = GLKQuaternionMakeWithAngleAndAxis(GLKMathDegreesToRadians(-90), 1, 0, 0);
    GLKQuaternion gq2 = GLKQuaternionMake(q.x, q.y, q.z, q.w);
    GLKQuaternion qp  = GLKQuaternionMultiply(gq1, gq2);
    return SCNVector4Make(qp.x, qp.y, qp.z, qp.w);
}

//- (void)addNode:(NSString *)title imgUrl:(NSString *)imgUrl isVideo:(BOOL)isVideo jump:(nonnull JumpModel *)jump {
//    int y = 0;
//
//    int n = 10;
//    int N = 3 * n;
//    CGFloat R = 550+rand() % 200 - 100;
//
//    if (_index >= N) {
//        return;
//    }
//
//    CGFloat angle = 360 / n * M_PI / 180.0;
//    CGFloat start = (_index%n) * angle - 90 * M_PI / 180.;
//    CGFloat end = start + angle;
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:R startAngle:start endAngle:end clockwise:YES];
//    CGPoint point = CGPointMake(path.currentPoint.x+rand() % 200 - 100, path.currentPoint.y+rand() % 200 - 100);
//    CGFloat a = [self getAnglesWithThreePoint:CGPointMake(0, R) pointB:CGPointMake(0, 0) pointC:point];
//    if ((_index%n) >= n / 2) {
//        a = M_PI - a;
//    } else {
//        a = a - M_PI;
//    }
//
//    CGFloat c = 0;
//    int section = _index / n;
//    switch (section) {
//        case 0: {
//            y = rand() % 100 - 50;
//            c = 0;
//        } break;
//        case 1: {
//            y = 250+rand() % 100 - 50;
////            c = M_PI_4 / 2;
//        } break;
//        case 2: {
//            y = -250+rand() % 100 - 50;
////            c = -M_PI_4 / 2;
//        } break;
////        case 3: {
////            y = 400+rand() % 100 - 50;
////            c = M_PI_4 / 2;
////        } break;
////        case 4: {
////            y = -400+rand() % 100 - 50;
////            c = -M_PI_4 / 2;
////        } break;
//    }
//
//    _index ++;
//
//    SCNBox *box = [SCNBox boxWithWidth:120 height:90 length:10 chamferRadius:1];
//    ARNewsSceneNode *boxNode =[ARNewsSceneNode node];
//    boxNode.jump = jump;
//    boxNode.position = SCNVector3Make(point.x, y, point.y);
//    boxNode.eulerAngles = SCNVector3Make(c, a, 0);
//    boxNode.geometry = box;
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];
//    view.backgroundColor = [UIColor whiteColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 116, 26)];
//    [label setText:title];
//    [label setFont:[UIFont systemFontOfSize:10.f]];
//    [label setTextAlignment:NSTextAlignmentCenter];
////    [label setTextColor:COLOR_WITH_RGB(42, 46, 51, 1)];
//    [label setTextColor:C_Color(C_TextTitleColor)];
//    [label setNumberOfLines:2];
//    label.backgroundColor = [UIColor whiteColor];
//    [view addSubview:label];
//    AutoZoomImageView *imgView = [[AutoZoomImageView alloc] initWithFrame:CGRectMake(2, 30, 116, 58)];
//    [imgView setType:AutoZoomImageClip];
//
//    if (isVideo) {
//        UIImageView *videoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        [videoIcon setCenter:CGPointMake(116/2., 58/2.)];
//        [videoIcon setImage:[UIImage imageNamed:@"ar_news_videoPlay.png"]];
//        [imgView addSubview:videoIcon];
//    }
//
//    [view addSubview:imgView];
//    SCNMaterial *content = [[SCNMaterial alloc] init];
//    content.diffuse.contents = view;
//
//    SCNMaterial *place = [[SCNMaterial alloc] init];
//    place.diffuse.contents = [UIImage imageNamed:@"ar_news_bg_1.png"];
//    SCNMaterial *place1 = [[SCNMaterial alloc] init];
//    place1.diffuse.contents = [UIImage imageNamed:@"ar_news_bg_2.png"];
////
////    if (@available(iOS 8.0, *)) {
////        if (@available(iOS 11.0, *)) {
////            [imgView setImageUrl:imgUrl placeHolderImage:nil];
////            boxNode.geometry.materials = @[content, place, place, place, place, place];
////            [self.scene.rootNode addChildNode:boxNode];
////
////            [self startAnimation:boxNode];
////        } else {
//            [imgView setImageUrl:imgUrl placeHolderImage:nil progress:nil transform:nil completion:^(UIImage *image, NSError *error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
////                    UIGraphicsBeginImageContextWithOptions(view.bounds.size,view.opaque, 0.0f);
////                    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//                    UIGraphicsBeginImageContextWithOptions(view.size, NO, [UIScreen mainScreen].scale);
//                    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//                    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//                    UIGraphicsEndImageContext();
//
//                    content.diffuse.contents = image;
//                    boxNode.geometry.materials = @[content, place1, place, place1, place1, place1];
//
//                    [self.scene.rootNode addChildNode:boxNode];
//                    [boxNode startAnimation];
//                });
//            }];
////        }
////    }
//}

- (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA pointB:(CGPoint)pointB pointC:(CGPoint)pointC {
    CGFloat x1 = pointA.x - pointB.x;
    CGFloat y1 = pointA.y - pointB.y;
    CGFloat x2 = pointC.x - pointB.x;
    CGFloat y2 = pointC.y - pointB.y;
    
    CGFloat x = x1 * x2 + y1 * y2;
    CGFloat y = x1 * y2 - x2 * y1;
    
    CGFloat angle = acos(x/sqrt(x*x+y*y));
    
    return angle;
}

- (void)addNodeDone {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startRandomRotateTimer];
    });
}

#pragma mark - 随机旋转动画
- (void)randomRotateAnimation {
    if (self.scene.rootNode.childNodes.count <= 4) { // 摄像头Node+新闻Node小于5个时，不进行随机旋转
        return;
    }
    NSInteger randomIndex1 = arc4random() % (self.scene.rootNode.childNodes.count-1);
    NSInteger randomIndex2 = 0;
    do {
        randomIndex2 = arc4random() % (self.scene.rootNode.childNodes.count-1);
    } while (randomIndex1 == randomIndex2);
    
    SCNNode *node1 = self.scene.rootNode.childNodes[randomIndex1];
    SCNNode *node2 = self.scene.rootNode.childNodes[randomIndex2];
    if ([node1 isKindOfClass:[ARNewsSceneNode class]]) {
        [(ARNewsSceneNode *)node1 startRotateAnimation];
    }
    if ([node2 isKindOfClass:[ARNewsSceneNode class]]) {
        [(ARNewsSceneNode *)node2 startRotateAnimation];
    }
}

- (void)startRandomRotateTimer {
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    WS(weakSelf);
    dispatch_source_set_event_handler(_timer, ^{
        [weakSelf randomRotateAnimation];
    });
    dispatch_resume(_timer);
}

- (void)endRandomRotateTimer {
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
}

- (void)dealloc {
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
}

@end
