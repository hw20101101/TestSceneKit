//
//  ChangeCameraViewController.m
//  TestSceneKit  切换视角（照相机）
//
//  Created by 快摇002 on 2018/12/19.
//  Copyright © 2018 aiitec. All rights reserved.
//

#import "ChangeCameraViewController.h"
#import <SceneKit/SceneKit.h>

@interface ChangeCameraViewController ()

@property (strong, nonatomic) SCNView *scnView;

/**
 太阳系节点
 */
@property (strong, nonatomic) SCNNode *sunNode;

/**
 地球系节点
 */
@property (strong, nonatomic) SCNNode *earthNode;

/**
 地月系节点
 */
@property (strong, nonatomic) SCNNode *earthMoonNode;

/**
 第三视角节点
 */
@property (strong, nonatomic) SCNNode *thirdViewCameraNode;

/**
 第一视角节点
 */
@property (strong, nonatomic) SCNNode *firstViewCameraNode;

@end

@implementation ChangeCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addView];
    [self addNodes];
    [self addAction];
    [self addCameraNode];
    [self addButtons];
}

#pragma mark - 进入太阳系
- (void)firstBtnAction{
    self.scnView.pointOfView = self.thirdViewCameraNode;
    SCNAction *move = [SCNAction moveTo:SCNVector3Make(0, 0, 30) duration:1];
    [self.thirdViewCameraNode runAction:move];
}

//进入地月系
- (void)secondBtnAction{
    self.scnView.pointOfView = self.firstViewCameraNode;
}

//离开太阳系
- (void)thirdBtnAction{
    self.scnView.pointOfView = self.thirdViewCameraNode;
    SCNAction *move = [SCNAction moveTo:SCNVector3Make(0, 0, 400) duration:1];
    [self.thirdViewCameraNode runAction:move];
}

- (void)addButtons{
    UIButton *firstBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 100, 30)];
    [firstBtn setTitle:@"进入太阳系" forState:UIControlStateNormal];
    [firstBtn setBackgroundColor:[UIColor lightGrayColor]];
    [firstBtn addTarget:self action:@selector(firstBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstBtn];

    UIButton *secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 100, 100, 30)];
    [secondBtn setTitle:@"进入地月系" forState:UIControlStateNormal];
    [secondBtn setBackgroundColor:[UIColor lightGrayColor]];
    [secondBtn addTarget:self action:@selector(secondBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondBtn];

    UIButton *thirdBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 100, 100, 30)];
    [thirdBtn setTitle:@"离开太阳系" forState:UIControlStateNormal];
    [thirdBtn setBackgroundColor:[UIColor lightGrayColor]];
    [thirdBtn addTarget:self action:@selector(thirdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:thirdBtn];
}

- (void)addView{

    //设置场景视图
    self.scnView = [[SCNView alloc] initWithFrame:self.view.bounds];
    self.scnView.scene = [SCNScene scene];
    self.scnView.backgroundColor = [UIColor blackColor];
    self.scnView.allowsCameraControl = YES;
    [self.view addSubview:self.scnView];
}

- (void)addNodes{

    //创建太阳系
    self.sunNode = [SCNNode node];
    self.sunNode.geometry = [SCNSphere sphereWithRadius:3];
    self.sunNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"a1_sun.png"];
    [self.scnView.scene.rootNode addChildNode:self.sunNode];

    //创建地月系节点
    self.earthMoonNode = [SCNNode node];
    self.earthMoonNode.position = SCNVector3Make(10, 0, 0);
    [self.sunNode addChildNode:self.earthMoonNode];

    //创建地球系节点
    self.earthNode = [SCNNode node];
    self.earthNode.geometry = [SCNSphere sphereWithRadius:1];
    self.earthNode.geometry.firstMaterial.diffuse.contents = @"a3_earth.png";
    self.earthNode.position = SCNVector3Make(0, 0, 0);
    [self.earthMoonNode addChildNode:self.earthNode];

    //创建月球系节点
    SCNNode *moonNode = [SCNNode node];
    moonNode.geometry = [SCNSphere sphereWithRadius:0.5];
    moonNode.geometry.firstMaterial.diffuse.contents = @"a2_moon.png";
    moonNode.position = SCNVector3Make(2, 0, 0);
    [self.earthNode addChildNode:moonNode];
}

- (void)addAction{

    //太阳沿着Y轴自转
    SCNAction *sunRotate = [SCNAction repeatActionForever:[SCNAction rotateByAngle:0.1 aroundAxis:SCNVector3Make(0, 1, 0) duration:0.3]];
    [self.sunNode runAction:sunRotate];
    //地球沿着Y轴自转 （地球和地月节点一起围绕太阳节点转动）
    SCNAction *rotation = [SCNAction repeatActionForever:[SCNAction rotateByAngle:0.1 aroundAxis:SCNVector3Make(0, 1, 0) duration:0.05]];
    [self.earthNode runAction:rotation];
}

#pragma mark - 创建两个视角
- (void)addCameraNode{

    //创建一个场景范围内的第三视角
    self.thirdViewCameraNode = [SCNNode node];
    self.thirdViewCameraNode.camera = [SCNCamera camera];
    self.thirdViewCameraNode.camera.automaticallyAdjustsZRange = YES;
    self.thirdViewCameraNode.position = SCNVector3Make(0, 0, 30);
    [self.scnView.scene.rootNode addChildNode:self.thirdViewCameraNode];

    //创建一个地月系的第一视角
    self.firstViewCameraNode = [SCNNode node];
    self.firstViewCameraNode.camera = [SCNCamera camera];
    self.firstViewCameraNode.position = SCNVector3Make(0, 0, 10);
    [self.earthMoonNode addChildNode:self.firstViewCameraNode];

    //设置当前视角
    self.scnView.pointOfView = self.firstViewCameraNode;
}

@end
