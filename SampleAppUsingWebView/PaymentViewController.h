//
//  PaymentViewController.h
//  SampleAppUsingWebView
//
//  Created by Umang Arya on 05/08/15.
//  Copyright (c) 2015 Umang Arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayUSURLFURLResponseHandler.h"

@interface PaymentViewController : UIViewController

@property (strong,nonatomic) NSMutableURLRequest *request;
@property (weak, nonatomic) id<PayUSURLFURLResponseDelegate> delegate;

@end
