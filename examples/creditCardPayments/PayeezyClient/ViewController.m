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
#define KApiKey     @"y6pWAJNyJyjGv66IsVuWnklkKUPFbb0a"
#define KApiSecret  @"86fbae7030253af3cd15faef2a1f4b67353e41fb6799f576b5093ae52901e6f786fbae7030253af3cd15faef2a1f4b67353e41fb6799f576b5093ae52901e6f7"
#define KToken      @"fdoa-a480ce8951daa73262734cf102641994c1e55e7cdf4c02b6"
#define KURL        @"https://api-cert.payeezy.com/v1/transactions"

@implementation ViewController

/*!
 * authorize Capture Visa Transaction
 * \param id
 * \returns IBAction
 */
- (IBAction)authorizeCaptureVisaTransactionCVV:(id)sender {
    
    NSString* cardHolderName = _card_holder_name.text;
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    NSString* cardNumber  = _card_number.text;
    NSString* cardSecurityCode = _card_security_code.text;
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card inf
        NSDictionary* credit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":cardHolderName,
                                      @"card_number":cardNumber,
                                      @"exp_date":@"0450",
                                      @"cvv":cardSecurityCode
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


@end
