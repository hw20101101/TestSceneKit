//
//  ChangeSceneViewController.m
//  TestSceneKit 切换场景
//
//  Created by 快摇002 on 2018/12/20.
//  Copyright © 2018 aiitec. All rights reserved.
//

#import "ChangeSceneViewController.h"
#import <SceneKit/SceneKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ChangeSceneViewController ()

@property (strong, nonatomic) SCNView *scnView;

@end

@implementation ChangeSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSence];
    [self createCamera];
    [self createButton];
}

- (void)createSence{

    //创建场景
    self.scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    self.scnView.backgroundColor = [UIColor blackColor];
    self.scnView.scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    self.scnView.allowsCameraControl = YES;
    [self.view addSubview:self.scnView];
}

- (void)createCamera{

    //创建相机节点
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = YES;
    cameraNode.position = SCNVector3Make(0, 0, 1000);
    [self.scnView.scene.rootNode addChildNode:cameraNode];
}

- (void)createButton{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 40)];
    [button setTitle:@"切换场景" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button addTarget:self action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonOnClick{

    //创建正方体节点
    SCNBox *box = [SCNBox boxWithWidth:100 height:100 length:100 chamferRadius:0];
    box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"a0_demo.png"];//注意图片路径，（此路径默认从 Assets.xcassets 中读取图片）
    SCNNode *boxNode = [SCNNode node];
    boxNode.position = SCNVector3Make(0, 0, 0);
    boxNode.geometry = box;

    //创建一个新场景
    SCNScene *scene = [SCNScene scene];
    [scene.rootNode addChildNode:boxNode];

    //创建另一个相机节点
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = YES;
    cameraNode.position = SCNVector3Make(0, -100, -1000);
    cameraNode.rotation = SCNVector4Make(1, 0, 0, M_PI);
    [scene.rootNode addChildNode:cameraNode];

    //创建转换场景
    //SKTransition *transition = [SKTransition doorwayWithDuration:1];
    SKTransition *transition = [SKTransition crossFadeWithDuration:1];
    [self.scnView presentScene:scene withTransition:transition incomingPointOfView:cameraNode completionHandler:nil];
}

@end
