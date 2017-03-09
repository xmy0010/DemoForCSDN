//
//  ViewController.m
//  TyunBeadsAnimation
//
//  Created by T_yun on 2017/1/20.
//  Copyright © 2017年 优谱德. All rights reserved.
//

#import "ViewController.h"
#import "MYAnimationView.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger count;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 80)];
    laebl.text = [NSString stringWithFormat:@"%ld", self.count];
    laebl.font = [UIFont systemFontOfSize:60];
    laebl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:laebl];
    
    MYAnimationView *myAnimationView = [[MYAnimationView alloc] initWithOriginY:300 imageWidth:40];
    [myAnimationView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
    //    myAnimationView.animationDuration = 1;
    myAnimationView.imageName = @"1";
    [self.view addSubview:myAnimationView];
    [myAnimationView drawView];
    
    myAnimationView.countBlock = ^(BOOL isAdd){
        if (isAdd) {
            
            ++self.count;
        } else {
            
            --self.count;
            if (self.count < 0) {
                
                self.count = 0;
            }
        }
        
        laebl.text = [NSString stringWithFormat:@"%ld", self.count];
    };

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
