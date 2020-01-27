//
//  Utils.m
//  SampleAppUsingWebView
//
//  Created by Umang Arya on 23/01/20.
//  Copyright © 2020 Umang Arya. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void) getPaymentHash:(NSString *) postData withCompletionBlock:(void (^ __nullable)(NSString *paymentHash)) completion{
    
    NSURL *restURL = [NSURL URLWithString:@"https://payu.herokuapp.com/get_hash"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:restURL
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:60.0];
    request.HTTPMethod = @"POST";
    NSLog(@"Hash generation Post Data = %@",postData);
    
    //set request content type we MUST set this value.
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSString *paymentHash;
        if (httpResponse.statusCode >=200 && httpResponse.statusCode <=299) {
            NSDictionary *hashDict = [NSDictionary new];
            hashDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            paymentHash = [hashDict valueForKey:@"payment_hash"];
        }
        completion(paymentHash);
    }];
    [dataTask resume];
}


+ (NSString *) randomStringWithLength:(int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length])]];
    }
    
    return randomString;
}

@end
