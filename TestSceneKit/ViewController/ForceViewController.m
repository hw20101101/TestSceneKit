//
//  ForceViewController.m
//  TestSceneKit 力的使用
//
//  Created by 快摇002 on 2018/12/19.
//  Copyright © 2018 aiitec. All rights reserved.
//

#import "ForceViewController.h"
#import <SceneKit/SceneKit.h>

@interface ForceViewController ()

@property (strong, nonatomic) SCNView *scnView;

@property (strong, nonatomic) SCNNode *floorNode;

@end

@implementation ForceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSence];
    [self createCamera];
    [self createFloor];
    [self ceareCylinder];
}

- (void)createSence{

    //创建场景
    self.scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    self.scnView.backgroundColor = [UIColor blackColor];
    self.scnView.scene = [SCNScene scene];
    self.scnView.allowsCameraControl = YES;
    [self.view addSubview:self.scnView];
}

- (void)createCamera{

    //添加照相机节点
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 30, 30);
    cameraNode.rotation = SCNVector4Make(1, 0, 0, -M_PI/4);
    cameraNode.camera.automaticallyAdjustsZRange = true;
    [self.scnView.scene.rootNode addChildNode:cameraNode];
}

- (void)createFloor{

    //添加地板节点
    _floorNode = [SCNNode node];
    _floorNode.geometry = [SCNFloor floor];
    _floorNode.geometry.firstMaterial.diffuse.contents = @"a0_demo.png";
    _floorNode.physicsBody = [SCNPhysicsBody staticBody];
    [self.scnView.scene.rootNode addChildNode:_floorNode];
}

- (void)ceareCylinder{

    //创建圆筒节点
    SCNTube *cylinderTube = [SCNTube tubeWithInnerRadius:1 outerRadius:1.2 height:4];
    cylinderTube.firstMaterial.diffuse.contents = [UIImage imageNamed:@"spark.png"];
    SCNNode *cylinderNode =[SCNNode nodeWithGeometry:cylinderTube];
    cylinderNode.physicsBody = [SCNPhysicsBody kinematicBody];
    cylinderNode.position = SCNVector3Make(-5, 2, 0);
    [self.scnView.scene.rootNode addChildNode:cylinderNode];

    //创建电场节点
    SCNNode *electricNode = [SCNNode nodeWithGeometry:[SCNTube tubeWithInnerRadius:4.5 outerRadius:5 height:2]];
    electricNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"spark.png"];
    electricNode.position = SCNVector3Make(6, 1, 0);
    [self.scnView.scene.rootNode addChildNode:electricNode];
    SCNNode *electricFieldNode = [SCNNode node];
    electricFieldNode.physicsField = [SCNPhysicsField electricField];
    electricFieldNode.physicsField.strength = -10;
    [electricNode addChildNode:electricFieldNode];

    // 添加粒子节点
    SCNParticleSystem *particleSytem = [SCNParticleSystem particleSystemNamed:@"SceneKitParticleSystem.scnp" inDirectory:nil];
    // 设置和粒子产生碰撞的节点
    particleSytem.colliderNodes = @[electricNode, _floorNode];
    particleSytem.affectedByPhysicsFields = true;// 让粒子可以受力的影响
    // 设置粒子的电荷
    particleSytem.particleCharge = 10;
    SCNNode *particleNode = [SCNNode node];
    particleNode.position = SCNVector3Make(0, 0, 0);
    [particleNode addParticleSystem:particleSytem];
    particleNode.physicsBody = [SCNPhysicsBody dynamicBody];
    [cylinderNode addChildNode:particleNode];
}

@end
