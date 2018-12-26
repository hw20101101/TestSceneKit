//
//  RootViewController.m
//  TestSceneKit
//
//  Created by 快摇002 on 2018/12/19.
//  Copyright © 2018 aiitec. All rights reserved.
//

#import "RootViewController.h"
#import "TestViewController.h"
#import "LightViewController.h"
#import "ActionViewController.h"
#import "GeometryViewController.h"
#import "ChangeCameraViewController.h"
#import "ConstraintViewController.h"
#import "ForceViewController.h"
#import "ChangeSceneViewController.h"
#import "GameViewController.h"

@interface RootViewController ()

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"DEMO", @"测试光源", @"动画行为", @"几何体", @"切换视角", @"反向运动约束", @"力的使用", @"切换场景"];
    }
    return _dataSource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIViewController *vc;
    NSString *title = self.dataSource[indexPath.row];

    if ([title isEqualToString:@"DEMO"]) {
        vc = [[GameViewController alloc] init];

    } else if ([title isEqualToString:@"测试光源"]) {
        vc = [[LightViewController alloc] init];

    } else if ([title isEqualToString:@"动画行为"]) {
        vc = [[ActionViewController alloc] init];

    } else if ([title isEqualToString:@"几何体"]) {
        vc = [[GeometryViewController alloc] init];
        
    } else if ([title isEqualToString:@"切换视角"]) {
        vc = [[ChangeCameraViewController alloc] init];
        
    } else if ([title isEqualToString:@"反向运动约束"]) {
        vc = [[ConstraintViewController alloc] init];

    } else if ([title isEqualToString:@"力的使用"]) {
        vc = [[ForceViewController alloc] init];

    } else if ([title isEqualToString:@"切换场景"]){
        vc = [[ChangeSceneViewController alloc] init];
    }

    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
