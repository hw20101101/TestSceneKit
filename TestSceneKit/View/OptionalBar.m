//
//  OptionalBar.m
//  TestSceneKit
//
//  Created by 快摇002 on 2018/12/26.
//  Copyright © 2018 aiitec. All rights reserved.
//

#import "OptionalBar.h"

@implementation OptionalBar

#pragma mark - 点击场景按钮
- (IBAction)senceBtnOnClick:(id)sender {
    if (self.senceBtnAction) {
        self.senceBtnAction();
    }
}

#pragma mark - 点击产品按钮
- (IBAction)productBtnOnClick:(id)sender {
    if (self.productBtnAction) {
        self.productBtnAction();
    }
}

#pragma mark - 点击亮度按钮
- (IBAction)brightnessBtnOnClick:(id)sender {

}

#pragma mark - 点击保存按钮
- (IBAction)saveBtnOnClick:(id)sender {

}

@end
