//
//  ARNewsSceneView.h
//  UniversalQRCode
//
//  Created by lxin on 2019/1/16.
//  Copyright © 2019 OMT. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "ARNewsSceneNode.h"


NS_ASSUME_NONNULL_BEGIN

@interface ARNewsSceneView : SCNView

@property (nonatomic, strong, readonly) SCNNode *cameraNode;

//- (void)addNode:(NSString *)title imgUrl:(NSString *)imgUrl isVideo:(BOOL)isVideo jump:(JumpModel *)jump;
- (void)addNodeDone;

@end

NS_ASSUME_NONNULL_END
