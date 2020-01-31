//
//  RingPurchaseViewController.m
//  Ring
//
//  Created by Medpats on 5/13/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingPurchaseViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "RingPaymentPurchaseView.h"

@interface RingPurchaseViewController ()
@property (weak, nonatomic) IBOutlet RingPaymentPurchaseView *purchaseView;

@end

@implementation RingPurchaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.purchaseView loadDataFromCard:self.card requestId:self.request.callRequestId];
}
@end
