//
//  ARNewsSceneNode.h
//  UniversalQRCode
//
//  Created by lxin on 2019/1/16.
//  Copyright © 2019 OMT. All rights reserved.
//

#import <SceneKit/SceneKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface ARNewsSceneNode : SCNNode


- (void)startAnimation;
- (void)endAnimation;

- (void)startRotateAnimation;
- (void)endRotateAnimation;

@end

NS_ASSUME_NONNULL_END
