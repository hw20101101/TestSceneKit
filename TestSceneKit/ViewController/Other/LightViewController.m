//
//  SecondViewController.m
//  TestSceneKit 测试光源
//
//  Created by 快摇002 on 2018/12/19.
//  Copyright © 2018 aiitec. All rights reserved.
//

#import "LightViewController.h"
#import <SceneKit/SceneKit.h>

@interface LightViewController ()

@property (strong, nonatomic) SCNView *scnView;

@end

@implementation LightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSceneView];
    [self addGeometry];
    [self addSpotLight];
}

- (void)createSceneView{
    self.scnView = [[SCNView alloc] initWithFrame:self.view.bounds];
    self.scnView.backgroundColor = [UIColor blackColor];
    self.scnView.allowsCameraControl = YES;
    [self.view addSubview:self.scnView];

    //设置场景
    self.scnView.scene = [SCNScene scene];
}

#pragma MARK - 添加几何体
- (void)addGeometry{

    //创建正方体
    SCNBox *box = [SCNBox boxWithWidth:0.5 height:0.5 length:0.5 chamferRadius:0];
    //创建球体
    SCNSphere *sphere = [SCNSphere sphereWithRadius:0.1];

    //添加两个几何体到节点上
    SCNNode *boxNode = [SCNNode node];
    boxNode.geometry = box;
    boxNode.position = SCNVector3Make(0, 0, -11);

    SCNNode *sphereNode = [SCNNode node];
    sphereNode.geometry = sphere;
    sphereNode.position = SCNVector3Make(0, 0, -10);

    //把节点添加到场景中
    [self.scnView.scene.rootNode addChildNode:boxNode];
    [self.scnView.scene.rootNode addChildNode:sphereNode];
}

#pragma mark - 在场景中添加一个点光源
- (void)addOmniLight{
    //在场景中添加一个点光源
    SCNLight *light = [SCNLight light];
    light.type = SCNLightTypeOmni;
    light.color = [UIColor yellowColor];

    //把灯光添加到节点中
    SCNNode *lightNode = [SCNNode node];
    lightNode.position = SCNVector3Make(100, 100, 100);
    lightNode.light = light;
    [self.scnView.scene.rootNode addChildNode:lightNode];
}

#pragma mark - 在场景中添加一个环境光
- (void)addLightAmbient{

    //在场景中添加一个环境光
    SCNLight *light = [SCNLight light];
    light.type = SCNLightTypeAmbient;
    light.color = [UIColor yellowColor];

    //把灯光添加到节点中
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = light;
    [self.scnView.scene.rootNode addChildNode:lightNode];
}

#pragma mark - 添加平行方向光源
- (void)addDirectionalLight{

    SCNLight *light = [SCNLight light];
    light.type = SCNLightTypeDirectional;
    light.color = [UIColor yellowColor];

    SCNNode *lightNode = [SCNNode node];
    //设置光源节点的位置
    lightNode.position = SCNVector3Make(1000, 1000, 1000);
    lightNode.light = light;
    //这种光的默认方向为z轴负方向，我们把它设置成Y轴负方向
    lightNode.rotation = SCNVector4Make(1, 0, 0, -M_PI/2.0);
    [self.scnView.scene.rootNode addChildNode:lightNode];
}

#pragma mark - 添加聚焦光源
- (void)addSpotLight{
    SCNLight *light = [SCNLight light];
    light.type = SCNLightTypeSpot;
    light.color = [UIColor yellowColor];
    light.castsShadow = YES;//捕捉阴影
    light.spotOuterAngle = 2;//设置光的发射角度
    //light.zFar = 20;//设置光能照射的最远处

    SCNNode *lightNode = [SCNNode node];
    lightNode.position = SCNVector3Make(0, 0, 0);
    lightNode.light = light;
    [self.scnView.scene.rootNode addChildNode:lightNode];
}

@end
