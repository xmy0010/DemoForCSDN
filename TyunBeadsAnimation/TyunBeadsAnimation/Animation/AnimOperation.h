

#import <UIKit/UIKit.h>
#import "MYAnimationView.h"


@interface AnimOperation : NSOperation
@property (nonatomic, strong) MYAnimationView *animationView;

+ (instancetype)animOperationWithView:(MYAnimationView *)animationView
                               isLeft:(BOOL)isLeft
                              finishedBlock:(void(^)(BOOL result))finishedBlock;

@end
