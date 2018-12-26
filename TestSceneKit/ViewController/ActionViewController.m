//
//  ActionViewController.m
//  TestSceneKit 测试动画行为
//
//  Created by 快摇002 on 2018/12/19.
//  Copyright © 2018 aiitec. All rights reserved.
//

#import "ActionViewController.h"
#import <SceneKit/SceneKit.h>

@interface ActionViewController ()

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

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加 SceneKit 专用显示视图 SCNView
    [self.view addSubview:self.scnView];
    //添加照相机节点
    [self.scnView.scene.rootNode addChildNode:self.cameraNode];
    //添加正方体节点
    [self.scnView.scene.rootNode addChildNode:self.boxNode];
    //执行动画
    [self addAction];
}

- (SCNView *)scnView{
    if (!_scnView) {
        _scnView = [[SCNView alloc] initWithFrame:self.view.bounds];
        _scnView.backgroundColor = [UIColor blackColor];
        //设置场景
        _scnView.scene = [SCNScene scene];
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

- (void)addAction{

    //创建动画行为
    SCNAction *rotation = [SCNAction rotateByAngle:10 aroundAxis:SCNVector3Make(0, 1, 0) duration:2];
    SCNAction *moveUp = [SCNAction moveTo:SCNVector3Make(0, 15, 0) duration:1];
    SCNAction *moveDown = [SCNAction moveTo:SCNVector3Make(0, -15, 0) duration:1];
    //串联动画
    SCNAction *sequence = [SCNAction sequence:@[moveUp, moveDown]];
    //组合动画
    SCNAction *group = [SCNAction group:@[sequence, rotation]];
    [self.boxNode runAction:[SCNAction repeatActionForever:group]];
}

@end
