//
//  TYDemo3DelegateController.h
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/19.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYBaseViewController.h"


@protocol TYNChapter3Delegate<NSObject>
@optional

- (void)doThingA;

- (void)doThingB;

- (void)doThingC;

@end

@interface TYDemo3DelegateController : TYBaseViewController

@property(nonatomic, weak) id <TYNChapter3Delegate> delegate;


@end
