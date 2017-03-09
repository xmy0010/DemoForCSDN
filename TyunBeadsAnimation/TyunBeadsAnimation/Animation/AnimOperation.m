

#import "AnimOperation.h"
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface AnimOperation ()
@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result);


@property (nonatomic, assign) BOOL isLeft;

@end


@implementation AnimOperation

@synthesize finished = _finished;
@synthesize executing = _executing;


+ (instancetype)animOperationWithView:(MYAnimationView *)animationView
    isLeft:(BOOL)isLeft finishedBlock:(void (^)(BOOL))finishedBlock {

    AnimOperation *op = [[AnimOperation alloc] init];
    
    op.finishedBlock = finishedBlock;
    op.animationView = animationView;
    op.isLeft = isLeft;
    
    return op;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
        
        
    }
    return self;
}

- (void)start {

    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.animationView animateWithCompleteBlock:^(BOOL finished) {
            
            self.finished = finished;
            self.finishedBlock(finished);
        } isLeft:self.isLeft];
    }];
    
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
