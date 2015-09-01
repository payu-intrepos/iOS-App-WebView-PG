//
//  PaymentViewController.m
//  SampleAppUsingWebView
//
//  Created by Umang Arya on 05/08/15.
//  Copyright (c) 2015 Umang Arya. All rights reserved.
//

#import "PaymentViewController.h"   

@interface PaymentViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webView loadRequest:_request];
    _webView.delegate = self;
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self.activityIndicator startAnimating];

    return true;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
