//
//  GameViewController.m
//  TestSceneKit
//
//  Created by 快摇002 on 2018/12/18.
//  Copyright © 2018 aiitec. All rights reserved.
//
#define kZoomInValue 1.5
#define kZoomOutValue 0.5
#define kZoomDefaultValue 1.0

#import "GameViewController.h"

typedef enum : NSUInteger {
    ZoomOut,
    ZoomIn,
} ScaleStatus;

@interface GameViewController()

@property (strong, nonatomic) SCNView *scnView;

@property (strong, nonatomic) SCNScene *scene;

@property (strong, nonatomic) SCNNode *cameraNode;

@property (strong, nonatomic) SCNNode *boxNode;

@property (assign, nonatomic) CGFloat boxScale;

@property (assign, nonatomic) int scaleValue;

//@property (assign, nonatomic) ScaleStatus scaleStatus;

@property (strong, nonatomic) NSMutableDictionary *scaleData;

/**
 放大的次数
 */
@property (assign, nonatomic) int zoomInCount;

/**
 缩小的次数
 */
@property (assign, nonatomic) int zoomOutCount;

@property (assign, nonatomic) CGFloat currentAngleX;
@property (assign, nonatomic) CGFloat currentAngleY;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSenceView];
    [self createScene];
    [self createBox];
}

- (void)createSenceView{

    // retrieve the SCNView
    self.scnView = [[SCNView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scnView];

    //开启默认光源
    self.scnView.autoenablesDefaultLighting = NO;
    // allows the user to manipulate the camera
    self.scnView.allowsCameraControl = NO;
    // show statistics such as fps and timing information
    self.scnView.showsStatistics = YES;
    // configure the view
    self.scnView.backgroundColor = [UIColor whiteColor];

    // add a tap gesture recognizer
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    NSMutableArray *gestureRecognizers = [NSMutableArray array];
//    [gestureRecognizers addObject:tapGesture];
//    [gestureRecognizers addObjectsFromArray:self.scnView.gestureRecognizers];
//    self.scnView.gestureRecognizers = gestureRecognizers;

    [self.scnView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)]];
    [self.scnView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)]];
    [self.scnView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)]];
}

- (void)createBox{

//    SCNBox *box = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
//    box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"a0_demo.png"];//注意图片路径，（此路径默认从 Assets.xcassets 中读取图片）
//    self.boxNode = [SCNNode node];
//    self.boxNode.geometry = box;
//    self.boxNode.position = SCNVector3Make(0, 0, 0);
//    [self.scnView.scene.rootNode addChildNode:self.boxNode];

    //创建球体
//    SCNSphere *sphere = [SCNSphere sphereWithRadius:10.1];
//    sphere.firstMaterial.diffuse.contents = @"a3_earth.png";
//    SCNNode *sphereNode = [SCNNode node];
//    sphereNode.geometry = sphere;
//    sphereNode.position = SCNVector3Make(0, 0, -10);
//    [self.scnView.scene.rootNode addChildNode:sphereNode];
}

- (void)createScene{

    // create a new scene
    self.scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];//Named:@"art.scnassets/ship.scn"
    // set the scene to the view
    self.scnView.scene = self.scene;

    // create and add a camera to the scene
    self.cameraNode = [SCNNode node];
    //给节点添加名字
    self.cameraNode.name = @"camera";
    self.cameraNode.camera = [SCNCamera camera];
    // place the camera
    self.cameraNode.position = SCNVector3Make(0, 0, 35);
//    cameraNode.camera.zFar = 10000;
    [self.scene.rootNode addChildNode:self.cameraNode];

    // create and add a light to the scene
//    SCNNode *lightNode = [SCNNode node];
//    lightNode.light = [SCNLight light];
////    lightNode.light.zFar = 500;
//    lightNode.light.type = SCNLightTypeOmni;
//    lightNode.position = SCNVector3Make(10, 10, 10);
//    [self.scene.rootNode addChildNode:lightNode];

    // create and add an ambient light to the scene
//    SCNNode *ambientLightNode = [SCNNode node];
//    ambientLightNode.light = [SCNLight light];
//    ambientLightNode.light.type = SCNLightTypeDirectional;
//    ambientLightNode.light.color = [UIColor greenColor];
//    [self.scene.rootNode addChildNode:ambientLightNode];

//    SCNNode *camera = [self.scene.rootNode childNodeWithName:@"camera" recursively:YES];
//    NSLog(@"-->> camera:%@", camera);

    // retrieve the ship node 获得这个场景中飞机这个节点
    //    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
    //
    //    // animate the 3d object
    //    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
}

#pragma mark - 平移手势（翻转、旋转）
- (void)panGesture:(UIPanGestureRecognizer *)pan {

    // 检查触发了哪些节点
    CGPoint p = [pan locationInView:self.scnView];
    NSArray *hitResults = [self.scnView hitTest:p options:nil];

    // 保证至少有一个节点被触发
    if([hitResults count] > 0){
        // 检索触发的第一个对象
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        SCNNode *geometryNode = result.node;

//        CGPoint translation = [pan translationInView:pan.view];
//        CGFloat newAngleX = (CGFloat)(translation.y)*(CGFloat)(M_PI)/180.0;
//        newAngleX += self.currentAngleX;
//        CGFloat newAngleY = (CGFloat)(translation.x)*(CGFloat)(M_PI)/180.0;
//        newAngleY += self.currentAngleY;
//        node.eulerAngles = SCNVector3Make(newAngleX, newAngleY, 0);

        CGPoint translation = [pan translationInView:pan.view];
        CGFloat x = (CGFloat)(translation.x);
        CGFloat y = (CGFloat)(-translation.y);

        CGFloat anglePan = sqrt(pow(x,2)+pow(y,2))*(CGFloat)(M_PI)/180.0;
        SCNVector4 rotationVector = SCNVector4Make(-y, x, 0, anglePan);
//        rotationVector.x = -y;
//        rotationVector.y = x;
//        rotationVector.z = 0;
//        rotationVector.w = anglePan;
        geometryNode.rotation = rotationVector;

        if (pan.state == UIGestureRecognizerStateEnded) {
//            self.currentAngleX = newAngleX;
//            self.currentAngleY = newAngleY;

            SCNMatrix4 currentPivot = geometryNode.pivot;
            SCNMatrix4 changePivot = SCNMatrix4Invert(geometryNode.transform);
            geometryNode.pivot = SCNMatrix4Mult(changePivot, currentPivot);
            geometryNode.transform = SCNMatrix4Identity;
        }
    }
}

#pragma mark - 缩放手势
- (void)pinchGesture:(UIPinchGestureRecognizer *)pinch {

    // 检查触发了哪些节点
    CGPoint p = [pinch locationInView:self.scnView];
    NSArray *hitResults = [self.scnView hitTest:p options:nil];

    // 保证至少有一个节点被触发
    if([hitResults count] > 0 && pinch.state == UIGestureRecognizerStateChanged){
        // 检索触发的第一个对象
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        SCNNode *geometryNode = result.node;

        CGFloat pinchScaleX = (CGFloat)(pinch.scale) * geometryNode.scale.x;
        CGFloat pinchScaleY =  (CGFloat)(pinch.scale) * geometryNode.scale.y;
        CGFloat pinchScaleZ =  (CGFloat)(pinch.scale) * geometryNode.scale.z;
        geometryNode.scale = SCNVector3Make(pinchScaleX, pinchScaleY, pinchScaleZ);
        pinch.scale = 1;
    }
}

#pragma mark - 旋转手势
- (void)rotationGesture:(UIRotationGestureRecognizer *)rotation {

    NSLog(@"-->> rotation:%f - velocity:%f", rotation.rotation, rotation.velocity);

    // 检查点击了哪些节点
    CGPoint p = [rotation locationInView:self.scnView];
    NSArray *hitResults = [self.scnView hitTest:p options:nil];

    // 保证至少有一个节点被点击
    if([hitResults count] > 0 && rotation.state == UIGestureRecognizerStateEnded){
        // 检索单击的第一个对象
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        SCNNode *node = result.node;

        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];

        //TODO ???
        SCNAction *action = [SCNAction rotateByAngle:rotation.rotation aroundAxis:SCNVector3Make(0, rotation.velocity, 0) duration:0.5];
        [node runAction:action];

        [SCNTransaction commit];
    }
}

#pragma mark - 获取被点击的节点
- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // 检查点击了哪些节点
    CGPoint p = [gestureRecognize locationInView:self.scnView];
    NSArray *hitResults = [self.scnView hitTest:p options:nil];
    
    // 保证至少有一个节点被点击
    if([hitResults count] > 0){
        // 检索单击的第一个对象
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        // 获取节点材质
        SCNMaterial *material = result.node.geometry.firstMaterial;
        // 使节点高亮
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        NSLog(@"-->> result.node:%@", result.node);

        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            material.emission.contents = [UIColor blackColor];
            //material.emission.contentsTransform
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        [SCNTransaction commit];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

@end
