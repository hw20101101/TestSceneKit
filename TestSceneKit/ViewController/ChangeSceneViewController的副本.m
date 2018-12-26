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

@property (strong, nonatomic) SCNNode *boxNode;

@property (assign, nonatomic) BOOL isShowBox;


/**
 飞船场景
 */
@property (strong, nonatomic) SCNScene *shipScene;

@property (strong, nonatomic) SCNNode *shipCameraNode;

/**
 正方体场景
 */
@property (strong, nonatomic) SCNScene *boxScene;

@property (strong, nonatomic) SCNNode *boxCameraNode;

@end

@implementation ChangeSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSenceView];
    [self createCamera];
    [self createBox];
    [self createButton];
}

- (void)createSenceView{

    //创建场景视图
    self.scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    self.scnView.backgroundColor = [UIColor blackColor];
    self.scnView.allowsCameraControl = YES;
    [self.view addSubview:self.scnView];

    //创建场景
    self.shipScene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    self.scnView.scene = self.shipScene;
    self.boxScene = [SCNScene scene];
}

- (void)createCamera{

    //创建相机节点
    self.shipCameraNode = [SCNNode node];
    self.shipCameraNode.camera = [SCNCamera camera];
    self.shipCameraNode.camera.automaticallyAdjustsZRange = YES;
    self.shipCameraNode.position = SCNVector3Make(0, 0, 1000);
    [self.scnView.scene.rootNode addChildNode:self.shipCameraNode];

    //创建另一个相机节点
//    self.boxCameraNode = [SCNNode node];
//    self.boxCameraNode.camera = [SCNCamera camera];
//    self.boxCameraNode.camera.automaticallyAdjustsZRange = YES;
//    self.boxCameraNode.position = SCNVector3Make(0, -100, -1000);
//    self.boxCameraNode.rotation = SCNVector4Make(1, 0, 0, M_PI);
//    [self.boxScene.rootNode addChildNode:self.boxCameraNode];
}

- (void)createBox{

    SCNBox *box = [SCNBox boxWithWidth:100 height:100 length:100 chamferRadius:0];
    box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"a0_demo.png"];//注意图片路径，（此路径默认从 Assets.xcassets 中读取图片）
    self.boxNode = [SCNNode node];
    self.boxNode.position = SCNVector3Make(0, 0, 0);
    self.boxNode.geometry = box;
    [self.boxScene.rootNode addChildNode:self.boxNode];
}

- (void)createButton{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 40)];
    [button setTitle:@"切换场景" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button addTarget:self action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonOnClick{

    //切换场景
    if (self.isShowBox) {
        self.isShowBox = NO;
//        self.scnView.scene = self.boxScene;
        SKTransition *transition = [SKTransition doorwayWithDuration:1];
        [self.scnView presentScene:self.boxScene withTransition:transition incomingPointOfView:self.shipCameraNode completionHandler:nil];

    } else {
        self.isShowBox = YES;
//        self.scnView.scene = self.shipScene;
        SKTransition *transition = [SKTransition crossFadeWithDuration:1];
        [self.scnView presentScene:self.shipScene withTransition:transition incomingPointOfView:self.shipCameraNode completionHandler:nil];
    }
}

@end
