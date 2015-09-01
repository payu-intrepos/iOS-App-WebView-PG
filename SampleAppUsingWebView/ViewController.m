//
//  ViewController.m
//  SampleAppUsingWebView
//
//  Created by Umang Arya on 05/08/15.
//  Copyright (c) 2015 Umang Arya. All rights reserved.
//

#import "ViewController.h"
#import "PaymentViewController.h"

#define KEY             @"gtKFFx"
//#define KEY             @"smsplus"
//#define KEY             @"0MQaQP"
#define AMOUNT          @"10.5"
#define PRODUCTINFO     @"Nokia"
#define FIRSTNAME       @"Ram"
#define EMAIL           @"email@testsdk.com"
#define PHONE           @"9876543210"
#define FURL            @"https://dl.dropboxusercontent.com/s/h6m11xr93mxhfvf/Failure_iOS.html"
#define SURL            @"https://dl.dropboxusercontent.com/s/y911hgtgdkkiy0w/success_iOS.html"
#define USERCREDENTIAL  @"ra:ra"
#define OFFERKEY        @"test123@6622"


@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *PayButton;
@property (strong, nonatomic) NSMutableURLRequest *req;
@property (strong, nonatomic) NSString *TxnID;
@property (strong, nonatomic) NSString *PaymentHash;

typedef void (^urlRequestCompletionBlock)(NSURLResponse *response, NSData *data, NSError *connectionError);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    self.PayButton.enabled = false;
    self.TxnID = [self randomStringWithLength:15];
    NSLog(@"Transaction ID = %@",self.TxnID);
    [self generateHashFromServer:nil withCompletionBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Payment Hash = %@",self.PaymentHash);
            self.PayButton.enabled = true;
            [self.activityIndicator stopAnimating];
        });
    }];
}

- (IBAction)payButtonClicked:(id)sender {
    
    NSString *postData = [[NSString alloc]init];
    
    NSURL *restURL = [NSURL new];
    //restURL = [NSURL URLWithString:@"https://secure.payu.in/_payment"];
    restURL = [NSURL URLWithString:@"https://mobiletest.payu.in/_payment"];
    self.req=[NSMutableURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    self.req.HTTPMethod = @"POST";
    /* Format to generate hash Value
     hashValue = @"key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5||||||SALT";
    */
    postData = [NSString stringWithFormat:@"key=%@&email=%@&amount=%@&firstname=%@&txnid=%@&user_credentials=%@&productinfo=%@&phone=%@&surl=%@&furl=%@&offer_key=%@&hash=%@",KEY,EMAIL,AMOUNT,FIRSTNAME,self.TxnID,USERCREDENTIAL,PRODUCTINFO,PHONE,SURL,FURL,OFFERKEY,self.PaymentHash];
    NSLog(@"Post Data = %@",postData);
    [self.req setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.req setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    PaymentViewController *PVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PVC"];
    PVC.request = self.req;
    [self.navigationController pushViewController:PVC animated:true];
//    [self presentViewController:PVC animated:true completion:nil];
    
}

// Method to generate random Transaction ID

-(NSString *) randomStringWithLength:(int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length])]];
    }
    
    return randomString;
}

// Method to get hash from server

- (void) generateHashFromServer:(NSDictionary *) paramDict withCompletionBlock:(urlRequestCompletionBlock)completionBlock{
    
    void(^serverResponseForHashGenerationCallback)(NSURLResponse *response, NSData *data, NSError *error) = completionBlock;
    
    NSURL *restURL = [NSURL URLWithString:@"https://payu.herokuapp.com/get_hash"];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:restURL
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
    theRequest.HTTPMethod = @"POST";
    NSString *postData = [NSString stringWithFormat:@"key=%@&hash=%@&email=%@&amount=%@&firstname=%@&txnid=%@&user_credentials=%@&productinfo=%@&phone=%@&udf1=&udf2=&udf3=&udf4=&udf5=",KEY,@"hash",EMAIL,AMOUNT,FIRSTNAME,self.TxnID,USERCREDENTIAL,PRODUCTINFO,PHONE];
    NSLog(@"Hash generation Post Data = %@",postData);
    
    //set request content type we MUST set this value.
    [theRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [theRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:theRequest queue:networkQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *errorJson = nil;
        NSDictionary *hashDict = [NSDictionary new];
        hashDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
        self.PaymentHash = [hashDict valueForKey:@"payment_hash"];
        NSLog(@"Payment Hash = %@",self.PaymentHash);
        serverResponseForHashGenerationCallback(response, data,connectionError);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
