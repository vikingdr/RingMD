//
//  UIButton+Utility.h
//  Ring
//
//  Created by Tan Nguyen on 11/15/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Utility)
+ (UIButton *)ringEditButton;
+ (UIButton *)circleButton;
- (void)flatButtonWithGreenColor;
+ (UIButton *)nextButton;
+ (UIButton *)ringButtonWithText:(NSString *)text;
@end
