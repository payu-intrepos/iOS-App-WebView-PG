//
//  PayUSURLFURLResponseHandler.h
//  SampleAppUsingWebView
//
//  Created by Umang Arya on 23/01/20.
//  Copyright © 2020 Umang Arya. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JavaScriptCore;
@import WebKit;

NS_ASSUME_NONNULL_BEGIN

/*!
 * This protocol declares the methods which we get from JS callbacks.
 */
@protocol JSCallBackToObjCSDKForSURLFURL <JSExport>

/*!
 * This method is called from SURL JS when transaction is success.
 * @param [response]                                    [id type]
 */
-(void)onSuccess:(id)response;

/*!
 * This method is called from FURL JS when transaction fails.
 * @param [response]                                    [id type]
 */
-(void)onFailure:(id)response;

@end


/*!
 * This protocol declares the methods which give callback to merchant's app.
 */
@protocol  PayUSURLFURLResponseDelegate <NSObject>

/*!
 * This method is gives callback for transaction success.
 * @param [response]   [id type]
 */
-(void)PayUSURLResponse:(id)response;

/*!
 * This method is gives callback for transaction fail.
 * @param [response]   [id type]
 */
-(void)PayUFURLResponse:(id)response;

@end

@interface PayUSURLFURLResponseHandler : NSObject

-(void)webViewDidFinishLoad:(UIWebView *) webview;

@property (nonatomic,weak) id <PayUSURLFURLResponseDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
