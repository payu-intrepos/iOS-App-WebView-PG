//
//  PayUSURLFURLResponseHandler.m
//  SampleAppUsingWebView
//
//  Created by Umang Arya on 23/01/20.
//  Copyright © 2020 Umang Arya. All rights reserved.
//

#import "PayUSURLFURLResponseHandler.h"

@interface PayUSURLFURLResponseHandler() <JSCallBackToObjCSDKForSURLFURL>

@property BOOL delegateMethodCalled;
@property (weak,nonatomic) JSContext *js;


@end

@implementation PayUSURLFURLResponseHandler 

-(instancetype)init{
    self = [super init];
    if (self) {
        self.delegateMethodCalled = false;
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webview{
    if (!self.delegateMethodCalled) {
        self.js = [webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        id val = self.js[@"PayU"];
        if ([val isUndefined]) {
            __weak typeof(self) weakself = self;
            self.js[@"PayU"] = weakself;
        }
        [self.js evaluateScript:@"payu_merchant_js_callback();"];
    }
}

- (void)onFailure:(nonnull id)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(PayUFURLResponse:)])
        {
            [self.delegate PayUFURLResponse:response];
            self.delegateMethodCalled = true;
        }
    });
}

- (void)onSuccess:(nonnull id)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(PayUSURLResponse:)])
        {
            [self.delegate PayUSURLResponse:response];
            self.delegateMethodCalled = true;
        }
    });
}

@end
