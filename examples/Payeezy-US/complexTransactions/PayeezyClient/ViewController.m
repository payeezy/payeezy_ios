//
//  ViewController.m
//  PayeezyClient
//
//  Created by First Data Corporation on 8/28/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import "ViewController.h"
#import "PayeezySDK.h"

// Credentials for shared test account in CERT environment
// Does NOT process actual transactions
// cert credentials
//#define KApiKey     @"y6pWAJNyJyjGv66IsVuWnklkKUPFbb0a"
//#define KApiSecret  @"86fbae7030253af3cd15faef2a1f4b67353e41fb6799f576b5093ae52901e6f786fbae7030253af3cd15faef2a1f4b67353e41fb6799f576b5093ae52901e6f7"
//#define KToken      @"fdoa-a480ce8951daa73262734cf102641994c1e55e7cdf4c02b6"
//#define KURL        @"https://api-cert.payeezy.com/v1/transactions"


/*** CAT credentails ***/
#define KApiKey    @"bA8hIqpzuAVW6itHqXsXwSl6JtFWPCA0"
#define KApiSecret @"YmI4YzA1NmRkZmQzMzA1ZmI1ZWY3NDllZjYzMmI4Y2FmZDhhN2MwMWIzZThkMWU2NGRjZmI4OWE5NGRiMzM4NA=="
#define KToken     @"fdoa-a480ce8951daa73262734cf102641994c1e55e7cdf4c02b6"
#define KURL       @"https://api-cat.payeezy.com/v1/transactions"

#define KApiKeyForValueLink    @"bA8hIqpzuAVW6itHqXsXwSl6JtFWPCA0"
#define KApiSecretForValueLink @"675d92bff9602acb6a52cbf7529f34c923689b60a65734f33c1917b196b13036"
#define KTokenForValueLink     @"fdoa-a480ce8951daa73262734cf102641994abc7643456k02b6"

@implementation ViewController

/*!
 *
 * \param
 * \returns
 */
- (void)viewDidLoad {
    [super viewDidLoad];
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





/*!
 * Authorize Amt0 Visa Transaction CVV
 * \param id
 * \returns IBAction
 */

- (IBAction)authorizeAmt0VisaTransactionCVV:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":@"Jacob Test",
                                      @"card_number":@"4012000033330026",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        // Transaction info
        NSDictionary* transaction_info = @{
                                      @"currencyCode":@"USD",
                                      @"amount":amount,
                                      @"merchantRefForProcessing":@"abc1412096293369"
                                     };
        // initialize Payeezy object with key,token and secret value
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        
        // call authorize method with payment/creditcard data
        [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:transaction_info[@"currencyCode"] totalAmount:amount merchantRefForProcessing:transaction_info[@"merchantRefForProcessing"]
         
                                                       completion:^(NSDictionary *dict, NSError *error) {
                                                           
                                                           NSString *authStatusMessage = nil;
                                                           
                                                           // handle error and response
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

/********************************************************************************************************
 //myClient.url = KURL;
 ********************************************************************************************************/

/*!
 *
 * \param id
 * \returns IBAction
 */
- (IBAction)authorizeVoidVisaTransactionCVV:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
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
        
        [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"abc1412096293369"
         
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
                                                               [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"]  :amount];
                                                               
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

/********************************************************************************************************
 
 ********************************************************************************************************/

/*!
 *
 * \param id
 * \returns IBAction
 */
- (IBAction)authorizeCaptureVisaTransactionCVV:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
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
        
        [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"abc1412096293369"
         
                                                       completion:^(NSDictionary *dict, NSError *error) {
                                                           
                                                           NSString *authStatusMessage = nil;
                                                           
                                                           if (error == nil)
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@",
                                                                                    [dict objectForKey:@"transaction_type"],
                                                                                    [dict objectForKey:@"transaction_id"],
                                                                                    [dict objectForKey:@"transaction_tag"]];
                                                               [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"capture" :[dict objectForKey:@"transaction_id"] :amount];
                                                               
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


/********************************************************************************************************
 
 // Purchase void call
 ********************************************************************************************************/

/*!
 *
 * \param id
 * \returns IBAction
 */
- (IBAction)purchaseVoidVisaTransactionCVV:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
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
        
        [myClient submitPurchaseTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"abc1412096293369"
         
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
                                                              [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :amount];
                                                              
                                                              /*
                                                               (IBAction)voidTransaction:(NSString *)merchant_ref :(NSString *)transaction_tag  :(NSString *)transaction_type :(NSString *)transaction_id :(NSString *)totalamount
                                                               */
                                                              
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

/********************************************************************************************************
 ********************************************************************************************************/
/*!
 *
 * \param id
 * \returns IBAction
 */
- (IBAction)purchaseRefundVisaTransactionCVV:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
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
        
        [myClient submitPurchaseTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"abc1412096293369"
         
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
- (IBAction)authorizeAmt0AmexTransactionCVV:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"American Express",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"373953192351004",
                                      @"exp_date":@"0416",
                                      @"cvv":@"1234"
                                      };
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"abc1412096293369"
         
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
- (IBAction)authorizeAmt0DiscoverTransactionCVV:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"discover",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"6011000990099818",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"abc1412096293369"
         
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
- (IBAction)authorizeAmt0MasterCardTransactionCVV:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"mastercard",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"5424180279791732",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"abc1412096293369"
         
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
- (IBAction)authorizeVoidTransactionAmex:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"American Express",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"373953192351004",
                                      @"exp_date":@"0416",
                                      @"cvv":@"1234"
                                      };
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"abc1412096293369"
         
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
        NSDictionary* credit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"4012000033330026",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"Test Authorization Transaction - PayeezyClient"
         
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
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
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
        
        [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"Test Authorization Transaction - PayeezyClient"
         
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
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
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
        
        [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"Test Authorization Transaction - PayeezyClient"
         
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
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        //   NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* void_transaction = @{
                                           @"merchant_ref": merchant_ref,
                                           @"transaction_tag": transaction_tag,
                                           @"transaction_type": transaction_type,
                                           @"transaction_id": transaction_id,
                                           @"method": @"credit_card",
                                           @"amount": totalamount,
                                           @"currency_code": @"USD"
                                           };
        
        NSString *vcrURL = [NSString stringWithFormat: @"%@/%@", KURL, transaction_id];
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:vcrURL];
        
        [myClient submitVoidCaptureRefundTransactionWithCreditCardDetails:void_transaction[@"merchant_ref"] transactiontag:void_transaction[@"transaction_tag"] transactionType:void_transaction[@"transaction_type"] transactionId:void_transaction[@"transaction_id"] paymentMethodType:void_transaction[@"method"] totalAmount:void_transaction[@"amount"] currencyCode:@"USD" completion:^(NSDictionary *dict, NSError *error) {
            
            NSString *authStatusMessage = nil;
            
            if (error == nil)
            {
                authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@",
                                     [dict objectForKey:@"transaction_type"],
                                     [dict objectForKey:@"transaction_id"],
                                     [dict objectForKey:@"transaction_tag"]];
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


-(NSString*) splitTransaction:(NSString *)merchant_ref :(NSString *)transaction_tag  :(NSString *)transaction_type   :(NSString *)transaction_id :(NSString *)split_shipment :(NSString *)totalamount  {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        //   NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* split_transaction = @{
                                           @"merchant_ref": merchant_ref,
                                           @"transaction_tag": transaction_tag,
                                           @"transaction_type": transaction_type,
                                           @"split_shipment": split_shipment,
                                           @"method": @"credit_card",
                                           @"amount": totalamount,
                                           @"currency_code": @"USD"
                                           };
        
        NSString *vcrURL = [NSString stringWithFormat: @"%@/%@", KURL, transaction_id];
        //NSString *transtag = @"1849617";
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:vcrURL];
        
        [myClient submitSplitTransactionWithCreditCardDetails:split_transaction[@"merchant_ref"] transactiontag:split_transaction[@"transaction_tag"] transactionType:split_transaction[@"transaction_type"]  paymentMethodType:split_transaction[@"method"]  splitShipment:split_transaction[@"split_shipment"] totalAmount:totalamount currencyCode:@"USD" completion:^(NSDictionary *dict, NSError *error) {
            
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
    return @"";
}


/*!
 *
 * \param
 * \returns
 */
// capture transactions
- (IBAction)captureTransaction:(id)sender{}

/*!
 *
 * \param
 * \returns
 */
// refund transctions
- (IBAction)refundTransaction:(id)sender{}


// CCV Visa testcases




/*!
 *
 * \param
 * \returns
 */

// CVV Amex testcases
- (IBAction)purchaseVoidAmexTransactionCVV:(id)sender{}
- (IBAction)purchaseRefundAmexTransactionCVV:(id)sender{}

- (IBAction)authorizeVoidAmexTransactionCVV:(id)sender{}
- (IBAction)authorizeCaptureAmexTransactionCVV:(id)sender{}

// CVV MasterCard testcases
- (IBAction)purchaseVoidMasterCardTransactionCVV:(id)sender{}
- (IBAction)purchaseRefundMasterCardTransactionCVV:(id)sender{}

- (IBAction)authorizeVoidMasterCardTransactionCVV:(id)sender{}
- (IBAction)authorizeCaptureMasterCardTransactionCVV:(id)sender{}

// CVV Discover testcases
- (IBAction)purchaseVoidDiscoverTransactionCVV:(id)sender{
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"discover",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"6011000990099818",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitPurchaseTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:amount merchantRefForProcessing:@"abc1412096293369"
         
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
                                                              [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :amount];
                                                              
                                                              /*
                                                               (IBAction)voidTransaction:(NSString *)merchant_ref :(NSString *)transaction_tag  :(NSString *)transaction_type :(NSString *)transaction_id :(NSString *)totalamount
                                                               */
                                                              
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
- (IBAction)purchaseRefundDiscoverTransactionCVV:(id)sender{}

- (IBAction)authorizeVoidDiscoverTransactionCVV:(id)sender{}
- (IBAction)authorizeCaptureDiscoverTransactionCVV:(id)sender{}

// AVS Visa testcases
- (IBAction)purchaseVoidVisaTransactionAVS:(id)sender{}
- (IBAction)purchaseRefundVisaTransactionAVS:(id)sender{}



/*!
 * authorize Amt0 Visa Transaction AVS
 * \param
 * \returns
 */
- (IBAction)authorizeAmt0VisaTransactionAVS:(id)sender{
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"4012000033330026",
                                      @"exp_date":@"0416"
                                      };
        
        // Test phone number info
        NSDictionary* phone_numbers = @{
                                        @"type":@"cell",
                                        @"number":@"212-515-1212"
                                        };
        //
        NSDictionary* billing_address = @{
                                          @"city":@"St. Louis",
                                          @"country":@"US",
                                          @"email":@"abc@main.com",
                                          @"street":@"12115 LACKLAND",
                                          @"state_province":@"MO",
                                          @"zip_postal_code":@"63146 "
                                          };
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizeTransactionAVSWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] phoneType:phone_numbers[@"type"] phoneNumber:phone_numbers[@"number"] billingCity:billing_address[@"city"] billingCountry:billing_address[@"country"] billingEmail:billing_address[@"email"] billingStreet: billing_address[@"street"] billingState:billing_address[@"state_province"] billingZipCode:billing_address[@"zip_postal_code"] currencyCode:@"USD" totalAmount:amount transactionType:@"authorize" merchantRefForProcessing:@"abc1412096293369"
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


- (IBAction)authorizeVoidVisaTransactionAVS:(id)sender{}
- (IBAction)authorizeCaptureVisaTransactionAVS:(id)sender{}

// AVS Amex testcases
- (IBAction)purchaseVoidAmexTransactionAVS:(id)sender{}
- (IBAction)purchaseRefundAmexTransactionAVS:(id)sender{}
- (IBAction)authorizeAmt0AmexTransactionAVS:(id)sender{}
- (IBAction)authorizeVoidAmexTransactionAVS:(id)sender{}
- (IBAction)authorizeCaptureAmexTransactionAVS:(id)sender{}

// AVS MasterCard testcases
- (IBAction)purchaseVoidMasterCardTransactionAVS:(id)sender{}
- (IBAction)purchaseRefundMasterCardTransactionAVS:(id)sender{}
- (IBAction)authorizeAmt0MasterCardTransactionAVS:(id)sender{}
- (IBAction)authorizeVoidMasterCardTransactionAVS:(id)sender{}
- (IBAction)authorizeCaptureMasterCardTransactionAVS:(id)sender{}

// AVS Discover testcases
- (IBAction)purchaseVoidDiscoverTransactionAVS:(id)sender{}
- (IBAction)purchaseRefundDiscoverTransactionAVS:(id)sender{}
- (IBAction)authorizeAmt0DiscoverTransactionAVS:(id)sender{}
- (IBAction)authorizeVoidDiscoverTransactionAVS:(id)sender{}
- (IBAction)authorizeCaptureDiscoverTransactionAVS:(id)sender{}

// Split shipments

/**IMP**/
- (IBAction)authorizeSplitDiscoverTransaction:(id)sender{
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = @"0109";
        
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"discover",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"6011000990099818",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        
        NSDictionary* split_str0199 = @{
                                        @"merchant_ref": @"abc1412096293369",
                                        @"transaction_tag" : @"1721103",
                                        @"transaction_type": @"split",
                                        @"split_shipment":@"01/99",
                                        @"method": @"credit_card",
                                        @"amount": @"0009",
                                        @"currency_code": @"USD"
                                        };
        
        NSDictionary* split_str4599= @{
                                       @"merchant_ref": @"abc1412096293369",
                                       @"transaction_tag" : @"1721103",
                                       @"transaction_type": @"split",
                                       @"split_shipment":@"45/99",
                                       @"method": @"credit_card",
                                       @"amount": @"0021",
                                       @"currency_code": @"USD"
                                       };
        
        NSDictionary* split_str4646 = @{
                                        @"merchant_ref": @"abc1412096293369",
                                        @"transaction_tag" : @"1721103",
                                        @"transaction_type": @"split",
                                        @"split_shipment":@"46/46",
                                        @"method": @"credit_card",
                                        @"amount": amount,
                                        @"currency_code": @"USD"
                                        };
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        
        [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] currencyCode:@"USD" totalAmount:@"0109" merchantRefForProcessing:@"abc1412096293369"
         
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
                                                //split_str0199
    [self splitTransaction:split_str0199[@"merchant_ref"] :[dict objectForKey:@"transaction_tag"] :split_str0199[@"transaction_type"] :[dict objectForKey:@"transaction_id"]  :split_str0199[@"split_shipment"] :split_str0199[@"amount"]];
        
                                                               
                                                   //split_str4599
    [self splitTransaction:split_str4599[@"merchant_ref"] :[dict objectForKey:@"transaction_tag"] :split_str4599[@"transaction_type"] :[dict objectForKey:@"transaction_id"]  :split_str4599[@"split_shipment"] :split_str4599[@"amount"]];
                                                            
                                                   //split_str4646
    [self splitTransaction:split_str4646[@"merchant_ref"] :[dict objectForKey:@"transaction_tag"] :split_str4646[@"transaction_type"] :[dict objectForKey:@"transaction_id"]  :split_str4646[@"split_shipment"] :split_str4646[@"amount"]];
                                              
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



// L2 Amex testcases
- (IBAction)purchaseAmexTransactionL2:(id)sender{}

/*!
 * authorize Capture Amex Transaction L2
 * \param
 * \returns
 */
- (IBAction)authorizeCaptureAmexTransactionL2:(id)sender{
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"4012000033330026",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        
        NSDictionary* level2 = @{
                                 @"tax1_amount":@"10",
                                 @"tax1_number":@"2",
                                 @"tax2_amount":@"5",
                                 @"tax2_number":@"3",
                                 @"customer_ref":@"customer1"
                                 };
        
        NSDictionary* billing_address = @{
                                          @"street": @"225 Liberty Street",
                                          @"city": @"NYC",
                                          @"state_province": @"NY",
                                          @"zip_postal_code": @"10281",
                                          @"country": @"US"
                                          };
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        
        [myClient submitAuthorizeTransactionL2WithCreditCardDetails:amount transactionType:@"authorize"  transactionTag:@"1846953" merchantRefForProcessing:@"abc1412096293369" pMethod:@"credit_card" currencyCode:@"USD" cardtype:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] tax1Amount:level2[@"tax1_amount"] tax1Number:level2[@"tax1_number"] tax2Amount:level2[@"tax2_amount"] tax2Number:level2[@"tax2_number"] customerRef:level2[@"customer_ref"]  street:billing_address[@"street"]   city:billing_address[@"city"]   stateProvince:billing_address[@"state_province"]  zipPostalCode:billing_address[@"zip_postal_code"]  country:billing_address[@"country"]
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
- (IBAction)regularCaptureAmexTransactionL2:(id)sender{}



- (IBAction)purchaseVisaTransactionL2L3:(id)sender{
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* line_items = @{
                                     @"description":@"item 1",
                                     @"quantity":@"5",
                                     @"commodity_code":@"C",
                                     @"discount_amount":@"1",
                                     @"discount_indicator":@"G",
                                     @"gross_net_indicator":@"P",
                                     @"line_item_total":@"10",
                                     @"product_code":@"F",
                                     @"tax_amount":@"5",
                                     @"tax_rate":@"0.2800000000000000266453525910037569701671600341796875",
                                     @"tax_type":@"Federal",
                                     @"unit_cost":@"1",
                                     @"unit_of_measure":@"meters"
                                     };
        NSDictionary* level2 = @{
                                 @"tax1_amount":@"10",
                                 @"tax1_number":@"2",
                                 @"tax2_amount":@"5",
                                 @"tax2_number":@"3",
                                 @"customer_ref":@"customer1"
                                 };
        
        NSDictionary* level3 = @{
                                 @"alt_tax_amount":@"10",
                                 @"alt_tax_id":@"098841111",
                                 @"discount_amount":@"1",
                                 @"duty_amount":@"0.5",
                                 @"freight_amount":@"5",
                                 @"ship_from_zip":@"11235"
                                 };
        
        NSDictionary*  ship_to_address = @{
                                           @"city":@"New York",
                                           @"state":@"NY",
                                           @"zip":@"11235",
                                           @"country":@"USA",
                                           @"email":@"abc@firstdata.com",
                                           @"name":@"Bob Smith",
                                           @"phone":@"212-515-1111",
                                           @"address_1":@"123 Main Street",
                                           @"customer_number":@"12345"
                                           };
        
        NSDictionary* mainL2L3 = @{ @"amount":@"9200",
                                    @"transaction_type":@"purchase",
                                    @"merchant_ref":@"abc1412096293369",
                                    @"method":@"credit_card",
                                    @"currency_code":@"USD"
                                    };
        
        NSDictionary* credit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"4012000033330026",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitPurchaseTransactionWithL2L3CreditCardDetails:amount
                                                     transactionType:mainL2L3[@"transaction_type"]
                                            merchantRefForProcessing:mainL2L3[@"merchant_ref"]
                                                             pMethod:mainL2L3[@"method"]
                                                        currencyCode:mainL2L3[@"currency_code"]
         
                                                            cardtype:credit_card[@"type"]
                                                      cardHolderName:credit_card[@"cardholder_name"]
                                                          cardNumber:credit_card[@"card_number"]
                                              cardExpirymMonthAndYear:credit_card[@"exp_date"]
                                                             cardCVV:credit_card[@"cvv"]
         
                                                          tax1Amount:level2[@"tax1_amount"]
                                                          tax1Number:level2[@"tax1_number"]
                                                          tax2Amount:level2[@"tax2_amount"]
                                                          tax2Number:level2[@"tax2_number"]
                                                         customerRef:level2[@"customer_ref"]
         
                                                         description:line_items[@"description"]
                                                            quantity:line_items[@"quantity"]
                                                      commodity_code:line_items[@"commodity_code"]
                                                     discount_amount:line_items[@"discount_amount"]
                                                  discount_indicator:line_items[@"discount_indicator"]
                                                 gross_net_indicator:line_items[@"gross_net_indicator"]
                                                     line_item_total:line_items[@"line_item_total"]
                                                        product_code:line_items[@"product_code"]
                                                          tax_amount:line_items[@"tax_amount"]
                                                            tax_rate:line_items[@"tax_rate"]
                                                            tax_type:line_items[@"tax_type"]
                                                           unit_cost:line_items[@"unit_cost"]
                                                     unit_of_measure:line_items[@"unit_of_measure"]
                                                      alt_tax_amount:level3[@"alt_tax_amount"]
                                                          alt_tax_id:level3[@"alt_tax_id"]
                                                  l3_discount_amount:level3[@"discount_amount"]                                                              duty_amount:level3[@"duty_amount"]
                                                      freight_amount:level3[@"freight_amount"]
                                                       ship_from_zip:level3[@"ship_from_zip"]
                                                                city:ship_to_address[@"city"]
                                                               state:ship_to_address[@"state"]
                                                                 zip:ship_to_address[@"zip"]
                                                             country:ship_to_address[@"country"]
                                                               email:ship_to_address[@"email"]
                                                                name:ship_to_address[@"name"]
                                                               phone:ship_to_address[@"phone"]
                                                           address_1:ship_to_address[@"address_1"]
                                                     customer_number:ship_to_address[@"customer_number"]
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


- (IBAction)authorizeCaptureVisaTransactionSplit:(id)sender{}
- (IBAction)regularCaptureVisaTransactionSplit:(id)sender{}

// L2 L3 - Master Card
/*
 {
 "amount":"9200",
 "transaction_type":"purchase",
 "merchant_ref":"abc1412096293369",
 "method":"credit_card",
 "currency_code":"USD",
 "credit_card":{
 "type":"mastercard",
 "cardholder_name":"Eck Test 3",
 "card_number":"5186009100016415",
 "exp_date":"0416",
 "cvv":"123"
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
 */
- (IBAction)purchaseMasterCardTransactionSplit:(id)sender{}
- (IBAction)authorizeCaptureMasterCardTransactionSplit:(id)sender{}
- (IBAction)regularCaptureMasterCardTransactionSplit:(id)sender{}

/**********************
 Recurring payment
 
 Purchase	Amex
 Authorize	Amex
 Purchase	Visa
 Authorize	Visa
 Purchase	Master Card
 Authorize	Master Card
 Purchase	Discover
 Authorize	Discover
 **********************/

- (IBAction)authorizeAmexTransactionRecurringPayment:(id)sender{
}
- (IBAction)purchaseAmexTransactionRecurringPayment:(id)sender{}




- (IBAction)purchaseVisaTransactionRecurringPayment:(id)sender{
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"discover",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"6011000990099818",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizeDiscoverTransactionRecurringPayment:amount transactionType:@"purchase" merchantRef:@"abc1412096293369" pMethod:@"credit_card" currencyCode:@"USD" cardtype:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] eciIndicator:@"2" completion:^(NSDictionary *dict, NSError *error) {
            
            NSString *authStatusMessage = nil;
            
            if (error == nil)
            {
                authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@",
                                     [dict objectForKey:@"transaction_type"],
                                     [dict objectForKey:@"transaction_id"],
                                     [dict objectForKey:@"transaction_tag"]];
                
                
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
- (IBAction)authorizeVisaTransactionRecurringPayment:(id)sender{}

- (IBAction)purchaseMasterCardTransactionRecurringPayment:(id)sender{}
- (IBAction)authorizeMasterCardTransactionRecurringPayment:(id)sender{}

- (IBAction)purchaseDiscoverTransactionRecurringPayment:(id)sender{}


/*!
 * authorizeDiscoverTransactionRecurringPayment
 * \param
 * \returns
 */
- (IBAction)authorizeDiscoverTransactionRecurringPayment:(id)sender{
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"discover",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"6011000990099818",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizeOrPurchaseTransactionRecurringPayment:amount transactionType:@"purchase" merchantRef:@"abc1412096293369" pMethod:@"credit_card" currencyCode:@"USD" cardtype:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] eciIndicator:@"2" completion:^(NSDictionary *dict, NSError *error) {
            
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

//Soft descriptor - Visa
/*!
 *
 * \param
 * \returns
 */
- (IBAction)purchaseVisaTransactionSoftDescriptor:(id)sender{}


/*!
 * authorizeCaptureVisaTransactionSoftDescriptor
 * \param
 * \returns
 */
- (IBAction)authorizeCaptureVisaTransactionSoftDescriptor:(id)sender{
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"4012000033330026",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        
        NSDictionary* soft_desc = @{
                                    @"dba_name":@"SoftDesc 1",
                                    @"street":@"123 Main Street",
                                    @"region":@"NY",
                                    @"mid":@"367337278884",
                                    @"mcc":@"8812",
                                    @"postal_code":@"11375",
                                    @"country_code":@"USA",
                                    @"merchant_contact_info":@"123 Main street"
                                    };
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        [myClient submitAuthorizeTransactionWithSoftSescriptorsCreditCardDetails:amount transactionType:@"authorize"  merchantRefForProcessing:@"abc1412096293369" pMethod:@"credit_card" currencyCode:@"USD" cardtype:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] dbaNameSD:soft_desc[@"dba_name"] streetSD:soft_desc[@"street"] regionSD:soft_desc[@"region"] midSD:soft_desc[@"mid"] mccSD:soft_desc[@"mcc"] postalCodeSD:soft_desc[@"postal_code"] countryCodeSD:soft_desc[@"country_code"] merchantContactInfoSD:soft_desc[@"merchant_contact_info"]
         
         
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
- (IBAction)regularCaptureVisaTransactionSoftDescriptor:(id)sender{}

//Soft descriptor - Master Card
- (IBAction)purchaseMasterCardTransactionSoftDescriptor:(id)sender{}
- (IBAction)authorizeCaptureMasterCardTransactionSoftDescriptor:(id)sender{}
- (IBAction)regularCaptureMasterCardTransactionSoftDescriptor:(id)sender{}

//Soft descriptor - Discover
- (IBAction)purchaseDiscoverTransactionSoftDescriptor:(id)sender{}
- (IBAction)authorizeCaptureDiscoverTransactionSoftDescriptor:(id)sender{}
- (IBAction)regularCaptureDiscoverTransactionSoftDescriptor:(id)sender{}

//Soft descriptor - Discover
- (IBAction)purchaseAmexCardTransactionSoftDescriptor:(id)sender{}
- (IBAction)authorizeCaptureAmexTransactionSoftDescriptor:(id)sender{}
- (IBAction)regularCaptureAmexTransactionSoftDescriptor:(id)sender{}

//Transarmor

- (IBAction)authorizeVoidMastercardTransactionCVVTransarmor:(id)sender{}

/*!
 * ValueLink testcases
 *
 * \param id Entered value
 * \returns Alert
 */
- (IBAction)activationTransactionValueLink:(id)sender{
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* gift_card = @{
                                    @"cardholder_name":@"Joe Smith",
                                    @"cc_number":@"7777061906912522",
                                    @"credit_card_type":@"Gift",
                                    @"card_cost":@"5"
                                    };
        
        NSDictionary* value_link = @{
                                     @"amount":@"6000",
                                     @"transaction_type":@"activation",
                                     @"method":@"valuelink",
                                     @"currency_code":@"USD"
                                     };
        
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKeyForValueLink apiSecret:KApiSecretForValueLink merchantToken:KTokenForValueLink url:KURL];
        
        [myClient submitActivationTransactionValueLink:gift_card[@"cardholder_name"] cardNumber:gift_card[@"cc_number"] cardType:gift_card[@"credit_card_type"]  cardCost:gift_card[@"card_cost"] totalAmt:amount transactiontype:value_link[@"transaction_type"] pMethod:value_link[@"method"] currencyCode:value_link[@"currency_code"]
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

/**
 
 **/
- (IBAction)nakedRefundDiscoverRefundTransaction:(id)sender{
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"discover",
                                      @"cardholder_name":@"Joe Smith",
                                      @"cc_number":@"7777061906912522",
                                      @"exp_date":@"0416",
                                      };
        
        NSDictionary* naked_payment = @{
                                        @"amount":amount,
                                        @"transaction_type":@"refund",
                                        @"method":@"credit_card",
                                        @"currency_code":@"USD"
                                        };
        
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKeyForValueLink apiSecret:KApiSecretForValueLink merchantToken:KTokenForValueLink url:KURL];
        
        
        [myClient submitNakedRefundDiscoverRefundTransaction:naked_payment[@"amount"] transactiontype:naked_payment[@"transaction_type"] pMethod:naked_payment[@"method"] currencyCode:naked_payment[@"currency_code"] cardType:credit_card[@"type"] cardholderName: credit_card[@"cardholder_name"] cardNumber:credit_card[@"cc_number"]  expDate:credit_card[@"exp_date"]
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

- (IBAction)purchaseTransactionValueLink:(id)sender{}
- (IBAction)cashoutNakedVoidTransactionValueLink:(id)sender{}
- (IBAction)reloadTaggedVoidTransactionValueLink:(id)sender{}
- (IBAction)purchaseNakedVoidTransactionValueLink:(id)sender{}
- (IBAction)purchaseTaggedVoidTransactionValueLink:(id)sender{}
- (IBAction)taggedRefundTaggedVoidTransactionValueLink:(id)sender{}
- (IBAction)nakedRefundTransactionValueLink:(id)sender{}
- (IBAction)balanceInquiryTransactionValueLink:(id)sender{}
- (IBAction)splitTenderingPurchaseTransactionValueLink:(id)sender{}



/*** **/
- (IBAction)purchaseTelecheckPersonalTransaction:(id)sender{
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSDictionary* tele_check = @{
                                     @"check_number": @"1234",
                                     @"check_type": @"P",
                                     @"account_number":@"003051075",
                                     @"routing_number":@"211372145",
                                     @"accountholder_name": @"Tom Eck",
                                     @"customer_id_type":@"0",
                                     @"customer_id_number":@"TX10531769",
                                     @"client_email":@"rajan.veeramani@firstdata.com",
                                     @"gift_card_amount":@"100",
                                     @"vip":@"n",
                                     @"clerk_id":@"RVK_001",
                                     @"device_id":@"jkhsdfjkhsk",
                                     @"release_type":@"X",
                                     @"registration_number":@"12345",
                                     @"registration_date":@"01012014",
                                     @"date_of_birth":@"01012010"
                                     };
        
        NSDictionary* billing_address = @{
                                          @"street": @"225 Liberty Street",
                                          @"city": @"NYC",
                                          @"state_province": @"NY",
                                          @"zip_postal_code": @"10281",
                                          @"country": @"US"
                                          };
        NSDictionary*  telecheck_personal = @{
                                              @"method": @"tele_check",
                                              @"transaction_type": @"purchase",
                                              @"amount": @"3700",
                                              @"currency_code": @"USD",
                                              @"merchant_ref":@"Telecheck_12345"
                                              };
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKeyForValueLink apiSecret:KApiSecretForValueLink merchantToken:KTokenForValueLink url:KURL];
        
        [myClient submitPurchaseTelecheckPersonalTransaction:tele_check[@"check_number"] checkType:tele_check[@"check_type"] accountNumber:tele_check[@"account_number"] routingNumber:tele_check[@"routing_number"] accountholderName:tele_check[@"accountholder_name"] customerIdType:tele_check[@"customer_id_type"]  customerIdNumber:tele_check[@"customer_id_number"]  clientEmail:tele_check[@"client_email"] giftCardAmount:tele_check[@"gift_card_amount"] vip:tele_check[@"vip"]  clerkId:tele_check[@"clerk_id"]  deviceId:tele_check[@"device_id"] releaseType:tele_check[@"release_type"]registrationNumber:tele_check[@"registration_number"] registrationDate:tele_check[@"registration_date"]  dateOfBirth:tele_check[@"date_of_birth"]   street:billing_address[@"street"]   city:billing_address[@"city"]   stateProvince:billing_address[@"state_province"]  zipPostalCode:billing_address[@"zip_postal_code"]  country:billing_address[@"country"]
                                                     pMethod:telecheck_personal[@"method"]     transactionType:telecheck_personal[@"transaction_type"] totalAmount:amount currencyCode:telecheck_personal[@"currency_code"]   merchantRef:telecheck_personal[@"merchant_ref"]
         
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
 * \param
 * \returns
 */
- (IBAction)authorizeTransaction:(id)sender {
    
    [self authorizeAmt0VisaTransactionCVV:@"450" ];
    
}

@end
