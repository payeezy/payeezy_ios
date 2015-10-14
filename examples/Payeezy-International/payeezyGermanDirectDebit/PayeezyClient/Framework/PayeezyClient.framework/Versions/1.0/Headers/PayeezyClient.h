//
//  PayeezyClient.h
//  PayeezyClient
//
//  Created by First Data Corporation on 8/28/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double PayeezyClientVersionNumber;

FOUNDATION_EXPORT const unsigned char PayeezyClientVersionString[];

/*************************      Start of Protocol PayeezyClient       *************************************/

@protocol PayeezyClient <NSObject>

/*********************************************************************************************************
 *                                      PayeezyClient init method                                            *
 ********************************************************************************************************/

-(id)initWithApiKey:(NSString *)apiKey
          apiSecret:(NSString *)apiSecret
      merchantToken:(NSString *)merchantToken;

/********************************************************************************************************
 *         PayeezyClient 3DS method that takes in encoded payment data object - PKPaymentRequestToken       *
 *                                      returns a response and error                                    *
 *******************************************************************************************************/

-(void)submit3DSTransactionWithPaymentInfo:(NSData *)paymentData
                           transactionType:(NSString *)transactionType
                           applicationData:(NSData *)applicationData
                        merchantIdentifier:(NSString *)merchantIdentifier
                                completion:(void(^)(NSDictionary *response, NSError *error))completion;

/*********************************************************************************************************
 *      PayeezyClient method to process credit card payments regardless to PKPayment supported devices       *
 ********************************************************************************************************/

-(void)submitAuthorizeTransactionWithCreditCardDetails:(NSString*)cardType
                                        cardHolderName:(NSString*)cardHolderName
                                            cardNumber:(NSString*)cardNumber
                               cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                               cardCVV:(NSString*)cardCVV
                                          currencyCode:(NSString*)currenyCode
                                           totalAmount:(NSString*)totalAmount
                              merchantRefForProcessing:(NSString*)merchantRef
                                            completion:(void (^)(NSDictionary *dict, NSError* error))completion;


-(void)submitPurchaseTransactionWithCreditCardDetails:(NSString*)cardType
                                       cardHolderName:(NSString*)cardHolderName
                                           cardNumber:(NSString*)cardNumber
                              cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                              cardCVV:(NSString*)cardCVV
                                         currencyCode:(NSString*)currencyCode
                                          totalAmount:(NSString*)totalAmount
                             merchantRefForProcessing:(NSString*)merchantRef
                                           completion:(void (^)(NSDictionary *dict, NSError* error))completion;

@end

/***************************      End of Protocol PayeezyClient       *************************************/


@interface PayeezyClient : NSObject<NSURLConnectionDelegate,NSURLSessionDelegate,PayeezyClient>


@property (nonatomic,strong) NSString* apiKey;
@property (nonatomic,strong) NSString* apiSecret;
@property (nonatomic,strong) NSString* merchantToken;
@property (nonatomic,strong) NSString* url;


@end
