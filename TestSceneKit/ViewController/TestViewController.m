//
//  TestViewController.m
//  TestSceneKit
//
//  Created by 快摇002 on 2018/12/18.
//  Copyright © 2018 aiitec. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (strong, nonatomic) SCNView *scnView;
@property (strong, nonatomic) SCNScene *scnScene;
@property (strong, nonatomic) SCNNode *cameraNode;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSCNView];
    [self spawnShape];
}

- (void)createSCNView{

    self.scnView = [[SCNView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scnView];
    //self.scnView.showsStatistics = YES;
    self.scnView.allowsCameraControl = YES;
    self.scnView.autoenablesDefaultLighting = YES;

    self.scnScene = [[SCNScene alloc] init];
    self.scnView.scene = self.scnScene;
    self.scnScene.background.contents = @"art.scnassets/texture.png";

    self.cameraNode = [[SCNNode alloc] init];
    self.cameraNode.camera = [[SCNCamera alloc] init];
    //设置物体出现的位置（ Y坐标 ）
    self.cameraNode.position = SCNVector3Make(0, 5, 10);
    [self.scnScene.rootNode addChildNode:self.cameraNode];
}

/**
 在场景中画一个几何物体
 */
- (void)spawnShape{
 
    SCNGeometry *scnGeometry = [SCNBox boxWithWidth:1.0 height:1.0 length:1.0 chamferRadius:0.0];
    SCNNode *geometryNode = [SCNNode nodeWithGeometry:scnGeometry];
    //设置自由落体
    geometryNode.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:nil];
    //物体要移动的位置 
    SCNVector3 force = SCNVector3Make(2, 13, 4);
    //作用力的位置
    SCNVector3 position = SCNVector3Make(0.05, 0.05, 0.05);
    [geometryNode.physicsBody applyForce:force atPosition:position impulse:YES];
    [self.scnScene.rootNode addChildNode:geometryNode];
}

@end
