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

@interface GameViewController()

@property (strong, nonatomic) SCNView *scnView;

@property (strong, nonatomic) SCNScene *scene;

@property (strong, nonatomic) SCNNode *cameraNode;

@property (strong, nonatomic) SCNNode *boxNode;


/**
 当前旋转的数据
 */
@property (assign, nonatomic) CGFloat currentAngleX;
@property (assign, nonatomic) CGFloat currentAngleY;

/**
 上一次平移的位置
 */
@property (assign, nonatomic) CGPoint previousMoveLoc;


/**
 上一次旋转的位置
 */
@property (assign, nonatomic) CGPoint previousRotateLoc;

@property (assign, nonatomic) int touchCount;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.previousMoveLoc = CGPointZero;
    [self createSenceView];
    [self createScene];
    //[self createBox];
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

    //添加手势
    [self.scnView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)]];
    [self.scnView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)]];
    //[self.scnView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)]];
}

- (void)createBox{

    //创建正方体
    SCNBox *box = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
    box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"a0_demo.png"];//注意图片路径，（此路径默认从 Assets.xcassets 中读取图片）
    self.boxNode = [SCNNode node];
    self.boxNode.geometry = box;
    self.boxNode.position = SCNVector3Make(0, 0, 0);
    [self.scnView.scene.rootNode addChildNode:self.boxNode];

    //创建球体
    SCNSphere *sphere = [SCNSphere sphereWithRadius:10.1];
    sphere.firstMaterial.diffuse.contents = @"a3_earth.png";
    SCNNode *sphereNode = [SCNNode node];
    sphereNode.geometry = sphere;
    sphereNode.position = SCNVector3Make(0, 0, -10);
    [self.scnView.scene.rootNode addChildNode:sphereNode];
}

- (void)createScene{

    // create a new scene
    self.scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    // set the scene to the view
    self.scnView.scene = self.scene;

    // create and add a camera to the scene
    self.cameraNode = [SCNNode node];
    //给节点添加名字
    self.cameraNode.name = @"camera";
    self.cameraNode.camera = [SCNCamera camera];
    // place the camera
    self.cameraNode.position = SCNVector3Make(0, 0, 35);
    [self.scene.rootNode addChildNode:self.cameraNode];

    /*
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(10, 10, 10);
    [self.scene.rootNode addChildNode:lightNode];

    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeDirectional;
    ambientLightNode.light.color = [UIColor greenColor];
    [self.scene.rootNode addChildNode:ambientLightNode];

    SCNNode *camera = [self.scene.rootNode childNodeWithName:@"camera" recursively:YES];
    NSLog(@"-->> camera:%@", camera);

    // retrieve the ship node 获得这个场景中飞机这个节点
    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];

    // animate the 3d object
    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    */
}

#pragma mark - 单指平移
//- (void)panGesture:(UIPanGestureRecognizer *)pan {
//
//    CGPoint delta;
//    CGPoint location = [pan locationInView:self.scnView];
//    NSArray *hitResults = [self.scnView hitTest:location options:nil];
//
//    // 保证至少有一个节点被触发
//    if([hitResults count] > 0){
//        // 检索触发的第一个对象
//        SCNHitTestResult *result = [hitResults objectAtIndex:0];
//        SCNNode *geometryNode = result.node;
//
//        if (pan.state == UIGestureRecognizerStateChanged) {
//            delta = CGPointMake(2 * (location.x - self.previousMoveLoc.x), 2 * (location.y - self.previousMoveLoc.y));
//            CGFloat x = geometryNode.position.x + (CGFloat)(delta.x * 0.02);
//            CGFloat y = geometryNode.position.y + (CGFloat)(-delta.y * (0.02));
//            geometryNode.position = SCNVector3Make(x, y, 0);
//            self.previousMoveLoc = location;
//        }
//
//        self.previousMoveLoc = location;
//    }
//}

#pragma mark - 1个手指旋转，2个手指移动
- (void)panGesture:(UIPanGestureRecognizer *)pan {

    CGPoint delta = [pan translationInView:self.scnView];
    CGPoint location = [pan locationInView:self.scnView];
    NSArray *hitResults = [self.scnView hitTest:location options:nil];

    // 保证至少有一个节点被触发
    if([hitResults count] > 0){
        // 检索触发的第一个对象
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        SCNNode *geometryNode = result.node;

        if (pan.state == UIGestureRecognizerStateBegan) {
            self.previousRotateLoc = location;
            self.touchCount = (int)pan.numberOfTouches;

        } else if (pan.state == UIGestureRecognizerStateChanged) {
            delta = CGPointMake(location.x - self.previousRotateLoc.x, location.y - self.previousRotateLoc.y);
            self.previousRotateLoc = location;

            if (self.touchCount != (int)pan.numberOfTouches) {
                return;
            }

            SCNMatrix4 rotMat;
            if (self.touchCount == 2) { //2个手指移动
                rotMat = SCNMatrix4MakeTranslation(delta.x * 0.025, delta.y * -0.025, 0);
            } else { //1个手指旋转
                SCNMatrix4 rotMatX = SCNMatrix4Rotate(SCNMatrix4Identity, (1.0f/100) * delta.y , 1, 0, 0);
                SCNMatrix4 rotMatY = SCNMatrix4Rotate(SCNMatrix4Identity, (1.0f/100) * delta.x , 0, 1, 0);
                rotMat = SCNMatrix4Mult(rotMatX, rotMatY);
            }

            //get the translation matrix of the child node
            SCNMatrix4 transMat = SCNMatrix4MakeTranslation(geometryNode.position.x, geometryNode.position.y, geometryNode.position.z);
            //move the child node to the origin of its parent (but keep its local rotation)
            geometryNode.transform = SCNMatrix4Mult(geometryNode.transform, SCNMatrix4Invert(transMat));
            //apply the "rotation" of the parent node extra
            SCNMatrix4 parentNodeTransMat = SCNMatrix4MakeTranslation(geometryNode.parentNode.worldPosition.x, geometryNode.parentNode.worldPosition.y, geometryNode.parentNode.worldPosition.z);
            SCNMatrix4 parentNodeMatWOTrans = SCNMatrix4Mult(geometryNode.parentNode.worldTransform, SCNMatrix4Invert(parentNodeTransMat));
            geometryNode.transform = SCNMatrix4Mult(geometryNode.transform, parentNodeMatWOTrans);

            //apply the inverse "rotation" of the current camera extra
            SCNMatrix4 camorbitNodeTransMat = SCNMatrix4MakeTranslation(self.scnView.pointOfView.worldPosition.x, self.scnView.pointOfView.worldPosition.y, self.scnView.pointOfView.worldPosition.z);
            SCNMatrix4 camorbitNodeMatWOTrans = SCNMatrix4Mult(self.scnView.pointOfView.worldTransform, SCNMatrix4Invert(camorbitNodeTransMat));
            geometryNode.transform = SCNMatrix4Mult(geometryNode.transform,SCNMatrix4Invert(camorbitNodeMatWOTrans));
            //perform the rotation based on the pan gesture
            geometryNode.transform = SCNMatrix4Mult(geometryNode.transform, rotMat);
            //remove the extra "rotation" of the current camera
            geometryNode.transform = SCNMatrix4Mult(geometryNode.transform, camorbitNodeMatWOTrans);
            //remove the extra "rotation" of the parent node (we can use the transform because parent node is at world origin)
            geometryNode.transform = SCNMatrix4Mult(geometryNode.transform,SCNMatrix4Invert(parentNodeMatWOTrans));
            //add back the local translation mat
            geometryNode.transform = SCNMatrix4Mult(geometryNode.transform, transMat);
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

    /*
    // 检查触发了哪些节点
    CGPoint p = [rotation locationInView:self.scnView];
    NSArray *hitResults = [self.scnView hitTest:p options:nil];

    // 保证至少有一个节点被触发
    if([hitResults count] > 0){
        // 检索触发的第一个对象
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        SCNNode *geometryNode = result.node;
        [self rotate:rotation geometryNode:geometryNode];
    }
    */
}

//单指 翻转、旋转，方式一
//- (void)rotate:(UIPanGestureRecognizer *)pan geometryNode:(SCNNode *)geometryNode{
//
//    CGPoint translation = [pan translationInView:pan.view];
//    CGFloat newAngleX = (CGFloat)(translation.y)*(CGFloat)(M_PI)/180.0;
//    newAngleX += self.currentAngleX;
//    CGFloat newAngleY = (CGFloat)(translation.x)*(CGFloat)(M_PI)/180.0;
//    newAngleY += self.currentAngleY;
//    geometryNode.eulerAngles = SCNVector3Make(newAngleX, newAngleY, 0);
//
//    if (pan.state == UIGestureRecognizerStateEnded) {
//        self.currentAngleX = newAngleX;
//        self.currentAngleY = newAngleY;
//    }
//}

//单指 翻转、旋转，方式二
//- (void)rotate2:(UIPanGestureRecognizer *)pan geometryNode:(SCNNode *)geometryNode{
//
//    CGPoint translation = [pan translationInView:pan.view];
//    CGFloat x = (CGFloat)(translation.x);
//    CGFloat y = (CGFloat)(-translation.y);
//
//    CGFloat anglePan = sqrt(pow(x,2) + pow(y,2)) * (CGFloat)(M_PI)/180.0;
//    SCNVector4 rotationVector = SCNVector4Make(-y, x, 0, anglePan);
//    geometryNode.rotation = rotationVector;
//
//    if (pan.state == UIGestureRecognizerStateEnded) {
//        SCNMatrix4 currentPivot = geometryNode.pivot;
//        SCNMatrix4 changePivot = SCNMatrix4Invert(geometryNode.transform);
//        geometryNode.pivot = SCNMatrix4Mult(changePivot, currentPivot);
//        geometryNode.transform = SCNMatrix4Identity;
//    }
//}

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
