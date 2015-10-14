//
//  ViewController.m
//  PayeezyClient
//
//  Created by First Data Corporation on 5/28/2015.
//  Copyright (c) 2015 First Data Corporation. All rights reserved.
//

#import "ViewController.h"
#import "PayeezySDK.h"


/* 
 Refer developer.payeezy.com = d.payeezy.com = dev portal
 Securing APIKey, token constant values in IOS app :
 http://stackoverflow.com/questions/9448632/best-practices-for-ios-applications-security?rq=1
*/


/* Cert/Demo enviroment for test and integartion */

//#define kEnvironment @"QA"

/* Refer to dev portal -> 'My APIs' page -> app -> API Key */
//#define KApiKey             @"fP0iYUx4oJ8LolKl2LiOT1Zo94mL0IDQ"
//#define KApiKey             @"ehCz1VGlwNeeGcN5LjA5c2nvWKTnEZRn"

/* Refer to dev portal -> 'My APIs' page -> app -> Api Secret */
///#define KApiSecret          @"2b940ece234ee38131e70cc617aa2afa3d7ff8508856917958e7feb3gk289436"

//#define KApiSecret          @"3b940fce234ee38131e70cc617aa2afa3d7ff8508856917958e7feb3ef190448"
/* Refer to dev portal -> 'My Merchants' page -> SANDBOX -> Token */
//#define KToken      @"fdoa-d5i0ree9t1dae7b2i2t34cf102641994c1e55e7cdf4c02b7"

/* use following url to get token (POST) and proceed for transactions */
//#define KURL        @"https://api-cert.payeezy.com/v1/transactions/tokens"

/* use following url to get token (GET) and proceed for transactions */
//#define SURL        @"https://api-cert.payeezy.com/v1/securitytokens?"

/* use following url for transactions */
//#define PURL        @"https://api-qa.payeezy.com/v1/transactions"



/* Cert/Demo enviroment for test and integartion */
#define kEnvironment @"CERT"


/* Refer to dev portal -> 'My APIs' page -> app -> API Key */
#define KApiKey             @"y6pWAJNyJyjGv66IsVuWnklkKUPFbb0a"

/* Refer to dev portal -> 'My APIs' page -> app -> Api Secret */
#define KApiSecret          @"86fbae7030253af3cd15faef2a1f4b67353e41fb6799f576b5093ae52901e6f7"

/* Refer to dev portal -> 'My Merchants' page -> SANDBOX -> Token */
#define KToken      @"fdoa-d5i0ree9t1dae7b2i2t34cf102641994c1e55e7cdf4c02b7"

/* use following url to get token (POST) and proceed for transactions */
#define KURL        @"https://api-cert.payeezy.com/v1/transactions/tokens"

/* use following url to get token (GET) and proceed for transactions */
#define SURL        @"https://api-cert.payeezy.com/v1/securitytokens?"

/* use following url for transactions */
#define PURL        @"https://api-cert.payeezy.com/v1/transactions"


@interface ViewController ()

@end

@implementation ViewController{
}


@synthesize carditCardType;
@synthesize icredit_card;
@synthesize items = _items;


@synthesize  fdTokenValue;

/*!
 *
 * \param
 * \returns
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.icredit_card = @{
                          @"type":@"American Express",
                          @"cardholder_name":@"John Smith",
                          @"card_number":@"373953192351004",
                          @"exp_date":@"0416",
                          @"cvv":@"1234"
                          };
    
}

/*!
 *
 * \param
 * \returns
 */
- (void)viewDidAppear:(BOOL)animated{

}

/*!
 *
 * \param
 * \returns
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIPickerView DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.items count];
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}





/*!
 * sample transaction - getFDToken using credit card
 * \param id
 * \returns IBAction
 */
// test case 4
- (IBAction)postTokenizeCreditCards:(id)sender {
    
         // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
    
        NSDictionary* tokenizer = @{
                                      @"type":@"FDToken",  // you can change to Amex/Discover/Master Card here
                                      @"auth":@"false",
                                      @"ta_token":@"NOIW"   // to fetch ta_token please refer developer.payeezy
                                    };
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        if(![self.wait4Response isAnimating]){
            [self.wait4Response startAnimating];
        }
    
        [myClient submitPostFDTokenForCreditCard:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] type:tokenizer[@"type"] auth:tokenizer[@"auth"] ta_token:tokenizer[@"ta_token"] completion:^(NSDictionary *dict, NSError *error)
       {
           if([self.wait4Response isAnimating]){
            [self.wait4Response stopAnimating];
               
        }
        

        NSString *authStatusMessage = nil;
        
        NSDictionary *result = [dict objectForKey:@"token"];
        
        authStatusMessage = [NSString
                             stringWithFormat:@"Transaction details\r status:%@ \r  correlation id:%@ \r Tokenized Value:%@ \r type:%@  ", [dict objectForKey:@"status"],[dict objectForKey:@"correlation_id"],
                             [result objectForKey:@"value"],
                             [dict objectForKey:@"type"]];
        
        self.fdTokenValue =[result objectForKey:@"value"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                        message:authStatusMessage delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }];
   
}

/*!
 * sample transaction - getFDToken using credit card
 * \param id
 * \returns IBAction
 */
// test case 4
- (IBAction)getTokenizeCreditCards:(id)sender {
    
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    
    NSDictionary* tokenizer = @{
                                @"type":@"FDToken",  // you can change to Amex/Discover/Master Card here
                                @"auth":@"false",
                                @"ta_token":@"NOIW",
                                @"js_security_key":@"js-6125e57ce5c46e10087a545b9e9d7354c23e1a1670d9e9c7",  // you can change it to object variable as you have apikey
                                @"callback":@"Payeezy.callback"
                                };
   
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:SURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient submitGetFDTokenForCreditCard:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] type:tokenizer[@"type"] auth:tokenizer[@"auth"] ta_token:tokenizer[@"ta_token"] js_security_key:tokenizer[@"js_security_key"] callback:tokenizer[@"callback"] completion:^(NSString *dict, NSError *error)
     {
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
             
         }
        
         // parse the response  substring to read = Payeezy.callback( .... )
         NSString *result = nil;
         NSString *authStatusMessage = nil;
         
         
         // Determine "<div>" location
         NSRange divRange = [dict rangeOfString:@"(" options:NSCaseInsensitiveSearch];
         if (divRange.location != NSNotFound)
         {
             // Determine "</div>" location according to "<div>" location
             NSRange endDivRange;
             
             endDivRange.location = divRange.length + divRange.location;
             endDivRange.length   = [dict length] - endDivRange.location;
             endDivRange = [dict rangeOfString:@")" options:NSCaseInsensitiveSearch range:endDivRange];
             
             if (endDivRange.location != NSNotFound)
             {
                 // Tags found: retrieve string between them
                 divRange.location += divRange.length;
                 divRange.length = endDivRange.location - divRange.location;
                 
                 result = [dict substringWithRange:divRange];
             }
         }
         
         //parse login end
         
         // convert json string to NSDictionary
         
         NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         NSDictionary *results = [json objectForKey:@"results"];
         
         
         NSDictionary *tokenKey = [results objectForKey:@"token"];
         
       //  NSLog(@"results ::::: %@",tokenKey);
         
         self.fdTokenValue =[tokenKey objectForKey:@"value"];

        // NSLog(@"results ::::: %@",self.fdTokenValue);
         
         authStatusMessage = [NSString
                              stringWithFormat:@"Transaction details\r status:%@ \r  correlation id:%@ \r Tokenized Value:%@ \r type:%@  ", [results objectForKey:@"status"],[results objectForKey:@"correlation_id"],
                              [tokenKey objectForKey:@"value"],
                              [tokenKey objectForKey:@"type"]];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         [alert show];

     }];
    
}




/*!
 * Sample method for authorize Void using visa card
 * \param id
 * \returns IBAction
 */

- (IBAction)authorizeVoidTransactionCVV:(id)sender {
    
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:self.fdTokenValue cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"bank_resp_code"],
                                  [dict objectForKey:@"transaction_status"] ];
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
              
             [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"]  :@"200"];
                 
             }
            }
            else
            {
                authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                            message:authStatusMessage delegate:self
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    
}

/*!
 * Authorize Amt0 Visa Transaction CVV
 * \param id
 * \returns IBAction
 */
// test case 5
- (IBAction)authorizeAmt0TransactionCVV:(id)sender {
    
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:self.fdTokenValue cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"0" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"bank_resp_code"],
                                  [dict objectForKey:@"transaction_status"] ];
             }
             else
             {
                 authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
             }
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                             message:authStatusMessage delegate:self
                                                   cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:nil];
             [alert show];
         }];
    
}



/*!
 * Sample method for purchase Refund using visa card
 * \param id
 * \returns IBAction
 */
// test case 3
- (IBAction)purchaseRefundTransactionCVV:(id)sender {
    
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:self.fdTokenValue cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"purchase" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"bank_resp_code"],
                                  [dict objectForKey:@"transaction_status"] ];
            
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 
          [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"refund" :[dict objectForKey:@"transaction_id"] :@"200"];
             
             }
        }
        else
        {
            authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                        message:authStatusMessage delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
}


// test case 2
// Sample method for purchase Void using Discover card

- (IBAction)purchaseVoidTransactionCVV:(id)sender{
    
        // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
    
       PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
        if(![self.wait4Response isAnimating]){
            [self.wait4Response startAnimating];
        }
    
      [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:self.fdTokenValue cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"purchase" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
        {
           
           if([self.wait4Response isAnimating]){
               [self.wait4Response stopAnimating];
            }
           
        NSString *authStatusMessage = nil;
        
        if (error == nil)
        {
            authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                 [dict objectForKey:@"transaction_type"],
                                 [dict objectForKey:@"transaction_tag"],
                                 [dict objectForKey:@"correlation_id"],
                                 [dict objectForKey:@"bank_resp_code"],
                                 [dict objectForKey:@"transaction_status"] ];
            NSLog(@"authStatusMessage: %@",authStatusMessage);
            // calling void method here and pasing required parameneters
            if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
            [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :@"200"];
            }
           
            
        }
        else
        {
            authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                        message:authStatusMessage delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
       }];
}


// Sample method for purchase Void using Discover card test case 1

- (IBAction)authorizeVoidTransaction:(id)sender{
    

        
        // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:KURL];
        
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token"
         
                                                      completion:^(NSDictionary *dict, NSError *error) {
                                                          
                                                          NSString *authStatusMessage = nil;
                                                          
                                                          if (error == nil)
                                                          {
                                                              authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",
                                                                                   [dict objectForKey:@"transaction_type"],
                                                                                   [dict objectForKey:@"transaction_id"],
                                                                                   [dict objectForKey:@"transaction_tag"],
                                                                                   [dict objectForKey:@"correlation_id"],
                                                                                   [dict objectForKey:@"bank_resp_code"]];
                                                              
                                                              // calling void method here and pasing required parameneters
                                                              if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                                                  
                                                              [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :@"200"];
                                                              }
                                                           
                                                              
                                                          }
                                                          else
                                                          {
                                                              authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                          }
                                                          
                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                                                          message:authStatusMessage delegate:self
                                                                                                cancelButtonTitle:@"Dismiss"
                                                                                                otherButtonTitles:nil];
                                                          [alert show];
                                                      }];
    
}


/*!
 * sample transaction - authorize Capture using visa
 * \param id
 * \returns IBAction
 */
// test case 4
- (IBAction)authorizeCaptureTransactionCVV:(id)sender {
    
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:self.fdTokenValue cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"bank_resp_code"],
                                  [dict objectForKey:@"transaction_status"] ];
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 
             [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"capture" :[dict objectForKey:@"transaction_id"] :@"200"];
             }
             
         }
         else
         {
             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         [alert show];
     }];
    
}



/*!
 *
 * \param id
 * \returns IBAction
 */
- (IBAction)authorizeVoidTransactionAmex:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:KURL];
        
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token"
                                                       completion:^(NSDictionary *dict, NSError *error) {
                                                           
                                                           NSString *authStatusMessage = nil;
                                                           
                                                           if (error == nil)
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",
                                                                                    [dict objectForKey:@"transaction_type"],
                                                                                    [dict objectForKey:@"transaction_id"],
                                                                                    [dict objectForKey:@"transaction_tag"],
                                                                                    [dict objectForKey:@"correlation_id"],
                                                                                    [dict objectForKey:@"bank_resp_code"]];
                                                               
                                                               [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :amount];
                                                           }
                                                           else
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                           }
                                                           
                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                                                           message:authStatusMessage delegate:self
                                                                                                 cancelButtonTitle:@"Dismiss"
                                                                                                 otherButtonTitles:nil];
                                                           [alert show];
                                                       }];
    }
}

/*!
 *
 * \param id
 * \returns IBAction
 */

- (IBAction)authorizeRefundTransactionDiscover:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:KURL];
        
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token"
         
                                                       completion:^(NSDictionary *dict, NSError *error) {
                                                           
                                                           NSString *authStatusMessage = nil;
                                                           
                                                           if (error == nil)
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",
                                                                                    [dict objectForKey:@"transaction_type"],
                                                                                    [dict objectForKey:@"transaction_id"],
                                                                                    [dict objectForKey:@"transaction_tag"],
                                                                                    [dict objectForKey:@"correlation_id"],
                                                                                    [dict objectForKey:@"bank_resp_code"]];
                                                               [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"refund" :[dict objectForKey:@"transaction_id"] :amount];
                                                           }
                                                           else
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                           }
                                                           
                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                                                           message:authStatusMessage delegate:self
                                                                                                 cancelButtonTitle:@"Dismiss"
                                                                                                 otherButtonTitles:nil];
                                                           [alert show];
                                                       }];
    }
}

/*!
 *
 * \param id
 * \returns IBAction
 */

- (IBAction)purchaseVoidTransaction:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
       
        
        // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"purchase" token_type:@"FDToken" method:@"token"
         
                                                       completion:^(NSDictionary *dict, NSError *error) {
                                                           
                                                           NSString *authStatusMessage = nil;
                                                           
                                                           if (error == nil)
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",
                                                                                    [dict objectForKey:@"transaction_type"],
                                                                                    [dict objectForKey:@"transaction_id"],
                                                                                    [dict objectForKey:@"transaction_tag"],
                                                                                    [dict objectForKey:@"correlation_id"],
                                                                                    [dict objectForKey:@"bank_resp_code"]];                                                           }
                                                           else
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                           }
                                                           
                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                                                           message:authStatusMessage delegate:self
                                                                                                 cancelButtonTitle:@"Dismiss"
                                                                                                 otherButtonTitles:nil];
                                                           [alert show];
                                                       }];
    }
}

/*!
 *
 * \param id
 * \returns IBAction
 */

- (IBAction)purchaseRefundTransaction:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"4012000033330026",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"purchase" token_type:@"FDToken" method:@"token"
         
                                                       completion:^(NSDictionary *dict, NSError *error) {
                                                           
                                                           NSString *authStatusMessage = nil;
                                                           
                                                           if (error == nil)
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",
                                                                                    [dict objectForKey:@"transaction_type"],
                                                                                    [dict objectForKey:@"transaction_id"],
                                                                                    [dict objectForKey:@"transaction_tag"],
                                                                                    [dict objectForKey:@"correlation_id"],
                                                                                    [dict objectForKey:@"bank_resp_code"]];
                                                           }
                                                           else
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                           }
                                                           
                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                                                           message:authStatusMessage delegate:self
                                                                                                 cancelButtonTitle:@"Dismiss"
                                                                                                 otherButtonTitles:nil];
                                                           [alert show];
                                                       }];
    }
}




/*!
 *
 * \param id
 * \returns IBAction
 */

- (IBAction)purchaseRefundSoftDescTransaction:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"4012000033330026",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"purchase" token_type:@"FDToken" method:@"token"
         
                                                               completion:^(NSDictionary *dict, NSError *error) {
                                                                   
                                                                   NSString *authStatusMessage = nil;
                                                                   
                                                                   if (error == nil)
                                                                   {
                                                                       authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",
                                                                                            [dict objectForKey:@"transaction_type"],
                                                                                            [dict objectForKey:@"transaction_id"],
                                                                                            [dict objectForKey:@"transaction_tag"],
                                                                                            [dict objectForKey:@"correlation_id"],
                                                                                            [dict objectForKey:@"bank_resp_code"]];
                                                                   }
                                                                   else
                                                                   {
                                                                       authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                                   }
                                                                   
                                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                                                                   message:authStatusMessage delegate:self
                                                                                                         cancelButtonTitle:@"Dismiss"
                                                                                                         otherButtonTitles:nil];
                                                                   [alert show];
                                                               }];
    }
}

/*!
 * voidTransaction
 * \param
 * \returns
 */
- (IBAction)voidRefundCaptureTransaction:(NSString *)merchant_ref :(NSString *)transaction_tag  :(NSString *)transaction_type   :(NSString *)transaction_id :(NSString *)totalamount  {
  
        // Test credit card info
        NSDictionary* void_transaction = @{
                                           @"merchant_ref": merchant_ref,
                                           @"transaction_tag": transaction_tag,
                                           @"transaction_type": transaction_type,
                                           @"transaction_id": transaction_id,
                                           @"method": @"direct_debit",
                                           @"amount": totalamount,
                                           @"currency_code": @"EUR"
                                           };
        
        NSString *vcrURL = [NSString stringWithFormat: @"%@/%@", PURL, transaction_id];
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:vcrURL];
        
        [myClient submitVoidCaptureRefundTransactionWithCreditCardDetails:void_transaction[@"merchant_ref"] transactiontag:void_transaction[@"transaction_tag"] transactionType:void_transaction[@"transaction_type"] transactionId:void_transaction[@"transaction_id"] paymentMethodType:void_transaction[@"method"] totalAmount:void_transaction[@"amount"] currencyCode:@"EUR" completion:^(NSDictionary *dict, NSError *error) {
            
            NSString *authStatusMessage = nil;
            
            if (error == nil)
            {
                authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rCorrelationID:%@\r Transaction ID:%@\rTransaction Tag:%@",
                                     [dict objectForKey:@"transaction_type"],
                                     [dict objectForKey:@"correlation_id"],
                                     [dict objectForKey:@"transaction_id"],
                                     [dict objectForKey:@"transaction_tag"]];
                 NSLog(@"authStatusMessage: %@",authStatusMessage);
            }
            else
            {
                authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                            message:authStatusMessage delegate:self
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    
}


// test case 7
// Sample method for purchase Void using Discover card

/*
 
 
 {
 "method":"direct_debit",
 "transaction_type":"purchase",
 "amount":"1000",
 "currency_code":"EUR",
 "direct_debit":{
 "iban":"DE34500100600032121604",
 "mandate_ref":"ABCD1234",
 "bic":"PBNKDEFFXXX"
 },
 "billing_address":{
 "name":"P.Kunde",
 "city":"random",
 "country":"GERMANY",
 "email":"Monalisa.mishra@firstdata.com",
 "phone":{
 "type":"Cell",
 "number":"678-468-2665"
 },
 "street":"LangeStr.12",
 "state_province":"LEIPZIG",
 "zip_postal_code":"04103"
 }
 }
 {
 "transaction_tag": "1427462780",
 "transaction_type": "void",
 "method": "direct_debit",
 "amount": "1000",
 "currency_code": "EUR"
 }
 
 */

- (IBAction)purchaseVoidAVSTransactionForGermanDirectDebit:(id)sender{
    
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient processPurchaseCreditTransactionWithAVSDirectDebit:@"1000" pMethod:@"direct_debit" transactiontype:@"purchase"
     currencyCode:@"EUR"  direct_debit_iban:@"DE34500100600032121604" direct_debit_mandate_ref:@"ABCD1234"
     direct_debit_bic:@"PBNKDEFFXXX"  billing_address_name:@"P.Kunde" billing_address_city:@"random"
     billing_address_country:@"GERMANY" billing_address_email:@"support@payeezy.com"   billing_address_phone_type:@"Cell"
     billing_address_phone_number:@"855-799-0790" billing_address_street:@"LangeStr.12"
     billing_address_state_province:@"LEIPZIG"  billing_address_zip_postal_code:@"04103"  completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rTransaction Status:%@ \rType:%@ \rTransaction Tag:%@ \rTransaction ID:%@ \rCorrelation Id:%@\rGateway Response Code:%@ \rGateway Response MSG:%@  ",
                                  [dict objectForKey:@"transaction_status"],
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"transaction_id"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"gateway_resp_code"],
                                  [dict objectForKey:@"gateway_message"] ];
        
         NSLog(@"authStatusMessage: %@",authStatusMessage);
             // calling void method here and pasing required parameneters
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :@"100"];
        
             }
         
             
         }
         else
         {
             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}


// test case 8
// Sample method for purchase Void using Discover card
/*
 {
 "method": "direct_debit",
 "transaction_type": "purchase",
 "amount": "1000",
 "currency_code": "EUR",
 "direct_debit": {
 "iban": "DE34500100600032121604",
 "mandate_ref": "ABCD1234",
 "bic": "PBNKDEFFXXX"
 },
 "billing_address": {
 "name": "P.Kunde",
 "city": "random",
 "country": "GERMANY",
 "email": "Monalisa.mishra@firstdata.com",
 "phone": {
 "type": "Cell",
 "number": "678-468-2665"
 },
 "street": "LangeStr.12",
 "state_province": "LEIPZIG",
 "zip_postal_code": "04103"
 }
 }
 
 {
 "transaction_tag": "1427462780",
 "transaction_type": "refund",
 "method": "direct_debit",
 "amount": "1000",
 "currency_code": "EUR"
 }
 */

- (IBAction)purchaseRefundAVSTransactionForGermanDirectDebit:(id)sender{
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient processPurchaseCreditTransactionWithAVSDirectDebit:@"1000" pMethod:@"direct_debit" transactiontype:@"purchase"
                                                    currencyCode:@"EUR"  direct_debit_iban:@"DE34500100600032121604" direct_debit_mandate_ref:@"ABCD1234"
                                                  direct_debit_bic:@"PBNKDEFFXXX"  billing_address_name:@"P.Kunde" billing_address_city:@"random"
                                         billing_address_country:@"GERMANY" billing_address_email:@"support@payeezy.com"   billing_address_phone_type:@"Cell"
                                    billing_address_phone_number:@"855-799-0790" billing_address_street:@"LangeStr.12"
                                  billing_address_state_province:@"LEIPZIG"  billing_address_zip_postal_code:@"04103"  completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rTransaction Status:%@ \rType:%@ \rTransaction Tag:%@ \rTransaction ID:%@ \rCorrelation Id:%@\rGateway Response Code:%@ \rGateway Response MSG:%@  ",
                                  [dict objectForKey:@"transaction_status"],
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"transaction_id"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"gateway_resp_code"],
                                  [dict objectForKey:@"gateway_message"] ];
             
             NSLog(@"authStatusMessage: %@",authStatusMessage);
             
             // calling void method here and pasing required parameneters
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"refund" :[dict objectForKey:@"transaction_id"] :@"200"];
             }
             
             
         }
         else
         {
             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}

// test case 8
// Sample method for purchase Void using Discover card
/*
 {
 "method": "direct_debit",
 "transaction_type": "credit",
 "amount": "1000",
 "currency_code": "EUR",
 "direct_debit": {
 "iban": "DE34500100600032121604",
 "mandate_ref": "ABCD1234",
 "bic": "PBNKDEFFXXX"
 },
 "billing_address": {
 "name": "P.Kunde",
 "city": "random",
 "country": "GERMANY",
 "email": "Monalisa.mishra@firstdata.com",
 "phone": {
 "type": "Cell",
 "number": "678-468-2665"
 },
 "street": "LangeStr.12",
 "state_province": "LEIPZIG",
 "zip_postal_code": "04103"
 }
 }
 
 {
 "transaction_tag": "1427462780",
 "transaction_type": "void",
 "method": "direct_debit",
 "amount": "1000",
 "currency_code": "EUR"
 }
 */

- (IBAction)creditVoidAVSTransactionForGermanDirectDebit:(id)sender{
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient processPurchaseCreditTransactionWithAVSDirectDebit:@"1000" pMethod:@"direct_debit" transactiontype:@"credit"
                                                    currencyCode:@"EUR"  direct_debit_iban:@"DE34500100600032121604" direct_debit_mandate_ref:@"ABCD1234"
                                                  direct_debit_bic:@"PBNKDEFFXXX"  billing_address_name:@"P.Kunde" billing_address_city:@"random"
                                         billing_address_country:@"GERMANY" billing_address_email:@"support@payeezy.com"   billing_address_phone_type:@"Cell"
                                    billing_address_phone_number:@"855-799-0790" billing_address_street:@"LangeStr.12"
                                  billing_address_state_province:@"LEIPZIG"  billing_address_zip_postal_code:@"04103"  completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rTransaction Status:%@ \rType:%@ \rTransaction Tag:%@ \rTransaction ID:%@ \rCorrelation Id:%@\rGateway Response Code:%@ \rGateway Response MSG:%@  ",
                                  [dict objectForKey:@"transaction_status"],
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"transaction_id"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"gateway_resp_code"],
                                  [dict objectForKey:@"gateway_message"] ];
             
             NSLog(@"authStatusMessage: %@",authStatusMessage);
             
             // calling void method here and pasing required parameneters
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :@"200"];
             }
             
             
         }
         else
         {
             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}


// test case 7
// Sample method for purchase Void using Discover card

/*
 
 
 {
 "method": "direct_debit",
 "transaction_type": "purchase",
 "amount": "1000",
 "currency_code": "EUR",
 "direct_debit": {
 "iban": "DE34500100600032121604",
 "mandate_ref": "ABCD1234",
 "bic": "PBNKDEFFXXX"
 },
 "soft_descriptors":{
 "dba_name":"SoftDesc 1",
 "street":"123 Main Street",
 "region":"NY",
 "mid":"367337278884",
 "mcc":"8812",
 "postal_code":"11375",
 "country_code":"USA",
 "merchant_contact_info":"123 Main street"
 }
 }
 
 {
 "transaction_tag": "1427462780",
 "transaction_type": "void",
 "method": "direct_debit",
 "amount": "1000",
 "currency_code": "EUR"
 }
 
 */

- (IBAction)purchaseVoidSoftDescTransactionForGermanDirectDebit:(id)sender{
    
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient processPurchaseCreditTransactionWithSoftDescDirectDebit:@"1000"
                                                              pMethod:@"direct_debit"
                                                      transactiontype:@"purchase"
                                                         currencyCode:@"EUR"
     
                                                      direct_debit_iban:@"DE34500100600032121604"
                                               direct_debit_mandate_ref:@"ABCD1234"
                                                       direct_debit_bic: @"PBNKDEFFXXX"
     
                                            soft_descriptors_dba_name:@"SoftDesc 1"
                                              soft_descriptors_street:@"123 Main Street"
                                              soft_descriptors_region:@"NY"
                                                 soft_descriptors_mid:@"367337278884"
                                                 soft_descriptors_mcc:@"8812"
                                         soft_descriptors_postal_code:@"11375"
                                        soft_descriptors_country_code:@"USA"
                               soft_descriptors_merchant_contact_info:@"123 Main street"  completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rTransaction Status:%@ \rType:%@ \rTransaction Tag:%@ \rTransaction ID:%@ \rCorrelation Id:%@\rGateway Response Code:%@ \rGateway Response MSG:%@  ",
                                  [dict objectForKey:@"transaction_status"],
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"transaction_id"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"gateway_resp_code"],
                                  [dict objectForKey:@"gateway_message"] ];
             
             NSLog(@"authStatusMessage: %@",authStatusMessage);
             
             // calling void method here and pasing required parameneters
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :@"200"];
             }
             
             
         }
         else
         {
             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}

/**
 
 **/

- (IBAction)purchaseRefundSoftDescTransactionForGermanDirectDebit:(id)sender{
    
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient processPurchaseCreditTransactionWithSoftDescDirectDebit:@"1000"
                                                              pMethod:@"direct_debit"
                                                      transactiontype:@"purchase"
                                                         currencyCode:@"EUR"
     
                                                      direct_debit_iban:@"DE34500100600032121604"
                                               direct_debit_mandate_ref:@"ABCD1234"
                                                       direct_debit_bic: @"PBNKDEFFXXX"
     
                                            soft_descriptors_dba_name:@"SoftDesc 1"
                                              soft_descriptors_street:@"123 Main Street"
                                              soft_descriptors_region:@"NY"
                                                 soft_descriptors_mid:@"367337278884"
                                                 soft_descriptors_mcc:@"8812"
                                         soft_descriptors_postal_code:@"11375"
                                        soft_descriptors_country_code:@"USA"
                               soft_descriptors_merchant_contact_info:@"123 Main street"  completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rTransaction Status:%@ \rType:%@ \rTransaction Tag:%@ \rTransaction ID:%@ \rCorrelation Id:%@\rGateway Response Code:%@ \rGateway Response MSG:%@  ",
                                  [dict objectForKey:@"transaction_status"],
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"transaction_id"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"gateway_resp_code"],
                                  [dict objectForKey:@"gateway_message"] ];
             NSLog(@"authStatusMessage: %@",authStatusMessage);
             
             // calling void method here and pasing required parameneters
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"refund" :[dict objectForKey:@"transaction_id"] :@"200"];
             }
             
             
         }
         else
         {
             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}

- (IBAction)creditVoidSoftDescTransactionForGermanDirectDebit:(id)sender{
    
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient processPurchaseCreditTransactionWithSoftDescDirectDebit:@"1000"
                                                              pMethod:@"direct_debit"
                                                      transactiontype:@"credit"
                                                         currencyCode:@"EUR"
     
                                                      direct_debit_iban:@"DE34500100600032121604"
                                               direct_debit_mandate_ref:@"ABCD1234"
                                                       direct_debit_bic: @"PBNKDEFFXXX"
     
                                            soft_descriptors_dba_name:@"SoftDesc 1"
                                              soft_descriptors_street:@"123 Main Street"
                                              soft_descriptors_region:@"NY"
                                                 soft_descriptors_mid:@"367337278884"
                                                 soft_descriptors_mcc:@"8812"
                                         soft_descriptors_postal_code:@"11375"
                                        soft_descriptors_country_code:@"USA"
                               soft_descriptors_merchant_contact_info:@"123 Main street"  completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rTransaction Status:%@ \rType:%@ \rTransaction Tag:%@ \rTransaction ID:%@ \rCorrelation Id:%@\rGateway Response Code:%@ \rGateway Response MSG:%@  ",
                                [dict objectForKey:@"transaction_status"],
                                [dict objectForKey:@"transaction_type"],
                                [dict objectForKey:@"transaction_tag"],
                                [dict objectForKey:@"transaction_id"],
                                [dict objectForKey:@"correlation_id"],
                                [dict objectForKey:@"gateway_resp_code"],
                                [dict objectForKey:@"gateway_message"] ];
             
             NSLog(@"authStatusMessage: %@",authStatusMessage);
             // calling void method here and pasing required parameneters
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :@"200"];
             }
             
             
         }
         else
         {
             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}


/**
 
 {
 "method": "direct_debit",
 "transaction_type": "purchase",
 "amount": "1000",
 "currency_code": "EUR",
 "direct_debit": {
 "iban": "DE34500100600032121604",
 "mandate_ref": "ABCD1234",
 "bic": "PBNKDEFFXXX"
 },
 "level2":{
 "tax1_amount":10,
 "tax1_number":"2",
 "tax2_amount":5,
 "tax2_number":"3",
 "customer_ref":"customer1"
 },
 "level3":{
 "alt_tax_amount":10,
 "alt_tax_id":"098841111",
 "discount_amount":1,
 "duty_amount":0.5,
 "freight_amount":5,
 "ship_from_zip":"11235",
 "ship_to_address":{
 "city":"New York",
 "state":"NY"
 ,"zip":"11235",
 "country":"USA",
 "email":"abc@firstdata.com",
 "name":"Bob Smith",
 "phone":"212-515-1111",
 "address_1":"123 Main Street",
 "customer_number":"12345"
 },
 "line_items":[
 {"description":"item 1","quantity":"5",
 "commodity_code":"C",
 "discount_amount":1,
 "discount_indicator":"G",
 "gross_net_indicator":"P",
 "line_item_total":10,
 "product_code":"F",
 "tax_amount":5,
 "tax_rate":0.2800000000000000266453525910037569701671600341796875,
 "tax_type":"Federal",
 "unit_cost":1,
 "unit_of_measure":"meters"}]
 }
 }
 
 {
 "transaction_tag": "1437656464",
 "transaction_type": "void",
 "method": "direct_debit",
 "amount": "1000",
 "currency_code": "EUR"
 }
 
 **/

- (IBAction)purchaseVoidL2L3TransactionForGermanDirectDebit:(id)sender{
    
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient processPurchaseCreditTransactionWithL2L3DirectDebit:@"1000"
                                                          pMethod:@"direct_debit"
                                                  transactiontype:@"purchase"
                                                     currencyCode:@"EUR"
     
                                                  direct_debit_iban:@"DE34500100600032121604"
                                           direct_debit_mandate_ref:@"ABCD1234"
                                                   direct_debit_bic:@"PBNKDEFFXXX"
     
                                           line_items_description:@"item 1"
                                              line_items_quantity:@"5"
                                        line_items_commodity_code:@"C"
                                       line_items_discount_amount:@"1"
                                    line_items_discount_indicator:@"G"
                                   line_items_gross_net_indicator:@"P"

                                       line_items_line_item_total:@"10"
                                          line_items_product_code:@"F"
                                            line_items_tax_amount:@"5"
                                              line_items_tax_rate:@"0.2800000000000000266453525910037569701671600341796875"
                                              line_items_tax_type:@"Federal"
                                             line_items_unit_cost:@"1"
                                       line_items_unit_of_measure:@"meters"
     
     
                                             ship_to_address_city:@"Bad Oyenhausen"
                                            ship_to_address_state:@""
                                              ship_to_address_zip:@"32547"
                                          ship_to_address_country:@"GERMANY"
                                            ship_to_address_email:@"payeezy_client@newclient.com"
                                             ship_to_address_name:@"Eberhard Wellhausen"
                                            ship_to_address_phone:@"+49-89-636-48018"
                                        ship_to_address_address_1:@"Schulstrasse 4"
                                  ship_to_address_customer_number:@"G1234"
     
                                            level3_alt_tax_amount:@"10"
                                                level3_alt_tax_id:@"098841111"
                                           level3_discount_amount:@"1"
                                               level3_duty_amount:@"0.5"
                                            level3_freight_amount:@"5"
                                             level3_ship_from_zip:@"11235"
     
                                               level2_tax1_amount:@"10"
                                               level2_tax1_number:@"2"
                                               level2_tax2_amount:@"5"
                                               level2_tax2_number:@"3"
                                              level2_customer_ref:@"cust_1"
                                                       completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rTransaction Status:%@ \rType:%@ \rTransaction Tag:%@ \rTransaction ID:%@ \rCorrelation Id:%@\rGateway Response Code:%@ \rGateway Response MSG:%@  ",
                                  [dict objectForKey:@"transaction_status"],
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"transaction_id"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"gateway_resp_code"],
                                  [dict objectForKey:@"gateway_message"] ];
             
             NSLog(@"authStatusMessage: %@",authStatusMessage);
             // calling void method here and pasing required parameneters
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :@"200"];
             }
             
             
         }
         else
         {
             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}

/**
 
 {
 "method": "direct_debit",
 "transaction_type": "purchase",
 "amount": "1000",
 "currency_code": "EUR",
 "direct_debit": {
 "iban": "DE34500100600032121604",
 "mandate_ref": "ABCD1234",
 "bic": "PBNKDEFFXXX"
 },
 "level2":{
 "tax1_amount":10,
 "tax1_number":"2",
 "tax2_amount":5,
 "tax2_number":"3",
 "customer_ref":"customer1"
 },
 "level3":{
 "alt_tax_amount":10,
 "alt_tax_id":"098841111",
 "discount_amount":1,
 "duty_amount":0.5,
 "freight_amount":5,
 "ship_from_zip":"11235",
 "ship_to_address":{
 "city":"New York",
 "state":"NY"
 ,"zip":"11235",
 "country":"USA",
 "email":"abc@firstdata.com",
 "name":"Bob Smith",
 "phone":"212-515-1111",
 "address_1":"123 Main Street",
 "customer_number":"12345"
 },
 "line_items":[
 {"description":"item 1","quantity":"5",
 "commodity_code":"C",
 "discount_amount":1,
 "discount_indicator":"G",
 "gross_net_indicator":"P",
 "line_item_total":10,
 "product_code":"F",
 "tax_amount":5,
 "tax_rate":0.2800000000000000266453525910037569701671600341796875,
 "tax_type":"Federal",
 "unit_cost":1,
 "unit_of_measure":"meters"}]
 }
 }
 
 {
 "transaction_tag": "1437656464",
 "transaction_type": "void",
 "method": "direct_debit",
 "amount": "1000",
 "currency_code": "EUR"
 }
 
 **/

- (IBAction)purchaseRefundL2L3TransactionForGermanDirectDebit:(id)sender{
    
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient processPurchaseCreditTransactionWithL2L3DirectDebit:@"1000"
                                                          pMethod:@"direct_debit"
                                                  transactiontype:@"purchase"
                                                     currencyCode:@"EUR"
     
                                                  direct_debit_iban:@"DE34500100600032121604"
                                           direct_debit_mandate_ref:@"ABCD1234"
                                                   direct_debit_bic:@"PBNKDEFFXXX"
     
                                           line_items_description:@"item 1"
                                              line_items_quantity:@"5"
                                        line_items_commodity_code:@"C"
                                       line_items_discount_amount:@"1"
                                    line_items_discount_indicator:@"G"
                                   line_items_gross_net_indicator:@"P"
     
                                       line_items_line_item_total:@"10"
                                          line_items_product_code:@"F"
                                            line_items_tax_amount:@"5"
                                              line_items_tax_rate:@"0.2800000000000000266453525910037569701671600341796875"
                                              line_items_tax_type:@"Federal"
                                             line_items_unit_cost:@"1"
                                       line_items_unit_of_measure:@"meters"
     
     
                                             ship_to_address_city:@"Bad Oyenhausen"
                                            ship_to_address_state:@""
                                              ship_to_address_zip:@"32547"
                                          ship_to_address_country:@"GERMANY"
                                            ship_to_address_email:@"payeezy_client@newclient.com"
                                             ship_to_address_name:@"Eberhard Wellhausen"
                                            ship_to_address_phone:@"+49-89-636-48018"
                                        ship_to_address_address_1:@"Schulstrasse 4"
                                  ship_to_address_customer_number:@"G1234"
     
                                            level3_alt_tax_amount:@"10"
                                                level3_alt_tax_id:@"098841111"
                                           level3_discount_amount:@"1"
                                               level3_duty_amount:@"0.5"
                                            level3_freight_amount:@"5"
                                             level3_ship_from_zip:@"11235"
     
                                               level2_tax1_amount:@"10"
                                               level2_tax1_number:@"2"
                                               level2_tax2_amount:@"5"
                                               level2_tax2_number:@"3"
                                              level2_customer_ref:@"cust_1"
                                                       completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rTransaction Status:%@ \rType:%@ \rTransaction Tag:%@ \rTransaction ID:%@ \rCorrelation Id:%@\rGateway Response Code:%@ \rGateway Response MSG:%@  ",
                                  [dict objectForKey:@"transaction_status"],
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"transaction_id"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"gateway_resp_code"],
                                  [dict objectForKey:@"gateway_message"] ];
             
             NSLog(@"authStatusMessage: %@",authStatusMessage);
             // calling void method here and pasing required parameneters
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"refund" :[dict objectForKey:@"transaction_id"] :@"200"];
             }
             
             
         }
         else
         {
             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}




/**
 creditVoidL2L3TransactionForGermanDirectDebit
 
 {
 "method": "direct_debit",
 "transaction_type": "purchase",
 "amount": "1000",
 "currency_code": "EUR",
 "direct_debit": {
 "iban": "DE34500100600032121604",
 "mandate_ref": "ABCD1234",
 "bic": "PBNKDEFFXXX"
 },
 "level2":{
 "tax1_amount":10,
 "tax1_number":"2",
 "tax2_amount":5,
 "tax2_number":"3",
 "customer_ref":"customer1"
 },
 "level3":{
 "alt_tax_amount":10,
 "alt_tax_id":"098841111",
 "discount_amount":1,
 "duty_amount":0.5,
 "freight_amount":5,
 "ship_from_zip":"11235",
 "ship_to_address":{
 "city":"New York",
 "state":"NY"
 ,"zip":"11235",
 "country":"USA",
 "email":"abc@firstdata.com",
 "name":"Bob Smith",
 "phone":"212-515-1111",
 "address_1":"123 Main Street",
 "customer_number":"12345"
 },
 "line_items":[
 {"description":"item 1","quantity":"5",
 "commodity_code":"C",
 "discount_amount":1,
 "discount_indicator":"G",
 "gross_net_indicator":"P",
 "line_item_total":10,
 "product_code":"F",
 "tax_amount":5,
 "tax_rate":0.2800000000000000266453525910037569701671600341796875,
 "tax_type":"Federal",
 "unit_cost":1,
 "unit_of_measure":"meters"}]
 }
 }
 
 {
 "transaction_tag": "1437656464",
 "transaction_type": "void",
 "method": "direct_debit",
 "amount": "1000",
 "currency_code": "EUR"
 }
 
 **/

- (IBAction)creditVoidL2L3TransactionForGermanDirectDebit:(id)sender{
    
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient processPurchaseCreditTransactionWithL2L3DirectDebit:@"1000"
                                                          pMethod:@"direct_debit"
                                                  transactiontype:@"credit"
                                                     currencyCode:@"EUR"
     
                                                  direct_debit_iban:@"DE34500100600032121604"
                                           direct_debit_mandate_ref:@"ABCD1234"
                                                   direct_debit_bic:@"PBNKDEFFXXX"
     
                                           line_items_description:@"item 1"
                                              line_items_quantity:@"5"
                                        line_items_commodity_code:@"C"
                                       line_items_discount_amount:@"1"
                                    line_items_discount_indicator:@"G"
                                   line_items_gross_net_indicator:@"P"
     
                                       line_items_line_item_total:@"10"
                                          line_items_product_code:@"F"
                                            line_items_tax_amount:@"5"
                                              line_items_tax_rate:@"0.2800000000000000266453525910037569701671600341796875"
                                              line_items_tax_type:@"Federal"
                                             line_items_unit_cost:@"1"
                                       line_items_unit_of_measure:@"meters"
     
     
                                             ship_to_address_city:@"Bad Oyenhausen"
                                            ship_to_address_state:@""
                                              ship_to_address_zip:@"32547"
                                          ship_to_address_country:@"GERMANY"
                                            ship_to_address_email:@"payeezy_client@newclient.com"
                                             ship_to_address_name:@"Eberhard Wellhausen"
                                            ship_to_address_phone:@"+49-89-636-48018"
                                        ship_to_address_address_1:@"Schulstrasse 4"
                                  ship_to_address_customer_number:@"G1234"
     
                                            level3_alt_tax_amount:@"10"
                                                level3_alt_tax_id:@"098841111"
                                           level3_discount_amount:@"1"
                                               level3_duty_amount:@"0.5"
                                            level3_freight_amount:@"5"
                                             level3_ship_from_zip:@"11235"
     
                                               level2_tax1_amount:@"10"
                                               level2_tax1_number:@"2"
                                               level2_tax2_amount:@"5"
                                               level2_tax2_number:@"3"
                                              level2_customer_ref:@"cust_1"
                                                       completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rTransaction Status:%@ \rType:%@ \rTransaction Tag:%@ \rTransaction ID:%@ \rCorrelation Id:%@\rGateway Response Code:%@ \rGateway Response MSG:%@  ",
                                  [dict objectForKey:@"transaction_status"],
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"transaction_id"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"gateway_resp_code"],
                                  [dict objectForKey:@"gateway_message"] ];
             
             NSLog(@"authStatusMessage: %@",authStatusMessage);
             // calling void method here and pasing required parameneters
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :@"200"];
             }
             
             
         }
         else
         {
             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         
         
         [alert show];
     }];
}



@end
