//
//  Utils.h
//  SampleAppUsingWebView
//
//  Created by Umang Arya on 23/01/20.
//  Copyright © 2020 Umang Arya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (void) getPaymentHash:(NSString *) postData withCompletionBlock:(void (^ __nullable)(NSString *paymentHash)) completion;

+ (NSString *) randomStringWithLength:(int) len;

@end

NS_ASSUME_NONNULL_END
