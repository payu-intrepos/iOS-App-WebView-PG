//
//  ViewController.m
//  SampleAppUsingWebView
//
//  Created by Umang Arya on 05/08/15.
//  Copyright (c) 2015 Umang Arya. All rights reserved.
//

#import "ViewController.h"
#import "PaymentViewController.h"
#import "Utils.h"

//#define KEY             @"gtKFFx"
//#define KEY             @"smsplus"
#define KEY             @"0MQaQP"
#define AMOUNT          @"10.5"
#define PRODUCTINFO     @"Nokia"
#define FIRSTNAME       @"Ram"
#define EMAIL           @"email@testsdk.com"
#define PHONE           @"9876543210"
#define FURL            @"https://payu.herokuapp.com/ios_failure"
#define SURL            @"https://payu.herokuapp.com/ios_success"
#define USERCREDENTIAL  @"ra:ra"
#define OFFERKEY        @"test123@6622"

#define URL             @"https://secure.payu.in/_payment"  // prod URL
//#define URL             @"https://mobiletest.payu.in/_payment"  // test URL

@interface ViewController ()<PayUSURLFURLResponseDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnPayNow;
@property (strong, nonatomic) NSString *transactionID;
@property (strong, nonatomic) NSString *paymentHash;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    [self initialSetup];
}

-(void)initialSetup {
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    self.transactionID = [Utils randomStringWithLength:10];
    
    self.btnPayNow.enabled = false;
    
    NSString *postDataForHash = [NSString stringWithFormat:@"key=%@&hash=%@&email=%@&amount=%@&firstname=%@&txnid=%@&user_credentials=%@&productinfo=%@&phone=%@&udf1=&udf2=&udf3=&udf4=&udf5=",KEY,@"hash",EMAIL,AMOUNT,FIRSTNAME,self.transactionID,USERCREDENTIAL,PRODUCTINFO,PHONE];
    
    [Utils getPaymentHash:postDataForHash withCompletionBlock:^(NSString * _Nonnull paymentHash) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.paymentHash = paymentHash;
            self.btnPayNow.enabled = true;
            [self.activityIndicator stopAnimating];
        });
    }];
}

- (NSMutableURLRequest *) getPayURequestObject {
    NSString *postData = [NSString new];
    
    NSURL *restURL = [NSURL new];
    NSMutableURLRequest *request;
    restURL = [NSURL URLWithString:URL];
    request = [NSMutableURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    request.HTTPMethod = @"POST";
    /* Format to generate hash Value
     hashValue = @"key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5||||||SALT";
     */
    postData = [NSString stringWithFormat: @"key=%@&email=%@&amount=%@&firstname=%@&txnid=%@&user_credentials=%@&productinfo=%@&phone=%@&surl=%@&furl=%@&offer_key=%@&hash=%@", KEY, EMAIL, AMOUNT, FIRSTNAME, self.transactionID, USERCREDENTIAL, PRODUCTINFO, PHONE, SURL, FURL, OFFERKEY, self.paymentHash];
    NSLog(@"Post Data = %@",postData);
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - IBAction Handling

- (IBAction)payButtonClicked:(id)sender {
    PaymentViewController *PVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PVC"];
    PVC.request = [self getPayURequestObject];
    PVC.delegate = self;
    [self.navigationController pushViewController:PVC animated:true];
}

#pragma mark - PayUSURLFURLResponseDelegate Handling

- (void)PayUFURLResponse:(id)response {
    [self.navigationController popViewControllerAnimated:true];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"FURL Response"
                                                                   message:response
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)PayUSURLResponse:(id)response {
    [self.navigationController popViewControllerAnimated:true];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"SURL Response"
                                                                   message:response
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end


