//
//  PaymentViewController.m
//  SampleAppUsingWebView
//
//  Created by Umang Arya on 05/08/15.
//  Copyright (c) 2015 Umang Arya. All rights reserved.
//

#import "PaymentViewController.h"
#import "PayUSURLFURLResponseHandler.h"

@interface PaymentViewController ()<UIWebViewDelegate, PayUSURLFURLResponseDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) PayUSURLFURLResponseHandler *sURLFURLHandler;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webView loadRequest:_request];
    _webView.delegate = self;
    [self configurePayUSDKResponse];
}

-(void)configurePayUSDKResponse{
    self.sURLFURLHandler = [[PayUSURLFURLResponseHandler alloc] init];
    self.sURLFURLHandler.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.sURLFURLHandler webViewDidFinishLoad:webView];
}

#pragma mark - PayUSURLFURLResponseDelegate Handling

- (void)PayUFURLResponse:(nonnull id)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(PayUFURLResponse:)])
        {
            [self.delegate PayUFURLResponse:response];
        }
    });
}

- (void)PayUSURLResponse:(nonnull id)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(PayUSURLResponse:)])
        {
            [self.delegate PayUSURLResponse:response];
        }
    });
}

@end
