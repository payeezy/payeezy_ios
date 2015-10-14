//
//  ViewController.m
//  PayeezyClient
//
//  Created by First Data Corporation on 5/28/2015.
//  Copyright (c) 2015 First Data Corporation. All rights reserved.
//

#import "ViewController.h"
#import "PayeezySDK.h"


// Credentials for shared test account in PROD/CERT environment
// Does NOT process actual transactions cert credentials


/* Refer developer.payeezy.com = d.payeezy.com = dev portal
 Securing APIKey, token constant values in IOS app :
 http://stackoverflow.com/questions/9448632/best-practices-for-ios-applications-security?rq=1
 */

/* Cert/Demo enviroment for test and integartion */
#define kEnvironment @"CERT"

/* Refer to dev portal -> 'My APIs' page -> app -> API Key */
#define KApiKey      @"y6pWAJNyJyjGv66IsVuWnklkKUPFbb0a"

/* Refer to dev portal -> 'My APIs' page -> app -> Api Secret */
#define KApiSecret   @"86fbae7030253af3cd15faef2a1f4b67353e41fb6799f576b5093ae52901e6f7"

/* Refer to dev portal -> 'My Merchants' page -> SANDBOX -> Token */
#define KToken       @"fdoa-d790ce8951daa73262645cf102641994c1e55e7cdf4c03c8"

/* use following url for Exchange Rate */
#define Exchange_rate_URL   @"https://api-cert.payeezy.com/v1/transactions/exchange_rate"

/* use following url for Primary transactions */
#define TransactionsURL     @"https://api-cert.payeezy.com/v1/transactions/"



/* method level constants */
#define CVV         @"CVV"
#define AVS         @"AVS"
#define SOFT_DESC   @"SOFT_DESC"
 
@interface ViewController ()

@end

@implementation ViewController{
}

@synthesize cardPickerView;
@synthesize typePickerView;
@synthesize carditCardType;
@synthesize icredit_card;
@synthesize transaction_type;
@synthesize items = _items;
@synthesize itemsOfType = _itemsOfType;

// create out UI image objects
@synthesize  masterCard ;
@synthesize  visaCard  ;
@synthesize  amexCard ;
@synthesize  discoverCard ;
@synthesize  fdTokenValue;
@synthesize  dccSegmentedControl;

// test case 2
// Sample method for purchase Void using Discover card

- (IBAction) purchaseVoidTransactionForDCC:(id)sender{
    
    NSLog(@"purchaseVoidTransactionForDCC: start ");
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    // Test credit card info
    NSString* transaction_type_method = self.reflection ;
    
    NSLog(@"credit_card: %@",credit_card);
    
    NSLog(@"transaction type: %@",transaction_type);
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:Exchange_rate_URL];
    
   
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    NSLog(@"transaction_type: %@",transaction_type);
    
    
    if ([transaction_type isEqualToString:@"merchant_rate"])
    {
       
        if([self.wait4Response isAnimating]){
            [self.wait4Response stopAnimating];
        }
        
        NSLog(@"self.itemsOfType: %@",transaction_type_method);
        
        
        [myClient getMerchantRateDCC:@"USD" amount:@"100" completion:^(NSDictionary *dict, NSError *error)
         {
             
             NSString *authStatusMessage = nil;
             
             if (error == nil)
             {
                 authStatusMessage = [NSString stringWithFormat:@"Transaction Details \r correlation_id:%@ \r dcc_offered:%@   \r exchange_rate:%@\r  rate_expiry_timestamp:%@ \r  rate_id:%@ \r",
                                      [dict objectForKey:@"correlation_id"],
                                      [dict objectForKey:@"dcc_offered"],
                                      [dict objectForKey:@"exchange_rate"],
                                      [dict objectForKey:@"rate_expiry_timestamp"],
                                      [dict objectForKey:@"rate_id"]];
                 
                     NSLog(@"self.itemsOfType: %@",transaction_type_method);
                 
                     
                     [myClient setUrl:TransactionsURL];
                 
                 if ([[dict objectForKey:@"dcc_offered"] isEqualToString:@"true"]){
                     
                     if ([transaction_type_method isEqualToString:AVS]){
                         
                    [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_AVS:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"]  billing_city:@"Bath"
                        billing_country:@"England" billing_email:@"support@payeezy.com"
                        billing_street:@"George Street" billing_state_province:@"Bath"
                        billing_zip_postal_code:@"BA1 2FJ" phone_type:@"Home" phone_number:@"+44 (0)207 123 4567" completion:^(NSDictionary *pdict, NSError *error)
                      {
                          
                          if([self.wait4Response isAnimating]){
                              [self.wait4Response stopAnimating];
                          }
                          
                          NSString *authStatusMessage = nil;
                          
                          if (error == nil)
                          {
                              authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                   [pdict objectForKey:@"transaction_type"],
                                                   [pdict objectForKey:@"transaction_tag"],
                                                   [pdict objectForKey:@"correlation_id"],
                                                   [pdict objectForKey:@"bank_resp_code"],
                                                   [pdict objectForKey:@"transaction_status"] ];
                              
                              if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                  
                                  [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"void" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                  
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
                         
                     } else if ([transaction_type_method isEqualToString:SOFT_DESC]){
                         
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_SoftDesc:@"1000"  transactionType:@"purchase"  method:@"credit_card" currencyCode:@"GBP" cardCVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"]  rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] dbaNameSD:@"SoftDesc 1"
                             streetSD:@"123 Main Street" regionSD:@"NY" midSD:@"367337278884" mccSD:@"8812" postalCodeSD:@"11375" countryCodeSD:@"USA" merchantContactInfoSD:@"123 Main street"  completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"void" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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

                         
                         
                     } else {
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_CVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"void" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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

    }else {
        
        
        [myClient getCardRateDCC:credit_card[@"bin"] amount:@"100" completion:^(NSDictionary *dict, NSError *error)
         {
             
             NSString *authStatusMessage = nil;
             
             if (error == nil)
             {
                 authStatusMessage = [NSString stringWithFormat:@"Transaction Details \r correlation_id:%@ \r dcc_offered:%@   \r exchange_rate:%@\r  rate_expiry_timestamp:%@ \r  rate_id:%@ \r",
                                      [dict objectForKey:@"correlation_id"],
                                      [dict objectForKey:@"dcc_offered"],
                                      [dict objectForKey:@"exchange_rate"],
                                      [dict objectForKey:@"rate_expiry_timestamp"],
                                      [dict objectForKey:@"rate_id"]];
                 
                 NSLog(@"self.itemsOfType: %@",transaction_type_method);
                 
                 
                 [myClient setUrl:TransactionsURL];
                 
                 if ([[dict objectForKey:@"dcc_offered"] isEqualToString:@"true"]){
                     
                     if ([transaction_type_method isEqualToString:AVS]){
                         
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_AVS:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"]  billing_city:@"Bath"
                                                                                   billing_country:@"England" billing_email:@"support@payeezy.com"
                                                                                    billing_street:@"George Street" billing_state_province:@"Bath"
                                                                           billing_zip_postal_code:@"BA1 2FJ" phone_type:@"Home" phone_number:@"+44 (0)207 123 4567" completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"void" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
                         
                     } else if ([transaction_type_method isEqualToString:SOFT_DESC]){
                         
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_SoftDesc:@"1000"  transactionType:@"purchase"  method:@"credit_card" currencyCode:@"GBP" cardCVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"]  rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] dbaNameSD:@"SoftDesc 1"
                                                                                               streetSD:@"123 Main Street" regionSD:@"NY" midSD:@"367337278884" mccSD:@"8812" postalCodeSD:@"11375" countryCodeSD:@"USA" merchantContactInfoSD:@"123 Main street"  completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"void" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
                         
                         
                         
                     } else {
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_CVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"void" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
    NSLog(@"purchaseVoidTransactionForDCC: end ");

}

/*!
 * Sample method for purchase Refund using visa card
 * \param id
 * \returns IBAction
 */
// test case 3
- (IBAction)purchaseRefundTransactionForDCC:(id)sender {
    
    NSLog(@"purchaseVoidTransactionForDCC: start ");
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    // Test credit card info
    NSString* transaction_type_method = self.reflection ;
    
    NSLog(@"credit_card: %@",credit_card);
    
    NSLog(@"transaction type: %@",transaction_type);
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:Exchange_rate_URL];
    
    
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    NSLog(@"transaction_type: %@",transaction_type);
    
    
    if ([transaction_type isEqualToString:@"merchant_rate"])
    {
        
        if([self.wait4Response isAnimating]){
            [self.wait4Response stopAnimating];
        }
        
        NSLog(@"self.itemsOfType: %@",transaction_type_method);
        
        
        [myClient getMerchantRateDCC:@"USD" amount:@"100" completion:^(NSDictionary *dict, NSError *error)
         {
             
             NSString *authStatusMessage = nil;
             
             if (error == nil)
             {
                 authStatusMessage = [NSString stringWithFormat:@"Transaction Details \r correlation_id:%@ \r dcc_offered:%@   \r exchange_rate:%@\r  rate_expiry_timestamp:%@ \r  rate_id:%@ \r",
                                      [dict objectForKey:@"correlation_id"],
                                      [dict objectForKey:@"dcc_offered"],
                                      [dict objectForKey:@"exchange_rate"],
                                      [dict objectForKey:@"rate_expiry_timestamp"],
                                      [dict objectForKey:@"rate_id"]];
                 
                 NSLog(@"self.itemsOfType: %@",transaction_type_method);
                 
                 
                 [myClient setUrl:TransactionsURL];
                 
                 if ([[dict objectForKey:@"dcc_offered"] isEqualToString:@"true"]){
                     
                     if ([transaction_type_method isEqualToString:AVS]){
                         
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_AVS:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"]  billing_city:@"Bath"
                                                                                   billing_country:@"England" billing_email:@"support@payeezy.com"
                                                                                    billing_street:@"George Street" billing_state_province:@"Bath"
                                                                           billing_zip_postal_code:@"BA1 2FJ" phone_type:@"Home" phone_number:@"+44 (0)207 123 4567" completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
                         
                     } else if ([transaction_type_method isEqualToString:SOFT_DESC]){
                         
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_SoftDesc:@"1000"  transactionType:@"purchase"  method:@"credit_card" currencyCode:@"GBP" cardCVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"]  rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] dbaNameSD:@"SoftDesc 1"
                                                                                               streetSD:@"123 Main Street" regionSD:@"NY" midSD:@"367337278884" mccSD:@"8812" postalCodeSD:@"11375" countryCodeSD:@"USA" merchantContactInfoSD:@"123 Main street"  completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
                         
                         
                         
                     } else {
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_CVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
        
    }else {
        
        
        [myClient getCardRateDCC:credit_card[@"bin"] amount:@"100" completion:^(NSDictionary *dict, NSError *error)
         {
             
             NSString *authStatusMessage = nil;
             
             if (error == nil)
             {
                 authStatusMessage = [NSString stringWithFormat:@"Transaction Details \r correlation_id:%@ \r dcc_offered:%@   \r exchange_rate:%@\r  rate_expiry_timestamp:%@ \r  rate_id:%@ \r",
                                      [dict objectForKey:@"correlation_id"],
                                      [dict objectForKey:@"dcc_offered"],
                                      [dict objectForKey:@"exchange_rate"],
                                      [dict objectForKey:@"rate_expiry_timestamp"],
                                      [dict objectForKey:@"rate_id"]];
                 
                 NSLog(@"self.itemsOfType: %@",transaction_type_method);
                 
                 
                 [myClient setUrl:TransactionsURL];
                 
                 if ([[dict objectForKey:@"dcc_offered"] isEqualToString:@"true"]){
                     
                     if ([transaction_type_method isEqualToString:AVS]){
                         
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_AVS:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"]  billing_city:@"Bath"
                                                                                   billing_country:@"England" billing_email:@"support@payeezy.com"
                                                                                    billing_street:@"George Street" billing_state_province:@"Bath"
                                                                           billing_zip_postal_code:@"BA1 2FJ" phone_type:@"Home" phone_number:@"+44 (0)207 123 4567" completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
                         
                     } else if ([transaction_type_method isEqualToString:SOFT_DESC]){
                         
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_SoftDesc:@"1000"  transactionType:@"purchase"  method:@"credit_card" currencyCode:@"GBP" cardCVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"]  rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] dbaNameSD:@"SoftDesc 1"
                                                                                               streetSD:@"123 Main Street" regionSD:@"NY" midSD:@"367337278884" mccSD:@"8812" postalCodeSD:@"11375" countryCodeSD:@"USA" merchantContactInfoSD:@"123 Main street"  completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
                         
                         
                         
                     } else {
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_CVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
    NSLog(@"purchaseVoidTransactionForDCC: end ");
    
}

/*!
 * Sample method for purchase Refund using visa card
 * \param id
 * \returns IBAction
 */
// test case 3
- (IBAction)nakedRefundTransactionForDCC:(id)sender {
    
    NSLog(@"purchaseVoidTransactionForDCC: start ");
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    // Test credit card info
    NSString* transaction_type_method = self.reflection ;
    
    NSLog(@"credit_card: %@",credit_card);
    
    NSLog(@"transaction type: %@",transaction_type);
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:Exchange_rate_URL];
    
    
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    NSLog(@"transaction_type: %@",transaction_type);
    
    
    if ([transaction_type isEqualToString:@"merchant_rate"])
    {
        
        if([self.wait4Response isAnimating]){
            [self.wait4Response stopAnimating];
        }
        
        NSLog(@"self.itemsOfType: %@",transaction_type_method);
        
        
        [myClient getMerchantRateDCC:@"USD" amount:@"100" completion:^(NSDictionary *dict, NSError *error)
         {
             
             NSString *authStatusMessage = nil;
             
             if (error == nil)
             {
                 authStatusMessage = [NSString stringWithFormat:@"Transaction Details \r correlation_id:%@ \r dcc_offered:%@   \r exchange_rate:%@\r  rate_expiry_timestamp:%@ \r  rate_id:%@ \r",
                                      [dict objectForKey:@"correlation_id"],
                                      [dict objectForKey:@"dcc_offered"],
                                      [dict objectForKey:@"exchange_rate"],
                                      [dict objectForKey:@"rate_expiry_timestamp"],
                                      [dict objectForKey:@"rate_id"]];
                 
                 NSLog(@"self.itemsOfType: %@",transaction_type_method);
                 
                 
                 [myClient setUrl:TransactionsURL];
                 
                 if ([[dict objectForKey:@"dcc_offered"] isEqualToString:@"true"]){
                     
                     if ([transaction_type_method isEqualToString:AVS]){
                         
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_AVS:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"]  billing_city:@"Bath"
                                                                                   billing_country:@"England" billing_email:@"support@payeezy.com"
                                                                                    billing_street:@"George Street" billing_state_province:@"Bath"
                                                                           billing_zip_postal_code:@"BA1 2FJ" phone_type:@"Home" phone_number:@"+44 (0)207 123 4567" completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                    
                                      NSString *vcrURL = [NSString stringWithFormat: @"%@/%@", TransactionsURL, [pdict objectForKey:@"transaction_id"]];
                                      
                                      [myClient setUrl:vcrURL];
                                      
                                      [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_CVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"100" transactionType:@"refund"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] completion:^(NSDictionary *pdict, NSError *error)
                                       {
                                           
                                           if([self.wait4Response isAnimating]){
                                               [self.wait4Response stopAnimating];
                                           }
                                           
                                           NSString *authStatusMessage = nil;
                                           
                                           if (error == nil)
                                           {
                                               authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                                    [pdict objectForKey:@"transaction_type"],
                                                                    [pdict objectForKey:@"transaction_tag"],
                                                                    [pdict objectForKey:@"correlation_id"],
                                                                    [pdict objectForKey:@"bank_resp_code"],
                                                                    [pdict objectForKey:@"transaction_status"] ];
                                               
                                               if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                                   
                                                   [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                                   
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
                         
                     } else if ([transaction_type_method isEqualToString:SOFT_DESC]){
                         
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_SoftDesc:@"1000"  transactionType:@"purchase"  method:@"credit_card" currencyCode:@"GBP" cardCVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"]  rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] dbaNameSD:@"SoftDesc 1"
                                                                                               streetSD:@"123 Main Street" regionSD:@"NY" midSD:@"367337278884" mccSD:@"8812" postalCodeSD:@"11375" countryCodeSD:@"USA" merchantContactInfoSD:@"123 Main street"  completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
                         
                         
                         
                     } else {
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_CVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
        
    }else {
        
        
        [myClient getCardRateDCC:credit_card[@"bin"] amount:@"100" completion:^(NSDictionary *dict, NSError *error)
         {
             
             NSString *authStatusMessage = nil;
             
             if (error == nil)
             {
                 authStatusMessage = [NSString stringWithFormat:@"Transaction Details \r correlation_id:%@ \r dcc_offered:%@   \r exchange_rate:%@\r  rate_expiry_timestamp:%@ \r  rate_id:%@ \r",
                                      [dict objectForKey:@"correlation_id"],
                                      [dict objectForKey:@"dcc_offered"],
                                      [dict objectForKey:@"exchange_rate"],
                                      [dict objectForKey:@"rate_expiry_timestamp"],
                                      [dict objectForKey:@"rate_id"]];
                 
                 NSLog(@"self.itemsOfType: %@",transaction_type_method);
                 
                 
                 [myClient setUrl:TransactionsURL];
                 
                 if ([[dict objectForKey:@"dcc_offered"] isEqualToString:@"true"]){
                     
                     if ([transaction_type_method isEqualToString:AVS]){
                         
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_AVS:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"]  billing_city:@"Bath"
                                                                                   billing_country:@"England" billing_email:@"support@payeezy.com"
                                                                                    billing_street:@"George Street" billing_state_province:@"Bath"
                                                                           billing_zip_postal_code:@"BA1 2FJ" phone_type:@"Home" phone_number:@"+44 (0)207 123 4567" completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
                         
                     } else if ([transaction_type_method isEqualToString:SOFT_DESC]){
                         
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_SoftDesc:@"1000"  transactionType:@"purchase"  method:@"credit_card" currencyCode:@"GBP" cardCVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"]  rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] dbaNameSD:@"SoftDesc 1"
                                                                                               streetSD:@"123 Main Street" regionSD:@"NY" midSD:@"367337278884" mccSD:@"8812" postalCodeSD:@"11375" countryCodeSD:@"USA" merchantContactInfoSD:@"123 Main street"  completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
                         
                         
                         
                     } else {
                         [myClient submitPurchaseOrNakedTransactionWithCreditCardDetailsForDCC_CVV:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"GBP" totalAmount:@"1000" transactionType:@"purchase"  method:@"credit_card" rate_id:[dict objectForKey:@"rate_id"] dcc_accepted:[dict objectForKey:@"dcc_offered"] completion:^(NSDictionary *pdict, NSError *error)
                          {
                              
                              if([self.wait4Response isAnimating]){
                                  [self.wait4Response stopAnimating];
                              }
                              
                              NSString *authStatusMessage = nil;
                              
                              if (error == nil)
                              {
                                  authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                                       [pdict objectForKey:@"transaction_type"],
                                                       [pdict objectForKey:@"transaction_tag"],
                                                       [pdict objectForKey:@"correlation_id"],
                                                       [pdict objectForKey:@"bank_resp_code"],
                                                       [pdict objectForKey:@"transaction_status"] ];
                                  
                                  if ([[pdict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                      
                                      [self voidRefundCaptureTransaction:@"abc1412096293369" :[pdict objectForKey:@"transaction_tag"] :@"refund" :[pdict objectForKey:@"transaction_id"] :@"200"];
                                      
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
    NSLog(@"purchaseVoidTransactionForDCC: end ");
    
}

/*!
 * voidTransaction
 * \param
 * \returns
 */
- (IBAction)voidRefundCaptureTransaction:(NSString *)merchant_ref :(NSString *)transaction_tag  :(NSString *)trans_type   :(NSString *)transaction_id :(NSString *)totalamount  {
    
    // Test credit card info
    NSDictionary* void_transaction = @{
                                       @"merchant_ref": merchant_ref,
                                       @"transaction_tag": transaction_tag,
                                       @"transaction_type": trans_type,
                                       @"transaction_id": transaction_id,
                                       @"method": @"credit_card",
                                       @"amount": totalamount,
                                       @"currency_code": @"GBP"
                                       };
    
    NSString *vcrURL = [NSString stringWithFormat: @"%@/%@", TransactionsURL, transaction_id];
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:vcrURL];
    
    [myClient submitVoidCaptureRefundTransactionWithCreditCardDetails:void_transaction[@"merchant_ref"] transactiontag:void_transaction[@"transaction_tag"] transactionType:void_transaction[@"transaction_type"] transactionId:void_transaction[@"transaction_id"] paymentMethodType:void_transaction[@"method"] totalAmount:void_transaction[@"amount"] currencyCode:void_transaction[@"currency_code"] completion:^(NSDictionary *dict, NSError *error) {
        
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


/*!
 *
 * \param
 * \returns
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set delegate and datasource of the pickerView
    self.cardPickerView.delegate = self;
    self.cardPickerView.dataSource = self;
    
    //set delegate and datasource of the pickerView
    self.typePickerView.delegate = self;
    self.typePickerView.dataSource = self;
    
    self.transaction_type = @"card_rate";
    
    //init items array with colors
    self.items = [[NSArray alloc] initWithObjects:@"Select Test Credit Card & Payeezy Payment method+",@"Visa-4389800000000006-1215-123", @"Master-5100030000000005-0430-123",nil];
    
    //init items array with colors
    self.itemsOfType = [[NSArray alloc] initWithObjects:@"Select Type of Transaction +",@"Card Verification Value-CVV", @"Address Verification Service-AVS",@"Softdesc", nil];

    
    // create out UI image objects
    masterCard   = [UIImage imageNamed:@"mastercard.jpg"];
    visaCard     = [UIImage imageNamed:@"visa.png"];
 
    
    carditCardType.image = visaCard;
    self.icredit_card = @{
                          @"type":@"visa",
                          @"cardholder_name":@"John Smith",
                          @"card_number":@"4389800000000006",
                          @"exp_date":@"1215",
                          @"cvv":@"123"
                          };
    
}

/*!
 *
 * \param
 * \returns
 */
- (void)viewDidAppear:(BOOL)animated{
    _amountEntered.text = @"";
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
    if (pickerView == cardPickerView) {
        return [self.items count];
    }else {
        return [self.itemsOfType count];
    }
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (pickerView == cardPickerView) {
         return 20.0;
        
    }else {
         return 20.0;
    }
   
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    if (pickerView == cardPickerView) { // credit card
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, self.cardPickerView.frame.size.height / 2 - 15, 400, 30)];
        [label setFont:[UIFont fontWithName:@"TrebuchetMS-Italic" size:11.0]];
        [label setTextColor:[UIColor darkTextColor]];
        
        label.text = [NSString stringWithFormat:@"%@", [self.items objectAtIndex:row]];
        label.textAlignment = NSTextAlignmentLeft; //Changed to NS as UI is deprecated.
        label.backgroundColor = [UIColor clearColor];
        
        return label;
        
    }else { // transactions
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, self.typePickerView.frame.size.height / 2 - 15, 400, 30)];
        [label setFont:[UIFont fontWithName:@"TrebuchetMS-Italic" size:11.0]];
        [label setTextColor:[UIColor darkTextColor]];
        
        label.text = [NSString stringWithFormat:@"%@", [self.itemsOfType objectAtIndex:row]];
        label.textAlignment = NSTextAlignmentLeft; //Changed to NS as UI is deprecated.
        label.backgroundColor = [UIColor clearColor];
        
        return label;
        
    }
    
    
}

//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
       
    if (pickerView == typePickerView) {
    switch (row) {
            
        case 0:
            self.reflection = CVV;
            break;
            
        case 1:
            self.reflection = CVV;
            break;
            
        case 2:
            self.reflection = AVS;
            break;
        case 3:
            self.reflection = SOFT_DESC;
            break;
            
    }
    }else if (pickerView == cardPickerView ) {
        switch (row) {
                
            case 0:
                carditCardType.image = nil;
                break;
                
            case 1:
                carditCardType.image = visaCard;
                self.icredit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":@"John Smith",
                                      @"card_number":@"4389800000000006",
                                      @"bin":@"438980",
                                      @"exp_date":@"1215",
                                      @"cvv":@"123"
                                      };
                break;
                
            case 2:
                carditCardType.image = masterCard;
                self.icredit_card = @{
                                      @"type":@"Mastercard",
                                      @"cardholder_name":@"John Smith",
                                      @"card_number":@"5100030000000005",
                                      @"bin":@"510003",
                                      @"exp_date":@"0430",
                                      @"cvv":@"123"
                                      };
                break;
                
        }

    }
    
}



- (IBAction)segmentSwitch:(id)sender {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
         self.transaction_type = @"card_rate";
    else
         self.transaction_type = @"merchant_rate";
    
    
}


@end
