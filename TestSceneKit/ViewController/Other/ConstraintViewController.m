//
//  ConstraintViewController.m
//  TestSceneKit 学习约束(反向运动约束)
//
//  Created by 快摇002 on 2018/12/19.
//  Copyright © 2018 aiitec. All rights reserved.
//

#import "ConstraintViewController.h"
#import <SceneKit/SceneKit.h>

@interface ConstraintViewController ()

@property (strong, nonatomic) SCNView *scnView;

@property (strong, nonatomic) SCNIKConstraint *constraint;

@end

@implementation ConstraintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addView];
    [self addCameraNode];
    [self addArmToScene];
}

- (void)addView{
    //创建场景
    self.scnView = [[SCNView alloc] initWithFrame:self.view.bounds];
    self.scnView.allowsCameraControl = YES;
    self.scnView.backgroundColor = [UIColor blackColor];
    self.scnView.scene = [SCNScene scene];
    self.scnView.scene.physicsWorld.gravity = SCNVector3Make(0, 90, 0);//添加重力
    [self.view addSubview:self.scnView];

    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.scnView addGestureRecognizer:tap];
}

- (void)addCameraNode{
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = YES;
    cameraNode.position = SCNVector3Make(0, 0, 1000);
    [self.scnView.scene.rootNode addChildNode:cameraNode];
}

//添加机器手臂并设置约束
- (void)addArmToScene{

    //创建手掌节点
    SCNNode *handNode = [SCNNode node];
    handNode.geometry = [SCNBox boxWithWidth:20 height:20 length:20 chamferRadius:0];
    handNode.geometry.firstMaterial.diffuse.contents = [UIColor purpleColor];
    handNode.position = SCNVector3Make(0, -50, 0);

    //创建小手臂节点
    SCNNode *lowerArmNode = [SCNNode node];
    lowerArmNode.geometry = [SCNCylinder cylinderWithRadius:1 height:100];
    lowerArmNode.geometry.firstMaterial.diffuse.contents = [UIColor redColor];
    lowerArmNode.position = SCNVector3Make(0, -50, 0);
    lowerArmNode.pivot = SCNMatrix4MakeTranslation(0, 50, 0);//连接点
    [lowerArmNode addChildNode:handNode];

    //创建上臂节点
    SCNNode *upperArmNode = [SCNNode node];
    upperArmNode.geometry = [SCNCylinder cylinderWithRadius:1 height:100];
    upperArmNode.geometry.firstMaterial.diffuse.contents = [UIColor greenColor];
    upperArmNode.pivot = SCNMatrix4MakeTranslation(0, 50, 0);
    [upperArmNode addChildNode:lowerArmNode];

    //创建控制点
    SCNNode *controlNode = [SCNNode node];
    controlNode.geometry = [SCNSphere sphereWithRadius:10];
    controlNode.geometry.firstMaterial.diffuse.contents = [UIColor blueColor];
    controlNode.position = SCNVector3Make(0, 100, 0);
    [controlNode addChildNode:upperArmNode];

    //添加到场景中
    [self.scnView.scene.rootNode addChildNode:controlNode];
//    self.scnView.delegate = self;

    //创建约束
    self.constraint = [SCNIKConstraint inverseKinematicsConstraintWithChainRootNode:controlNode];

    //添加约束
    handNode.constraints = @[self.constraint];
}

//每次点击屏幕，随机增加一个球
- (void)tapAction{

    SCNNode *node = [SCNNode node];
    node.position = SCNVector3Make(arc4random_uniform(100), arc4random_uniform(100), arc4random_uniform(100));
    node.geometry = [SCNSphere sphereWithRadius:10];
    node.geometry.firstMaterial.diffuse.contents = [UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1];
    [self.scnView.scene.rootNode addChildNode:node];

    //创建动画
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];
    self.constraint.targetPosition = node.position;
    [SCNTransaction commit];
    node.physicsBody = [SCNPhysicsBody dynamicBody];
}

@end
