//
//  RingSendBox.h
//  Ring
//
//  Created by Medpats on 1/15/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@protocol RingSendBoxDeledate
- (void)sendWithText:(NSString *)text;
- (void)sendWithImage:(UIImage *)image andLocalUrl:(NSString *)url;
- (void)presentModalViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion;
@end

@interface RingSendBox : UIView
@property (weak, nonatomic) IBOutlet UITextField *messageBox;
@property (weak, nonatomic) id<RingSendBoxDeledate> delegate;

+ (RingSendBox *)initSendBox;
- (void)resetFields;
@end
