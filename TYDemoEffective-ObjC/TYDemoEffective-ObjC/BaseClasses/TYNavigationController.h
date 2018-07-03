//
//  TYNavigationController.h
//  zmgk_LeZheng
//
//  Created by T_yun on 2017/6/22.
//  Copyright © 2017年 zmgk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYNavigationController : UINavigationController

//提交订单时需要提交 0政务审批 1第三方 2企业服务
@property(nonatomic, assign) NSInteger orderType;


@end
