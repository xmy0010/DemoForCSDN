//
//  ViewController.m
//  RevealDemo
//
//  Created by zwzh_14 on 2021/8/30.
//

#import "ViewController.h"
#define kOFFSET_FOR_KEYBOARD 80.0


@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;

@property (nonatomic,assign) CGFloat keyboardHeight;

///当前上移量
@property (nonatomic,assign) CGFloat currentOffset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEndEditing)]];
}
- (void)viewEndEditing {
    [self.view endEditing:YES];
}



#pragma mark 键盘管理

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWillShow:(NSNotification*)aNotification {
    
    NSDictionary *userInfo = [aNotification userInfo];
      NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
      CGRect keyboardRect = [aValue CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    [self setViewMoveUp:YES];
}

-(void)keyboardWillHide:(NSNotification*)aNotification {
    [self setViewMoveUp:NO];
}


- (void)setViewMoveUp:(BOOL)moveUp {
    
    //获取当前页面第一响应
    UIView *firstResponder = [self findFirstResponderBeneathView:self.view];
    if (!firstResponder) {
        return;
    }
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    CGFloat responderNeed = firstResponder.frame.origin.y + firstResponder.bounds.size.height + self.keyboardHeight - self.currentOffset;
    CGFloat offset = 0;
    
    CGRect rect = self.view.frame;
    if (moveUp) {
        if (responderNeed - self.currentOffset > screenHeight) {
            offset = responderNeed - screenHeight - self.currentOffset;
            self.currentOffset = offset;
        } else if (responderNeed <= screenHeight && self.currentOffset > 0){
            //当前view上移且当前响应者不需要上移
            offset =  - self.currentOffset;
            self.currentOffset = 0;
        }
    } else {
        if (self.currentOffset > 0) {
            offset = -self.currentOffset;
            self.currentOffset = 0;
        }
    }
    if (offset != 0) {
        rect.origin.y -= offset;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = rect;
        }];
    }
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

@end
