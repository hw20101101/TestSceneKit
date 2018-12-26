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
#import "OptionalBar.h"

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
    [self createSenceView];
    [self createScene];
    [self createGeometry];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
}

- (void)rightBarButtonItemAction{
    OptionalBar *optionalBar = [[NSBundle mainBundle] loadNibNamed:@"OptionalBar" owner:nil options:nil][0];
    optionalBar.frame = CGRectMake(20, 40, 220, 31);
    [self.view addSubview:optionalBar];

    __weak typeof(self)weakSelf = self;
    optionalBar.senceBtnAction = ^{
        //更换场景图片
        weakSelf.scene.background.contents = @"lakes.png";
    };

    optionalBar.productBtnAction = ^{

    };
}

- (void)createSenceView{

    // retrieve the SCNView
    self.scnView = [[SCNView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scnView];

    //设置默认光源
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
}

- (void)createGeometry{

    //创建正方体
    SCNBox *box = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
    box.firstMaterial.diffuse.contents = @"a0_demo.png";//注意图片路径
    SCNNode *boxNode = [SCNNode node];
    boxNode.geometry = box;
    boxNode.position = SCNVector3Make(0, 0, 0);
    [self.scnView.scene.rootNode addChildNode:boxNode];

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
    self.scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];//注意文件路径
    self.scene.background.contents = @"sky.png";//也可以在.scn文件中设置
    // set the scene to the view
    self.scnView.scene = self.scene;

    // 创建相机节点
    self.cameraNode = [SCNNode node];
    //给节点添加名字
    self.cameraNode.name = @"camera";
    self.cameraNode.camera = [SCNCamera camera];
    // place the camera
    self.cameraNode.position = SCNVector3Make(0, 0, 35);
    [self.scene.rootNode addChildNode:self.cameraNode];
}

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
