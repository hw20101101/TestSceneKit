//
//  OptionalBar.h
//  TestSceneKit
//
//  Created by 快摇002 on 2018/12/26.
//  Copyright © 2018 aiitec. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OptionalBar : UIView

@property (copy, nonatomic) void (^senceBtnAction) (void);

@property (copy, nonatomic) void (^productBtnAction) (void);

@end

NS_ASSUME_NONNULL_END
