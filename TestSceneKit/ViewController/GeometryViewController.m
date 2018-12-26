//
//  GeometryViewController.m
//  TestSceneKit 测试几何体
//
//  Created by 快摇002 on 2018/12/19.
//  Copyright © 2018 aiitec. All rights reserved.
//

#import "GeometryViewController.h"
#import <SceneKit/SceneKit.h>

@interface GeometryViewController ()

/**
 SceneKit 专用显示视图
 */
@property (strong, nonatomic) SCNView *scnView;

/**
 照相机节点
 */
@property (strong, nonatomic) SCNNode *cameraNode;

/**
 正方体节点
 */
@property (strong, nonatomic) SCNNode *boxNode;

/**
 平面节点
 */
@property (strong, nonatomic) SCNNode *planeNode;

/**
 金字塔节点
 */
@property (strong, nonatomic) SCNNode *pyramidNode;

@end

@implementation GeometryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加 SceneKit 专用显示视图 SCNView
    [self.view addSubview:self.scnView];
    //添加照相机节点
    [self.scnView.scene.rootNode addChildNode:self.cameraNode];
    //添加正方体节点
    //[self.scnView.scene.rootNode addChildNode:self.boxNode];
    //添加平面节点
    //[self.scnView.scene.rootNode addChildNode:self.planeNode];
    [self.scnView.scene.rootNode addChildNode:self.pyramidNode];
}

- (SCNView *)scnView{
    if (!_scnView) {
        _scnView = [[SCNView alloc] initWithFrame:self.view.bounds];
        _scnView.backgroundColor = [UIColor blackColor];
        //设置场景
        _scnView.scene = [SCNScene scene];
        //运行相机控制
        _scnView.allowsCameraControl = YES;
    }
    return _scnView;
}

- (SCNNode *)cameraNode{
    if (!_cameraNode) {
        _cameraNode = [SCNNode node];
        _cameraNode.camera = [SCNCamera camera];
        _cameraNode.position = SCNVector3Make(0, 0, 50);
    }
    return _cameraNode;
}

- (SCNNode *)boxNode{
    if (!_boxNode) {
        SCNBox *box = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
        box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"a0_demo.png"];//注意图片路径，（此路径默认从 Assets.xcassets 中读取图片）
        _boxNode = [SCNNode node];
        _boxNode.position = SCNVector3Make(0, 0, 0);
        _boxNode.geometry = box;
    }
    return _boxNode;
}

- (SCNNode *)planeNode{
    if (!_planeNode) {
        SCNPlane *plane = [SCNPlane planeWithWidth:2 height:2];
        plane.firstMaterial.diffuse.contents = [UIImage imageNamed:@"art.scnassets/test.png"];//注意图片路径
        _planeNode = [SCNNode nodeWithGeometry:plane];
        _planeNode.position = SCNVector3Make(0, 0, 0);
    }
    return _planeNode;
}

- (SCNNode *)pyramidNode{
    if (!_pyramidNode) {
        SCNPyramid *pyramid = [SCNPyramid pyramidWithWidth:5 height:5 length:5];
        pyramid.firstMaterial.diffuse.contents = [UIImage imageNamed:@"art.scnassets/test.png"];
        _pyramidNode = [SCNNode nodeWithGeometry:pyramid];
        _pyramidNode.position = SCNVector3Make(0, 0, 10);
    }
    return _pyramidNode;
}

@end
