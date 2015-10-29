//
//  PayeezySDK.m
//  PayeezyClientSample
//
//  Created by Atul Parmar on 2/24/15.
//  Copyright (c) 2015 First Data Corporation. All rights reserved.
//

#import "PayeezySDK.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import <Security/SecRandom.h>
#import "SBJson4Writer.h"
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define STATUS_KEY_NAME @"validation_status"
#define SERVER_ERROR_MSG @"Internal Server Error. Please try later"

#define URL_TRANSACTIONS_CERT @"https://api-cert.payeezy.com/v1/transactions"
#define URL_TRANSACTIONS_PROD @"https://api.payeezy.com/v1/transactions"
#define URL_TRANSACTIONS_CAT @"https://api-cat.payeezy.com/v1/transactions"
#define URL_TRANSACTIONS_QA @"https://api-qa.payeezy.com/v1/transactions"


@implementation PayeezySDK {
}


/**
 * PayeezyClient init method
 * Initialize with apikey, apiSecret, merchantToken
 * Refer developer.payeezy.com documentation to get apiKey,merchantToken and apiSecret
 @see For Sandbox use: https://api-cert.payeezy.com/v1/transactions
 @see For live transactions use:https://api.payeezy.com/v1/transactions
 @param apiKey
 @param apiSecret
 @param merchantToken
 @return Returns self
 @see
 */

-(id)initWithApiKey:(NSString *)apiKey
          apiSecret:(NSString *)apiSecret
      merchantToken:(NSString *)merchantToken
                url:(NSString *)url{
    self = [super init];
    if(self){
        
        self.apiKey = apiKey;
        self.apiSecret = apiSecret;
        self.merchantToken = merchantToken;
        self.url= url;
        //        networkReachability = [Reachability reachabilityForInternetConnection];
    }
    return self;
}


/**
 Security and Authentication
 Methods: secureRandomNumber, getEpochTimeStamp for HMAC
 @return Returns timeStamp String
 @see
 */

-(NSString *)getEpochTimeStamp
{
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f",round([[NSDate date]timeIntervalSince1970]*1000)];
    return timeStamp;
}

/**
 Security and Authentication
 Methods: secureRandomNumber, getEpochTimeStamp for HMAC
 @return Returns secure random number
 @see
 */

- (NSString *)secureRandomNumber
{
    unsigned int randomNumber;
    
    NSMutableData *data = [NSMutableData dataWithLength:kCCKeySizeAES256];
    
    SecRandomCopyBytes(kSecRandomDefault, [data length], data.mutableBytes);
    
    NSString* dataString = [self convertByteArrayToHexString:data];// data to hex
    
    NSScanner* scanner = [NSScanner scannerWithString:dataString];
    
    [scanner scanHexInt:&randomNumber];
    
    return [NSString stringWithFormat:@"%u",randomNumber];
}

/**
 *  PAuth 1.0 - Preferred Authentication using HMAC SHA256
 *
 *  This authentication scheme is been deviced to prevent payload tampering during transaction processing.
 *  Method: Append the following 5 key params (in same order) to obain the HMAC message string and compute 
 *  the HMAC of it using apiSecret. This is a shared secret between the developer and Payeezy.
 *
 *
 *  1. ApiKey (Obtained from Payeezy Site)
 *  2. Nonce(Secure-Random number string of length 19)
 *  3. Timestamp (Epoch UTC time stamp in milli seconds)
 *  4. Merchant Token  (Obtained from Payeezy Site)
 *  5. Payload (Use JSON string of payload to make the HMAC message string)
 *
 *   Note: APISECRET is also to be obtained from Payeezy site. Developers are advised not to share this
 *         with any other person due to security reasons.
 *
 *  Header Fields : 'Authorization' , 'timestamp' , 'nonce' follow the order
 *
 @param payload payload String
 @param timeStamp
 @param nonce
 @return Returns
 @see
 */


- (NSString*)generateHMACforpayload:(NSDictionary*)payload
                          timeStamp:(NSString*)timeStamp
                              nonce:(NSString*)nonce
{
    unsigned char outputHMAC[CC_SHA256_DIGEST_LENGTH];
    
    SBJson4Writer * parseString = [[SBJson4Writer alloc] init];
    
    NSString* payloadString = [parseString stringWithObject:payload];
    
    NSString *hmacData = [NSString stringWithFormat:@"%@%@%@%@%@",self.apiKey,nonce,timeStamp,self.merchantToken,payloadString];
    
    const char *keyChar = [self.apiSecret cStringUsingEncoding:NSASCIIStringEncoding];
    
    const char *dataChar = [hmacData cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA256, keyChar, strlen(keyChar), dataChar, strlen(dataChar), outputHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:outputHMAC length:sizeof(outputHMAC)];
    
    
    //    get NSData as hex string - another alternative to use deprecated method -(NSString*)convertByteArrayToHexString:(NSData*)dataToBeConverted{
    //    NSString* hmacString = [self convertByteArrayToHexString:HMAC]; // Get HMAC hash in hex
    
    //    TODO: better way to convert ByteArray to hex.
    
    NSString*hmacString = [self convertByteArrayToHexString:HMAC];
    
    
    //    Return Base64 of (HMAC hash in hex)
    return [[hmacString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    
}


/**
 Make Payload For Transactions (3DS and Credit Card)
 @param transactionType NSString
 @param applicationData NSData
 @param merchantIdentifier NSString
 @param payloadBlobFor3DSOREMV NSDictionary
 @param merchantRef NSString
 @return Returns payload string
 @see
 */

- (NSDictionary *) construct3DSPayloadWithTransactionType:(NSString *)transactionType
                                          applicationData:(NSData *)applicationData
                                       merchantIdentifier:(NSString *)merchantIdentifier
                                              payloadDict:(NSDictionary *)payloadBlobFor3DSOREMV
                                              merchantRef:(NSString *)merchantRef

{
    // Construct the inner "3DS" object
    NSMutableDictionary* inner3DSDict = [[NSMutableDictionary alloc] initWithDictionary:payloadBlobFor3DSOREMV];
    inner3DSDict[@"merchantIdentifier"] = merchantIdentifier;
    inner3DSDict[@"type"] = @"A";
    
    if( nil != applicationData ) {
        NSMutableDictionary *newHeader = [NSMutableDictionary dictionaryWithDictionary:inner3DSDict[@"header"]];
        newHeader[@"applicationDataHash"] = newHeader[@"applicationData"];
        [newHeader removeObjectForKey:@"applicationData"];
        inner3DSDict[@"applicationData"] = [applicationData base64EncodedStringWithOptions:0];
        inner3DSDict[@"header"] = newHeader;
    }
    
    // Construct the outer object
    
    NSDictionary*generatedDict = @{
                                   @"3DS":inner3DSDict,
                                   @"method":@"3DS",
                                   @"transaction_type":transactionType
                                   };
    
    NSMutableDictionary* resultDict = [[NSMutableDictionary alloc] initWithDictionary:generatedDict];
    
    
    if (nil!=merchantRef) {
        resultDict[@"merchant_ref"] = merchantRef;
    }
    
    NSLog(@"Simulated 3DS request: %@",resultDict);
    return resultDict;
}



/**
 Define request structure for RecurringPayment
 @param totalAmount
 @param transactionType
 @param cardHolderName
 @param cardNumber
 @param cardExpirymMonthAndYear
 @param cardCVV
 @param eciIndicator
 @return Returns
 @see
 */
- (NSDictionary*)constructCreditCardPayloadWithCardRecurringPayment:(NSString *)totalAmount transactionType:(NSString *)transactionType merchantRef:(NSString *)merchantRef pMethod:(NSString *)pMethod currencyCode:(NSString *)currencyCode cardtype:(NSString *)cardtype cardHolderName:(NSString *)cardHolderName  cardNumber:(NSString *)cardNumber cardExpirymMonthAndYear:(NSString *)cardExpirymMonthAndYear cardCVV:(NSString *)cardCVV eciIndicator:(NSString *)eciIndicator
{
    
    NSArray *crediCardKeys = @[
                               @"type",
                               @"cardholder_name",
                               @"card_number",
                               @"exp_date",
                               @"cvv",
                               ];
    
    NSArray *crediCardValues = @[
                                 cardtype,
                                 cardHolderName,
                                 cardNumber,
                                 cardExpirymMonthAndYear,
                                 cardCVV,
                                 ];
    
    NSDictionary *crediCard_dict = [NSDictionary dictionaryWithObjects:crediCardValues forKeys:crediCardKeys];
    
    NSArray *payloadKeys = @[
                             @"amount",
                             @"transaction_type",
                             @"merchant_ref",
                             @"method",
                             @"currency_code",
                             @"credit_card",
                             @"eci_indicator"
                             ];
    
    NSArray *payloadValues = @[
                               totalAmount,
                               transactionType,
                               merchantRef,
                               pMethod,
                               currencyCode,
                               crediCard_dict,
                               eciIndicator
                               ];
    
    return [NSDictionary dictionaryWithObjects:payloadValues forKeys:payloadKeys];
}



/**
 Define request structure for L2 Authorize Transaction
 @param totalAmount
 @param transactionType
 @param merchantRef
 @param pMethod
 @param currencyCode
 @param cardtype
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param cardCVV
 @param tax1Amount
 @param tax1Number
 @param tax2Amount
 @param tax2Number
 @param customerRef
 @param street
 @param city
 @param stateProvince
 @param zipPostal
 @param country
 @return Returns
 @see
 */

- (NSDictionary*) constructAuthorizeTransactionL2WithCreditCardDetails:(NSString*)totalAmount
                                                       transactionType:(NSString*)transactionType
                                                           merchantRef:(NSString*)merchantRef
                                                               pMethod:(NSString*)pMethod
                                                          currencyCode:(NSString*)currencyCode

                                                              cardtype:(NSString*)cardtype
                                                        cardHolderName:(NSString*)cardHolderName
                                                            cardNumber:(NSString*)cardNumber
                                                           cardExpMMYY:(NSString*)cardExpMMYY
                                                               cardCVV:(NSString*)cardCVV

                                                            tax1Amount:(NSString*)tax1Amount
                                                            tax1Number:(NSString*)tax1Number
                                                            tax2Amount:(NSString*)tax2Amount
                                                            tax2Number:(NSString*)tax2Number
                                                           customerRef:(NSString*)customerRef
                                                                street:(NSString*)street
                                                                  city:(NSString*)city
                                                         stateProvince:(NSString*)stateProvince
                                                         zipPostalCode:(NSString*)zipPostalCode
                                                               country:(NSString*)country{
    
    NSArray *crediCardKeys = @[
                               @"type",
                               @"cardholder_name",
                               @"card_number",
                               @"exp_date",
                               @"cvv",
                               ];
    
    NSArray *crediCardValues = @[
                                 cardtype,
                                 cardHolderName,
                                 cardNumber,
                                 cardExpMMYY,
                                 cardCVV,
                                 ];
    
    NSDictionary *crediCard_dict = [NSDictionary dictionaryWithObjects:crediCardValues forKeys:crediCardKeys];
    
    NSArray *level2keys = @[
                            @"tax1_amount",
                            @"tax1_number",
                            @"tax2_amount",
                            @"tax2_number",
                            @"customer_ref"
                            ];
    
    NSArray *level2Values = @[
                              tax1Amount,
                              tax1Number,
                              tax2Amount,
                              tax2Number,
                              customerRef
                              ];
    
    NSDictionary *level2_dict = [NSDictionary dictionaryWithObjects:level2Values forKeys:level2keys];
    
 
    
    NSArray *billingAddressKeys = @[
                                    @"city",
                                    @"country",
                                    @"state_province",
                                    @"zip_postal_code"
                                    ];
    
    NSArray *billingAddressValues = @[
                                      city,
                                      country,
                                      stateProvince,
                                      zipPostalCode
                                      ];
    
    NSDictionary *billingAddress_dict = [NSDictionary dictionaryWithObjects:billingAddressValues forKeys:billingAddressKeys];
    
    
    NSArray *payloadKeys = @[
                             @"amount",
                             @"transaction_type",
                             @"merchant_ref",
                             @"method",
                             @"currency_code",
                             @"credit_card",
                             @"level2",
                             @"billing_address"
                            ];
    
    NSArray *payloadValues = @[
                               totalAmount,
                               transactionType,
                               merchantRef,
                               pMethod,
                               currencyCode,
                               crediCard_dict,
                               level2_dict,
                               billingAddress_dict
                               ];
    
    return [NSDictionary dictionaryWithObjects:payloadValues forKeys:payloadKeys];
}

/**
 Define request structure for L2 and L3 Purchase Transaction
 @param amount
 @param transactionType
 @param merchantRefForProcessing
 @param pMethod
 @param currencyCode
 @param cardtype
 @param cardHolderName
 @param cardNumber
 @param cardExpirymMonthAndYear
 @param cardCVV
 @param tax1Amount
 @param tax1Number
 @param tax2Amount
 @param tax2Number
 @param customerRef
 @param description
 @param quantity
 @param commodity_code
 @param discount_amount
 @param discount_indicator
 @param gross_net_indicator
 @param line_item_total
 @param product_code
 @param tax_amount
 @param tax_rate
 @param tax_type
 @param unit_cost
 @param unit_of_measure
 @param alt_tax_amount
 @param duty_amount
 @param freight_amount
 @param ship_from_zip
 @param city
 @param state
 @param zip
 @param country
 @param email
 @param name
 @param phone
 @param address_1
 @param customer_number
 @return Returns
 @see
 */

- (NSDictionary*) constructPurchaseTransactionL2L3WithCreditCardDetails:(NSString*)amount
                                                        transactionType:(NSString*)transactionType
                                               merchantRefForProcessing:(NSString*)merchantRefForProcessing
                                                                pMethod:(NSString*)pMethod
                                                           currencyCode:(NSString*)currencyCode
                                                               cardtype:(NSString*)cardtype
                                                         cardHolderName:(NSString*)cardHolderName
                                                             cardNumber:(NSString*)cardNumber
                                                cardExpirymMonthAndYear:(NSString*)cardExpirymMonthAndYear
                                                                cardCVV:(NSString*)cardCVV
                                                             tax1Amount:(NSNumber*)tax1Amount
                                                             tax1Number:(NSString*)tax1Number
                                                             tax2Amount:(NSNumber*)tax2Amount
                                                             tax2Number:(NSString*)tax2Number
                                                            customerRef:(NSString*)customerRef
                                                            description:(NSString*)description
                                                               quantity:(NSString*)quantity
                                                         commodity_code:(NSString*)commodity_code
                                                        discount_amount: (NSString*)discount_amount
                                                     discount_indicator:(NSString*)discount_indicator
                                                    gross_net_indicator:(NSString*)gross_net_indicator
                                                        line_item_total:(NSString*)line_item_total
                                                           product_code:(NSString*)product_code
                                                             tax_amount:(NSString*)tax_amount
                                                               tax_rate:(NSString*)tax_rate
                                                               tax_type:(NSString*)tax_type
                                                              unit_cost:(NSString*)unit_cost
                                                        unit_of_measure:(NSString*)unit_of_measure
                                                         alt_tax_amount:(NSString*)alt_tax_amount
                                                             alt_tax_id:(NSString*)alt_tax_id
                                                     l3_discount_amount:(NSString*)l3_discount_amount
                                                            duty_amount:(NSString*)duty_amount
                                                         freight_amount:(NSString*)freight_amount
                                                          ship_from_zip:(NSString*)ship_from_zip
                                                                   city:(NSString*)city
                                                                  state:(NSString*)state
                                                                    zip:(NSString*)zip
                                                                country:(NSString*)country
                                                                  email:(NSString*)email
                                                                   name:(NSString*)name
                                                                  phone:(NSString*)phone
                                                              address_1:(NSString*)address_1
                                                        customer_number:(NSString*)customer_number{
    
    NSArray *crediCardKeys = @[
                               @"type",
                               @"cardholder_name",
                               @"card_number",
                               @"exp_date",
                               @"cvv",
                               ];
    
    NSArray *crediCardValues = @[
                                 cardtype,
                                 cardHolderName,
                                 cardNumber,
                                 cardExpirymMonthAndYear,
                                 cardCVV,
                                 ];
    
    NSDictionary *crediCard_dict = [NSDictionary dictionaryWithObjects:crediCardValues forKeys:crediCardKeys];
    
    
    
    NSArray *level2keys = @[
                            @"tax1_amount",
                            @"tax1_number",
                            @"tax2_amount",
                            @"tax2_number",
                            @"customer_ref"
                            ];
    
    NSArray *level2Values = @[
                              tax1Amount,
                              tax1Number,
                              tax2Amount,
                              tax2Number,
                              customerRef
                              ];
    
    NSDictionary *level2_dict = [NSDictionary dictionaryWithObjects:level2Values forKeys:level2keys];
    
    NSArray *ship_to_addresskeys = @[
                                     @"city",
                                     @"state",
                                     @"zip",
                                     @"country",
                                     @"email",
                                     @"name",
                                     @"phone",
                                     @"address_1",
                                     @"customer_number"
                                     ];
    
    NSArray *ship_to_addressValues = @[
                                       city,
                                       state,
                                       zip,
                                       country,
                                       email,
                                       name,
                                       phone,
                                       address_1,
                                       customer_number
                                       ];
    
    NSDictionary *ship_to_address_dict = [NSDictionary dictionaryWithObjects:ship_to_addressValues forKeys:ship_to_addresskeys];

    NSDictionary *firstJsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"item 1",@"description",
                                         @"5",@"quantity",
                                         @"C",@"commodity_code",
                                         @"1",@"discount_amount",
                                         @"G",@"discount_indicator",
                                         @"P",@"gross_net_indicator",
                                         @"10",@"line_item_total",
                                         @"F",@"product_code",
                                         @"5",@"tax_amount",
                                         @"0.2800000000000000266453525910037569701671600341796875",@"tax_rate",
                                         @"Federal",@"tax_type",
                                         @"1",@"unit_cost",
                                         @"meters", @"unit_of_measure",
                                         nil];
    
    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    
    [arr addObject:firstJsonDictionary];
    
    NSArray *level3keys = @[
                            @"alt_tax_amount",
                            @"alt_tax_id",
                            @"discount_amount",
                            @"duty_amount",
                            @"freight_amount",
                            @"ship_from_zip",
                            @"ship_to_address",
                            @"line_items"
                            ];
    
    NSArray *level3Values = @[
                              alt_tax_amount,
                              alt_tax_id,
                              l3_discount_amount,
                              duty_amount,
                              freight_amount,
                              ship_from_zip,
                              ship_to_address_dict,
                              arr
                              ];
    
    NSDictionary *level3_dict = [NSDictionary dictionaryWithObjects:level3Values forKeys:level3keys];
    
    
    
    NSArray *payloadKeys = @[
                             @"amount",
                             @"transaction_type",
                             @"merchant_ref",
                             @"method",
                             @"currency_code",
                             @"credit_card",
                             @"level2",
                             @"level3",
                             
                             ];
    
    NSArray *payloadValues = @[
                               amount,
                               transactionType,
                               merchantRefForProcessing,
                               pMethod,
                               currencyCode,
                               crediCard_dict,
                               level2_dict,
                               level3_dict
                              
                               ];
    
    return [NSDictionary dictionaryWithObjects:payloadValues forKeys:payloadKeys];
    
    
}



/**
 Define request structure for Activation Transaction ValueLinkPayload
 @param cardHolderName
 @param cardNumber
 @param cardType
 @param cardCost
 @param totalAmt
 @param transactiontype
 @param pMethod
 @param currencyCode
 @return Returns
 @see
 */

- (NSDictionary*)constructActivationTransactionValueLinkPayload:(NSString *)cardHolderName
   cardNumber:(NSString *)cardNumber cardType:(NSString *)cardType cardCost:(NSString*)cardCost totalAmt:(NSString *)totalAmt transactiontype:(NSString *)transactiontype pMethod:(NSString *)pMethod currencyCode:(NSString *)currencyCode
{
    NSArray *giftCardKeys = @[
                               @"cardholder_name",
                               @"cc_number",
                               @"credit_card_type",
                               @"card_cost"
                            ];
    
    NSArray *giftCardValues = @[
                                 cardHolderName,
                                 cardNumber,
                                 cardType,
                                 cardCost
                                 ];
    
    NSDictionary *giftCard_dict = [NSDictionary dictionaryWithObjects:giftCardValues forKeys:giftCardKeys];
    
    NSArray *valueLinkPayloadKeys = @[
                             @"amount",
                             @"transaction_type",
                             @"method",
                             @"amount",
                             @"currency_code",
                             @"valuelink"
                             ];
    
    NSArray *valueLinkPayloadValues = @[
                               totalAmt,
                               transactiontype,
                               pMethod,
                               totalAmt,
                               currencyCode,
                               giftCard_dict
                               ];
    
    return [NSDictionary dictionaryWithObjects:valueLinkPayloadValues forKeys:valueLinkPayloadKeys];
}

/**
 Define request structure for NakedRefund Discover Refund Transaction
 @param amount
 @param transactiontype
 @param pMethod
 @param currencyCode
 @param cardType
 @param cardholderName
 @param cardNumber
 @param expDate
 @return Returns
 @see
 */
- (NSDictionary*)constructNakedRefundDiscoverRefundTransaction:(NSString*)amount
                                               transactiontype:(NSString*)transactiontype
                                                       pMethod:(NSString*)pMethod
                                                  currencyCode:(NSString*)currencyCode
                                                      cardType:(NSString*)cardType
                                                cardholderName:(NSString*)cardholderName
                                                    cardNumber:(NSString*)cardNumber
                                                       expDate:(NSString*)expDate
{
    NSArray *creditCardKeys  = @[
                                 @"type",
                                 @"cardholder_name",
                                 @"card_number",
                                 @"exp_date"
                                 ];
    
    NSArray *creditCardValues = @[
                                  cardType,
                                  cardholderName,
                                  cardNumber,
                                  expDate
                                  ];
    NSDictionary *creditCard_dict = [NSDictionary dictionaryWithObjects:creditCardValues forKeys:creditCardKeys];
    
    
    NSArray *payloadKeys = @[
                                      @"amount",
                                      @"transaction_type",
                                      @"method",
                                      @"currency_code",
                                      @"credit_card"
                                      ];
    
    NSArray *payloadValues = @[
                                        amount,
                                        transactiontype,
                                        pMethod,
                                        currencyCode,
                                        creditCard_dict
                                        ];
    
    return [NSDictionary dictionaryWithObjects:payloadValues forKeys:payloadKeys];
}

/**
 Define request structure for Authorize Split Discover Transaction
 @param totalAmount
 @param split_transaction_tag
 @param split_transaction_type
 @param split_split_shipment
 @param split_method
 @param split_merchant_ref
 @param split_currency_code
 @return Returns
 @see
 */

- (NSDictionary*)constructAuthorizeSplitDiscoverTransaction:(NSString*)totalAmount
                                      split_transaction_tag:(NSString*)split_transaction_tag
                                     split_transaction_type:(NSString*)split_transaction_type
                                       split_split_shipment:(NSString*)split_split_shipment
                                               split_method:(NSString*)split_method
                                         split_merchant_ref:(NSString*)split_merchant_ref
                                        split_currency_code:(NSString*)split_currency_code
{
    NSArray *splitKeys = @[
                           @"merchant_ref",
                           @"transaction_tag",
                           @"transaction_type",
                           @"split_shipment",
                           @"method",
                           @"amount",
                           @"currency_code"
                           ];
    
    NSArray *splitValues = @[
                             split_merchant_ref,
                             split_transaction_tag,
                             split_transaction_type,
                             split_split_shipment,
                             split_method,
                             totalAmount,
                             split_currency_code
                             ];
    
    
    return [NSDictionary dictionaryWithObjects:splitValues forKeys:splitKeys];
}



/**
 Define request structure for CreditCard Payload With Card CVV
 @param cardCVV  credit-card payload parameter
 @param cardExpMMYY credit-card payload parameter
 @param cardNumber credit-card payload parameter
 @param cardHolderName credit-card payload parameter
 @param cardType creditcard payload parameter
 @param currencyCode
 @param totalAmount
 @param cardType
 @param currencyCode
 @param totalAmount
 @param merchantRef
 @param transactionType
 @return Returns
 @see
 */

- (NSDictionary*)constructCreditCardPayloadWithCardCVV:(NSString *)cardCVV cardExpMMYY:(NSString *)cardExpMMYY cardNumber:(NSString *)cardNumber cardHolderName:(NSString *)cardHolderName cardType:(NSString *)cardType currencyCode:(NSString *)currencyCode totalAmount:(NSString *)totalAmount merchantRef:(NSString *)merchantRef transactionType:(NSString*)transactionType
{
    NSArray *crediCardKeys = @[
                               @"type",
                               @"cardholder_name",
                               @"card_number",
                               @"exp_date",
                               @"cvv",
                               ];
    
    NSArray *crediCardValues = @[
                                 cardType,
                                 cardHolderName,
                                 cardNumber,
                                 cardExpMMYY,
                                 cardCVV,
                                 ];
    
    NSDictionary *crediCard_dict = [NSDictionary dictionaryWithObjects:crediCardValues forKeys:crediCardKeys];
    
    NSArray *payloadKeys = @[
                             @"merchant_ref",
                             @"transaction_type",
                             @"method",
                             @"amount",
                             @"currency_code",
                             @"credit_card"
                             ];
    
    NSArray *payloadValues = @[
                               merchantRef,
                               transactionType,
                               @"credit_card",
                               totalAmount,
                               currencyCode,
                               crediCard_dict
                               ];
    
    return [NSDictionary dictionaryWithObjects:payloadValues forKeys:payloadKeys];
}




/**
 Define request structure for Transaction With SoftSescriptors CreditCardPay load
 @param totalAmount
 @param transactionType
 @param merchantRef
 @param pMethod
 @param currencyCode
 @param cardtype
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param cardCVV
 @param dbaNameSD
 @param streetSD
 @param regionSD
 @param midSD
 @param mccSD
 @param postalCodeSD
 @param countryCodeSD
 @param merchantContactInfoSD
 @return Returns
 @see
 */

- (NSDictionary*)constructTransactionWithSoftSescriptorsCreditCardPayload:(NSString*)totalAmount   transactionType:(NSString*)transactionType merchantRef:(NSString*)merchantRef pMethod:(NSString*)pMethod currencyCode:(NSString*)currencyCode cardtype:(NSString*)cardtype cardHolderName:(NSString*)cardHolderName cardNumber:(NSString*)cardNumber cardExpMMYY:(NSString *)cardExpMMYY cardCVV:(NSString*)cardCVV dbaNameSD:(NSString*)dbaNameSD streetSD:(NSString*)streetSD regionSD:(NSString*)regionSD midSD:(NSString *)midSD mccSD:(NSString*)mccSD postalCodeSD:(NSString*)postalCodeSD countryCodeSD:(NSString*)countryCodeSD  merchantContactInfoSD:(NSString*) merchantContactInfoSD
{
    NSArray *crediCardKeys = @[
                               @"type",
                               @"cardholder_name",
                               @"card_number",
                               @"exp_date",
                               @"cvv",
                               ];
    
    NSArray *crediCardValues = @[
                                 cardtype,
                                 cardHolderName,
                                 cardNumber,
                                 cardExpMMYY,
                                 cardCVV,
                                 ];
    
    NSDictionary *crediCard_dict = [NSDictionary dictionaryWithObjects:crediCardValues forKeys:crediCardKeys];

    
    NSArray *softDescriptorsKeys = @[
                                     @"dba_name",
                                     @"street",
                                     @"region",
                                     @"mid",
                                     @"mcc",
                                     @"postal_code",
                                     @"country_code",
                                     @"merchant_contact_info"
                                     ];
    
    NSArray *softDescriptorsValues = @[
                                       dbaNameSD,
                                       streetSD,
                                       regionSD,
                                       midSD,
                                       mccSD,
                                       postalCodeSD,
                                       countryCodeSD,
                                       merchantContactInfoSD,
                                       ];
    
    NSDictionary *soft_descriptors_dict = [NSDictionary dictionaryWithObjects:softDescriptorsValues forKeys:softDescriptorsKeys];

    
    NSArray *payloadKeys = @[
                             @"amount",
                             @"transaction_type",
                             @"merchant_ref",
                             @"currency_code",
                             @"method",
                             @"credit_card",
                             @"soft_descriptors"
                             ];
    
    NSArray *payloadValues = @[
                               totalAmount,
                               transactionType,
                               merchantRef,
                               currencyCode,
                               pMethod,
                               crediCard_dict,
                               soft_descriptors_dict,
                               ];
    
    return [NSDictionary dictionaryWithObjects:payloadValues forKeys:payloadKeys];
}



/**
 Define request structure for Transaction With SoftSescriptors CreditCardPay load
 @param cardType
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param phoneType
 @param phoneNumber
 @param billingCity
 @param billingCountry
 @param billingEmail
 @param billingStreet
 @param billingState
 @param billingZipCode
 @param currencyCode
 @param totalAmount
 @param transactionType
 @param merchantRefForProcessing
 @return Returns
 @see
 */

- (NSDictionary*)constructCreditCardPayloadWithCardAVS:(NSString *)cardType cardHolderName:(NSString *)cardHolderName cardNumber:(NSString *)cardNumber cardExpMMYY:(NSString *)cardExpMMYY  phoneType:(NSString *)phoneType phoneNumber:(NSString *)phoneNumber billingCity:(NSString *)billingCity billingCountry:(NSString*)billingCountry  billingEmail:(NSString*)billingEmail billingStreet:(NSString*)billingStreet  billingState:(NSString*)billingState    billingZipCode:(NSString*)billingZipCode currencyCode:(NSString*)currencyCode  totalAmount:(NSString*)totalAmount transactionType:(NSString*)transactionType merchantRefForProcessing:(NSString*)merchantRef
{
    
    NSArray *billingAddressPhoneKeys = @[
                                         @"type",
                                         @"number"
                                         ];
    
    NSArray *billingAddressPhoneValues = @[
                                           phoneType,
                                           phoneNumber
                                           ];
    
    NSDictionary *billingAddressPhone_dict = [NSDictionary dictionaryWithObjects:billingAddressPhoneValues forKeys:billingAddressPhoneKeys];
    
    NSArray *billingAddressKeys = @[
                                    @"city",
                                    @"country",
                                    @"email",
                                    @"street",
                                    @"state_province",
                                    @"zip_postal_code",
                                    @"phone"
                                    ];
    
    NSArray *billingAddressValues = @[
                                      billingCity,
                                      billingCountry,
                                      billingEmail,
                                      billingStreet,
                                      billingState,
                                      billingZipCode,
                                      billingAddressPhone_dict
                                      ];
    
    NSDictionary *billingAddress_dict = [NSDictionary dictionaryWithObjects:billingAddressValues forKeys:billingAddressKeys];
    
    NSArray *crediCardKeys = @[
                               @"type",
                               @"cardholder_name",
                               @"card_number",
                               @"exp_date"
                               ];
    
    NSArray *crediCardValues = @[
                                 cardType,
                                 cardHolderName,
                                 cardNumber,
                                 cardExpMMYY
                                ];
    
    NSDictionary *crediCard_dict = [NSDictionary dictionaryWithObjects:crediCardValues forKeys:crediCardKeys];
    
    NSArray *payloadKeys = @[
                             @"amount",
                             @"transaction_type",
                             @"merchant_ref",
                             @"method",
                             @"currency_code",
                             @"credit_card",
                             @"billing_address"
                             ];
    
    NSArray *payloadValues = @[
                               totalAmount,
                               transactionType,
                               merchantRef,
                               @"credit_card",   
                               currencyCode,
                               crediCard_dict,
                               billingAddress_dict
                               ];
    
    return [NSDictionary dictionaryWithObjects:payloadValues forKeys:payloadKeys];
}

/**
 Define request structure for Purchase TelecheckPersonal Transaction
 @param checkNumber
 @param checkType
 @param accountNumber
 @param routingNumber
 @param accountholderName
 @param customerIdType
 @param customerIdNumber
 @param clientEmail
 @param giftCardAmount
 @param vip
 @param clerkId
 @param deviceId
 @param releaseType
 @param registrationNumber
 @param registrationDate
 @param dateOfBirth
 @param street
 @param city
 @param stateProvince
 @param zipPostalCode
 @param country
 @param pMethod
 @param transactionType
 @param totalAmount
 @param currencyCode
 @param merchantRef
 @return Returns
 @see
 */
- (NSDictionary*)constructPurchaseTelecheckPersonalTransaction:(NSString*)checkNumber
                                                     checkType:(NSString*)checkType
                                                 accountNumber:(NSString*)accountNumber
                                                 routingNumber:(NSString*)routingNumber
                                             accountholderName:(NSString*)accountholderName
                                                customerIdType:(NSString*)customerIdType
                                              customerIdNumber:(NSString*)customerIdNumber
                                                   clientEmail:(NSString*)clientEmail
                                                giftCardAmount:(NSString*)giftCardAmount
                                                           vip:(NSString*)vip
                                                       clerkId:(NSString*)clerkId
                                                      deviceId:(NSString*)deviceId
                                                   releaseType:(NSString*)releaseType
                                            registrationNumber:(NSString*)registrationNumber
                                              registrationDate:(NSString*)registrationDate
                                                   dateOfBirth:(NSString*)dateOfBirth
                                                        street:(NSString*)street
                                                          city:(NSString*)city
                                                 stateProvince:(NSString*)stateProvince
                                                 zipPostalCode:(NSString*)zipPostalCode
                                                       country:(NSString*)country
                                                       pMethod:(NSString*)pMethod
                                               transactionType:(NSString*)transactionType
                                                   totalAmount:(NSString*)totalAmount
                                                  currencyCode:(NSString*)currencyCode
                                                   merchantRef:(NSString*)merchantRef
    {
    
        
        NSArray *billingAddressKeys = @[
                                        @"street",
                                        @"city",
                                        @"state_province",
                                        @"zip_postal_code",
                                        @"country"
                                        ];
        
        NSArray *billingAddressValues = @[
                                          street,
                                          city,
                                          stateProvince,
                                          zipPostalCode,
                                          country
                                          ];
        NSDictionary *billingAddress_dict = [NSDictionary dictionaryWithObjects:billingAddressValues forKeys:billingAddressKeys];
        
        NSArray *teleCheckKeys = @[
                                    @"check_number",
                                    @"check_type",
                                    @"account_number",
                                    @"routing_number",
                                    @"accountholder_name",
                                    @"customer_id_type",
                                    @"customer_id_number",
                                    @"client_email",
                                    @"gift_card_amount",
                                    @"vip",
                                    @"clerk_id",
                                    @"device_id",
                                    @"release_type",
                                    @"registration_number",
                                    @"registration_date",
                                    @"date_of_birth"
                                ];
        
        NSArray *teleCheckValues = @[
                                      checkNumber,
                                      checkType,
                                      accountNumber,
                                      routingNumber,
                                      accountholderName,
                                      customerIdType,
                                      customerIdNumber,
                                      clientEmail,
                                      giftCardAmount,
                                      vip,
                                      clerkId,
                                      deviceId,
                                      releaseType,
                                      registrationNumber,
                                      registrationDate,
                                      dateOfBirth,
                                    ];
        NSDictionary *teleCheck_dict = [NSDictionary dictionaryWithObjects:teleCheckValues forKeys:teleCheckKeys];
        
        NSArray *teleCheckMainKeys = @[
                                    @"method",
                                    @"transaction_type",
                                    @"amount",
                                    @"currency_code",
                                    @"merchant_ref",
                                    @"tele_check",
                                    @"billing_address"
                                    
                                    ];
        
        NSArray *teleCheckMainValues = @[
                                      pMethod,
                                      transactionType,
                                      totalAmount,
                                      currencyCode,
                                      merchantRef,
                                      teleCheck_dict,
                                      billingAddress_dict
                                      ];
        
        return [NSDictionary dictionaryWithObjects:teleCheckMainValues forKeys:teleCheckMainKeys];
}

/**
 Define request structure for Void Capture RefundCredit CardPayload
 @param merchantRef
 @param transactionTag
 @param transactionType
 @param transactionId
 @param paymentMethodType
 @param totalAmount
 @param currencyCode
 @return Returns payload string
 @see
 */

- (NSDictionary*)constructVoidCaptureRefundCreditCardPayload:(NSString *)merchantRef transactionTag:(NSString *)transactionTag  transactionType:(NSString*)transactionType transactionId:(NSString *)transactionId  paymentMethodType:(NSString *)paymentMethodType totalAmount:(NSString *)totalAmount currencyCode:(NSString *)currencyCode
{
    NSArray *payloadKeys = @[
                             @"merchant_ref",
                             @"transaction_tag",
                             @"transaction_type",
                           //  @"transaction_id",
                             @"method",
                             @"amount",
                             @"currency_code"
                             ];
    
    NSArray *payloadValues = @[
                               merchantRef,
                               transactionTag,
                               transactionType,
                            //   transactionId,
                               paymentMethodType,
                               totalAmount,
                               currencyCode
                               ];
    
    return [NSDictionary dictionaryWithObjects:payloadValues forKeys:payloadKeys];
}

/**
 Define request structure for Split CreditCard Payload
 @param merchantRef
 @param transactionTag
 @param transactionType
 @param paymentMethodType
 @param splitShipment
 @param totalAmount
 @param currencyCode
 @return Returns payload string
 @see
  */

- (NSDictionary*)constructSplitCreditCardPayload:(NSString *)merchantRef transactionTag:(NSString *)transactionTag  transactionType:(NSString*)transactionType paymentMethodType:(NSString *)paymentMethodType splitShipment:(NSString *)splitShipment totalAmount:(NSString *)totalAmount currencyCode:(NSString *)currencyCode
{
    NSArray *payloadKeys = @[
                             @"merchant_ref",
                             @"transaction_tag",
                             @"transaction_type",
                             @"split_shipment",
                             @"method",
                             @"amount",
                             @"currency_code"
                             ];
    
    NSArray *payloadValues = @[
                               merchantRef,
                               transactionTag,
                               transactionType,
                               splitShipment,
                               paymentMethodType,
                               totalAmount,
                               currencyCode
                               ];
    
    return [NSDictionary dictionaryWithObjects:payloadValues forKeys:payloadKeys];
}


/**
 Define request structure for postATransactionWithPayload
 @param payload

 */

-(void) postATransactionWithPayload:(NSDictionary*)payload
                         completion:(void(^)(NSDictionary *dict, NSError *error))completion
{
    BOOL networkStatus = [self isInternetReachable];
    //    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (!networkStatus) {
        completion(nil,[NSError errorWithDomain:@"No Internet Connection Found. Please connect to wifi or cellular data" code:100 userInfo:nil]);
    }else{
        [self processPaymentOnInternet:payload completion:completion];
    }
}

- (void)processPaymentOnInternet:(NSDictionary *)payload completion:(void (^)(NSDictionary *, NSError *))completion
{
    NSError* errDataConversion;
    
    NSString*timeStamp = [self getEpochTimeStamp];
    
    NSString *nonce = [self secureRandomNumber];
    
    NSString *hmacSignature = [self generateHMACforpayload:payload timeStamp:timeStamp nonce:nonce];
    
   // NSLog(@"Signature=%@,timestamp=%@,nonce=%@",hmacSignature,timeStamp,nonce);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:hmacSignature forHTTPHeaderField:@"Authorization"];
    [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" forHTTPHeaderField: @"User-Agent"];
    [request setValue:timeStamp forHTTPHeaderField:@"timestamp"];
    [request setValue:nonce forHTTPHeaderField:@"nonce"];
    [request setValue:self.apiKey forHTTPHeaderField:@"apikey"];
    [request setValue:self.merchantToken forHTTPHeaderField:@"token"];
    
    // Convert your data and set your request's HTTPBody property
    
    SBJson4Writer * parseString = [[SBJson4Writer alloc] init];
    
    NSString* payloadString = [parseString stringWithObject:payload];
    
   
    
    request.HTTPBody = [payloadString dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!errDataConversion) {
        // Create url connection and fire request
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *connectionError) {
            
            NSError* errJSONConverison;
            if (completion) {
                
                if (!connectionError) {
                    
                    if ([urlResponse respondsToSelector:@selector(statusCode)]) {
                        
                        if ([(NSHTTPURLResponse *) urlResponse statusCode] < 300) {
                            
                            NSDictionary* responseObject = [NSJSONSerialization
                                                            JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                            error:&errJSONConverison];
                             NSLog(@"Request: %@",payloadString);
                            completion(responseObject, nil);
                        }else{
                            
                            NSDictionary* errorObject = [NSJSONSerialization
                                                         JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                         error:&errJSONConverison];
                            NSLog(@"Request: %@",payloadString);
                            completion(nil, [NSError errorWithDomain:@"Payeezy Error Info" code:[(NSHTTPURLResponse *) urlResponse statusCode] userInfo:errorObject]);
                        }
                    }
                }else{
                    completion(nil,connectionError);
                }
            }
            
        }];
    }else{
        
        completion(nil,errDataConversion);
    }
    
    
}


/**
 First API Transaction Methods

 @param paymentData
 @param transactionType
 @param applicationData
 @param merchantIdentifier
 @param merchantRef
 @return Returns
 @see
 */


-(void)submit3DSTransactionWithPaymentInfo:(NSData *)paymentData
                           transactionType:(NSString *)transactionType
                           applicationData:(NSData *)applicationData
                        merchantIdentifier:(NSString *)merchantIdentifier
                               merchantRef:(NSString *)merchantRef
                                completion:(void(^)(NSDictionary *response, NSError *error))completion
{
    
    if ([[self.environment lowercaseString]  isEqual: @"prod"]) {
        self.url = URL_TRANSACTIONS_PROD;
    }else if([[self.environment lowercaseString]  isEqual: @"qa"]){
        self.url = URL_TRANSACTIONS_QA;
    }else if([[self.environment lowercaseString]  isEqual: @"cat"]){
        self.url = URL_TRANSACTIONS_CAT;
    }else if([[self.environment lowercaseString]  isEqual: @"test"]){
        self.url = URL_TRANSACTIONS_CERT;
    }else {
        self.url = URL_TRANSACTIONS_CERT;
    }
    
    //    self.url = ([[environment lowercaseString]  isEqual: @"test"])? URL_TRANSACTIONS_CERT: URL_TRANSACTIONS_PROD;
    
    NSError* nsDataConversionError;
    
    //     Decoding UTF8 encoded NSData to NSDictionary
    NSDictionary* payloadBlobFor3DSOREMV = [NSJSONSerialization
                                            JSONObjectWithData:paymentData
                                            options:NSJSONReadingAllowFragments
                                            error:&nsDataConversionError];
    
    NSDictionary *firstApiPayload =  [self construct3DSPayloadWithTransactionType:transactionType
                                                                  applicationData:applicationData
                                                               merchantIdentifier:merchantIdentifier
                                                                      payloadDict:payloadBlobFor3DSOREMV
                                                                      merchantRef:merchantRef];
    
    [self postATransactionWithPayload:firstApiPayload completion:^(NSDictionary *dict, NSError *error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([[dict valueForKey:@"validation_status"] isEqualToString:@"success"] )
        {
            // valid response
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
}

/**
 * PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 * Use this method to submit payments credit and debit cards. Supported transaction type is 'authorize'.
 * It supports Visa payments, MasterCard payments,  American Express payments and Discover payments
 * For moee details refer https://developer.payeezy.com/payeezy-api-reference/apis/credit-card-payments
 @param cardType creditcard payload item
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param cardCVV
 @param currencyCode
 @param totalAmount
 @param merchantRef
 @return Returns
 @see
 */

-(void)submitAuthorizeTransactionWithCreditCardDetails:(NSString*)cardType
                                        cardHolderName:(NSString*)cardHolderName
                                            cardNumber:(NSString*)cardNumber
                               cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                               cardCVV:(NSString*)cardCVV
                                          currencyCode:(NSString*)currencyCode
                                           totalAmount:(NSString*)totalAmount
                              merchantRefForProcessing:(NSString*)merchantRef
                                            completion:(void (^)(NSDictionary *dict, NSError* error))completion
{
    
    [self postATransactionWithPayload:[self constructCreditCardPayloadWithCardCVV:cardCVV cardExpMMYY:cardExpMMYY cardNumber:cardNumber cardHolderName:cardHolderName cardType:cardType currencyCode:currencyCode totalAmount:totalAmount merchantRef:merchantRef transactionType:@"authorize"]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
}




-(void)submitAuthorizeSplitDiscoverTransaction:(NSString*)totalAmount
                         split_transaction_tag:(NSString*)split_transaction_tag
                        split_transaction_type:(NSString*)split_transaction_type
                          split_split_shipment:(NSString*)split_split_shipment
                                  split_method:(NSString*)split_method
                            split_merchant_ref:(NSString*)split_merchant_ref
                           split_currency_code:(NSString*)split_currency_code
                                    completion:(void (^)(NSDictionary *dict, NSError* error))completion
{
    [self postATransactionWithPayload:[self constructAuthorizeSplitDiscoverTransaction:totalAmount
                                                                         split_transaction_tag:split_transaction_tag
                                                                        split_transaction_type:split_transaction_type
                                                                          split_split_shipment:split_split_shipment
                                                                                  split_method:split_method
                                                                            split_merchant_ref:split_merchant_ref
                                                                           split_currency_code:split_currency_code]
                                                                        completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
}

/**
 * PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 * For more information https://developer.payeezy.com/payeezy-api-reference/apis/recurring-payments-split-shipment
 @param totalAmount
 @param transactionType
 @param merchantRef
 @param pMethod
 @param currencyCode
 @param cardtype
 @param cardHolderName
 @param cardNumber
 @param cardExpirymMonthAndYear
 @param cardCVV
 @param eciIndicator
 @return Returns
 @see
 */

-(void)submitAuthorizeOrPurchaseTransactionRecurringPayment:(NSString*)totalAmount
                                          transactionType:(NSString*)transactionType
                                              merchantRef:(NSString*)merchantRef
                                                  pMethod:(NSString*)pMethod
                                             currencyCode:(NSString*)currencyCode
                                                 cardtype:(NSString*)cardtype
                                           cardHolderName:(NSString*)cardHolderName
                                               cardNumber:(NSString*)cardNumber
                                  cardExpirymMonthAndYear:(NSString*)cardExpirymMonthAndYear
                                                  cardCVV:(NSString*)cardCVV
                                             eciIndicator:(NSString*)eciIndicator
completion:(void (^)(NSDictionary *dict, NSError* error))completion
{
    [self postATransactionWithPayload:[self constructCreditCardPayloadWithCardRecurringPayment:totalAmount transactionType:transactionType merchantRef:merchantRef pMethod:pMethod currencyCode:currencyCode cardtype:cardtype cardHolderName:cardHolderName  cardNumber:cardNumber cardExpirymMonthAndYear:cardExpirymMonthAndYear cardCVV:cardCVV eciIndicator:eciIndicator ]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
}

/**
 * submitPurchaseTransactionWithCreditCardDetails
 * Use this method to submit payments credit and debit cards. Supported transaction type is 'Purchase'
 * It supports Visa payments, MasterCard payments,  American Express payments and Discover payments
 * For moee details refer https://developer.payeezy.com/payeezy-api-reference/apis/credit-card-payments
 @param cardType
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param cardCVV
 @param currencyCode
 @param totalAmount
 @param merchantRef
 @return Returns
 @see
 */
-(void)submitPurchaseTransactionWithCreditCardDetails:(NSString*)cardType
                                       cardHolderName:(NSString*)cardHolderName
                                           cardNumber:(NSString*)cardNumber
                              cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                              cardCVV:(NSString*)cardCVV
                                         currencyCode:(NSString*)currencyCode
                                          totalAmount:(NSString*)totalAmount
                             merchantRefForProcessing:(NSString*)merchantRef
                                           completion:(void (^)(NSDictionary *dict, NSError* error))completion
{
    [self postATransactionWithPayload:[self constructCreditCardPayloadWithCardCVV:cardCVV cardExpMMYY:cardExpMMYY cardNumber:cardNumber cardHolderName:cardHolderName cardType:cardType currencyCode:currencyCode totalAmount:totalAmount merchantRef:merchantRef transactionType:@"purchase"]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
}

/**
 * PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 * this method support association-sponsored Address Verification Services
 @param cardType
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param phoneType
 @param phoneNumber
 @param billingCity
 @param billingCountry
 @param billingEmail
 @param billingStreet
 @param billingState
 @param billingZipCode
 @param currencyCode
 @param totalAmount
 @param transactionType
 @param merchantRef
 @return Returns
 @see
 */
-(void)submitAuthorizeTransactionAVSWithCreditCardDetails:(NSString*)cardType
                                           cardHolderName:(NSString*)cardHolderName
                                               cardNumber:(NSString*)cardNumber
                                  cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                phoneType:(NSString*)phoneType
                                              phoneNumber:(NSString*)phoneNumber
                                              billingCity:(NSString*)billingCity
                                           billingCountry:(NSString*)billingCountry
                                             billingEmail:(NSString*)billingEmail
                                            billingStreet:(NSString*)billingStreet
                                             billingState:(NSString*)billingState
                                           billingZipCode:(NSString*)billingZipCode
                                             currencyCode:(NSString*)currencyCode
                                              totalAmount:(NSString*)totalAmount
                                          transactionType:(NSString*)transactionType
                                 merchantRefForProcessing:(NSString*)merchantRef
                                            completion:(void (^)(NSDictionary *dict, NSError* error))completion
{
    
    [self postATransactionWithPayload:[self constructCreditCardPayloadWithCardAVS:cardType cardHolderName:cardHolderName cardNumber:cardNumber cardExpMMYY:cardExpMMYY phoneType:phoneType phoneNumber:phoneNumber billingCity:billingCity billingCountry:billingCountry  billingEmail:billingEmail billingStreet:billingStreet  billingState:billingState    billingZipCode:billingZipCode currencyCode:currencyCode  totalAmount:totalAmount transactionType:transactionType merchantRefForProcessing:merchantRef]  completion:^(NSDictionary *dict, NSError *error){
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
}

/**
 // submitPurchaseTransactionAVSWithCreditCardDetails
 here is sample payload:
 NSDictionary* credit_card = @{
 @"type":@"visa",
 @"cardholder_name":@"Eck Test 3",
 @"card_number":@"4012000033330026",
 @"exp_date":@"0416",
 @"cvv":@"123"
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

 @param cardType
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param phoneType
 @param phoneNumber
 @param billingCity
 @param billingCountry
 @param billingEmail
 @param billingStreet
 @param billingZipCode
 @param currencyCode
 @param totalAmount
 @param transactionType
 @param merchantRef
 **/
-(void)submitPurchaseTransactionAVSWithCreditCardDetails:(NSString*)cardType
                                          cardHolderName:(NSString*)cardHolderName
                                              cardNumber:(NSString*)cardNumber
                                 cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                               phoneType:(NSString*)phoneType
                                             phoneNumber:(NSString*)phoneNumber
                                             billingCity:(NSString*)billingCity
                                          billingCountry:(NSString*)billingCountry
                                            billingEmail:(NSString*)billingEmail
                                           billingStreet:(NSString*)billingStreet
                                            billingState:(NSString*)billingState
                                          billingZipCode:(NSString*)billingZipCode
                                            currencyCode:(NSString*)currencyCode
                                             totalAmount:(NSString*)totalAmount
                                         transactionType:(NSString*)transactionType
                                merchantRefForProcessing:(NSString*)merchantRef
                                              completion:(void (^)(NSDictionary *dict, NSError* error))completion
{
    [self postATransactionWithPayload:[self constructCreditCardPayloadWithCardAVS:cardType cardHolderName:cardHolderName cardNumber:cardNumber cardExpMMYY:cardExpMMYY phoneType:phoneType phoneNumber:phoneNumber billingCity:billingCity billingCountry:billingCountry  billingEmail:billingEmail billingStreet:billingStreet  billingState:billingState    billingZipCode:billingZipCode currencyCode:currencyCode  totalAmount:totalAmount transactionType:transactionType merchantRefForProcessing:merchantRef]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
}


/**
 * submitVoidCaptureRefundTransactionWithCreditCardDetails
 * Use this method to 'capture' or 'void' an authorization or to 'refund' a charge
 * For more information refer https://developer.payeezy.com/payeezy-api-reference/apis/capture-or-reverse-payment
 
 here is sample payload 
 "merchant_ref": "abc1412096293369",
 "transaction_tag": "1847220",
 "transaction_type": "void",
 "method": "credit_card",
 "amount": "9200",
 "currency_code": "USD"
 @param merchantRef
 @param transactiontag
 @param transactionType
 @param transactionId
 @param paymentMethodType
 @param totalAmount
 @param currencyCode
 @return Returns
 @see
 */

-(void)submitVoidCaptureRefundTransactionWithCreditCardDetails:(NSString*)merchantRef
                                                transactiontag:(NSString*)transactiontag
                                               transactionType:(NSString*)transactionType
                                               transactionId:(NSString*)transactionId
                                             paymentMethodType:(NSString*)paymentMethodType
                                                   totalAmount:(NSString*)totalAmount
                                                  currencyCode:(NSString*)currencyCode
                                                    completion:(void (^)(NSDictionary *dict, NSError* error))completion{
    
    
    
    [self postATransactionWithPayload:[self constructVoidCaptureRefundCreditCardPayload:(NSString *)merchantRef   transactionTag:(NSString *)transactiontag  transactionType:(NSString*)transactionType transactionId:(NSString*)transactionId paymentMethodType:(NSString *)paymentMethodType totalAmount:(NSString *)totalAmount currencyCode:(NSString *)currencyCode ]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
    
}

/****
 * PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 * Use this method for 'Subscriptions' or 'Split Shipments' using a previously authorized transaction.
 * Split shipment
 * Sample payload for split payment is shown below
 
 * split_shipment
 * This field is used to provide the shipment fraction and billed for the fraction of the total transaction amount.
 * Value: x/y, where x = current shipment & y = total number of shipments.
 * If y is not known, y = 99.
 * Ex: shipment1 - 01/99,
 * shipment2 - 02/99
 * ...
 * When sending final shipment, x = y
 * Ex: shipment3 - 03/03.

 @param merchantRef
 @param transactiontag
 @param transactionType
 @param paymentMethodType
 @param splitShipment
 @param totalAmount
 @param currencyCode
 @return Returns
 @see
 */



-(void)submitSplitTransactionWithCreditCardDetails:(NSString*)merchantRef
                                                transactiontag:(NSString*)transactiontag
                                               transactionType:(NSString*)transactionType
                                             paymentMethodType:(NSString*)paymentMethodType
                                                 splitShipment:(NSString *)splitShipment
                                                   totalAmount:(NSString*)totalAmount
                                                  currencyCode:(NSString*)currencyCode
                                                    completion:(void (^)(NSDictionary *dict, NSError* error))completion{
    
    
    
    [self postATransactionWithPayload:[self constructSplitCreditCardPayload:(NSString *)merchantRef   transactionTag:(NSString *)transactiontag  transactionType:(NSString*)transactionType paymentMethodType:(NSString *)paymentMethodType splitShipment:(NSString *)splitShipment  totalAmount:(NSString *)totalAmount currencyCode:(NSString *)currencyCode ]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
    
}


-(void)submitAuthorizeTransactionWithAVSCreditCardDetails:(NSString*)cardType
                                           cardHolderName:(NSString*)cardHolderName
                                               cardNumber:(NSString*)cardNumber
                                  cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                  cardCVV:(NSString*)cardCVV
                                             currencyCode:(NSString*)currenyCode
                                              totalAmount:(NSString*)totalAmount
                                 merchantRefForProcessing:(NSString*)merchantRef
                                               completion:(void (^)(NSDictionary *dict, NSError* error))completion{
}


-(void)submitPurchaseTransactionWithAVSCreditCardDetails:(NSString*)cardType
                                          cardHolderName:(NSString*)cardHolderName
                                              cardNumber:(NSString*)cardNumber
                                 cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                 cardCVV:(NSString*)cardCVV
                                            currencyCode:(NSString*)currencyCode
                                             totalAmount:(NSString*)totalAmount
                                merchantRefForProcessing:(NSString*)merchantRef
                                              completion:(void (^)(NSDictionary *dict, NSError* error))completion{
}

 /**
 *  submitAuthorizeTransactionWithSoftSescriptorsCreditCardDetails
 *  A descriptor is a piece of identifying information about a merchant, e.g. business name, phone number,
 *  city and/or state, which appears on buyers’ credit/debit card statements. These descriptors remind cardholders
 *  of the details of the purchase and give them a way to contact the merchant. The standard descriptor information
 *  that gets passed through to the cardholder’s statement is the DBA name and customer service phone number that
 *  you provide with your merchant account application. While it is the card issuer’s discretion as to how many
 *  characters will show up in each field, if you keep the DBA Name field to fewer than 22 characters and the city
 *  field to fewer than 11 characters they should all show up on the cardholder’s statement. Visa requires MOTO merchants
 *  to put a phone number in the City field. Ecommerce merchants may use the City field for a URL, email address
 *  or phone number. There are additional fields that can be used; however, the majority of those will not appear
 *  on a statement. Ex:Soft Descriptor: ABCMovies.com Caddyshack 8885551212 Note:In this example, ABCMovies.com and
 *  Caddyshack are entered in the DBA Name field.Phone numbers should always be entered with numeric characters only.
 *  For more information https://developer.payeezy.com/payeezy-api-reference/apis/credit-card-payments

  here is sample payload

 {
 "amount":"9200",
 "transaction_type":"purchase",
 "merchant_ref":"abc1412096293369",
 "method":"credit_card",
 "currency_code":"USD",
 
 "credit_card":{
 "type":"American Express",
 "cardholder_name":"Eck Test 3",
 "card_number":"373953192351004",
 "exp_date":"0416",
 "cvv":"1234"
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
 
 
 :(NSString*)cardType
 cardHolderName:(NSString*)cardHolderName
 cardNumber:(NSString*)cardNumber
 cardExpirymMonthAndYear:(NSString*)cardExpMMYY
 cardCVV:(NSString*)cardCVV
 currencyCode:(NSString*)currenyCode
 totalAmount:(NSString*)totalAmount
 merchantRefForProcessing:(NSString*)merchantRef
 
 } 
  @param totalAmount
  @param transactionType
  @param merchantRef
  @param pMethod
  @param currencyCode
  @param cardtype
  @param cardHolderName
  @param cardNumber
  @param cardExpMMYY
  @param cardCVV
  @param dbaNameSD
  @param streetSD
  @param regionSD
  @param midSD
  @param mccSD
  @param postalCodeSD
  @param countryCodeSD
  @param merchantContactInfoSD
  @return Returns
  @see
   */

-(void)submitAuthorizeTransactionWithSoftSescriptorsCreditCardDetails:(NSString*)totalAmount
                                                      transactionType:(NSString*)transactionType
                                             merchantRefForProcessing:(NSString*)merchantRef
                                                              pMethod:(NSString*)pMethod
                                                         currencyCode:(NSString*)currencyCode
                                                             cardtype:(NSString*)cardtype
                                                       cardHolderName:(NSString*)cardHolderName
                                                           cardNumber:(NSString*)cardNumber
                                              cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                              cardCVV:(NSString*)cardCVV
                                                            dbaNameSD:(NSString*)dbaNameSD
                                                             streetSD:(NSString*)streetSD
                                                             regionSD:(NSString*)regionSD
                                                                midSD:(NSString*)midSD
                                                                mccSD:(NSString*)mccSD
                                                         postalCodeSD:(NSString*)postalCodeSD
                                                        countryCodeSD:(NSString*)countryCodeSD
                                                merchantContactInfoSD:(NSString*)merchantContactInfoSD
                                                            completion:(void (^)(NSDictionary *dict, NSError* error))completion{
    [self postATransactionWithPayload:[self constructTransactionWithSoftSescriptorsCreditCardPayload:(NSString *)totalAmount   transactionType:(NSString *)transactionType merchantRef:(NSString *)merchantRef pMethod:(NSString*)pMethod currencyCode:(NSString *)currencyCode cardtype:(NSString *)cardtype cardHolderName:(NSString *)cardHolderName cardNumber:(NSString *)cardNumber cardExpMMYY:(NSString *)cardExpMMYY cardCVV:(NSString *)cardCVV dbaNameSD:(NSString *)dbaNameSD streetSD:(NSString *)streetSD regionSD:(NSString *)regionSD midSD:(NSString *)midSD mccSD:(NSString *)mccSD postalCodeSD:(NSString *)postalCodeSD countryCodeSD:(NSString *)countryCodeSD  merchantContactInfoSD:(NSString *) merchantContactInfoSD]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
    
}


/**
 *    PayeezyClient method to process credit card payments regardless to PKPayment supported devices       *
 @param cardHolderName
 @param cardNumber
 @param cardType
 @param cardCost
 @param totalAmt
 @param transactiontype
 @param pMethod
 @param currencyCode
 @return Returns
 @see
 */

-(void)submitActivationTransactionValueLink:(NSString*)cardHolderName
                                 cardNumber:(NSString*)cardNumber
                                   cardType:(NSString*)cardType
                                   cardCost:(NSString*)cardCost
                                   totalAmt:(NSString*)totalAmt
                            transactiontype:(NSString*)transactiontype
                                    pMethod:(NSString*)pMethod
                               currencyCode:(NSString*)currencyCode
                                 completion:(void (^)(NSDictionary *dict, NSError* error))completion{
    [self postATransactionWithPayload:[self constructActivationTransactionValueLinkPayload:(NSString *)cardHolderName
          cardNumber:(NSString *)cardNumber cardType:(NSString *)cardType cardCost:(NSString*)cardCost totalAmt:(NSString *)totalAmt transactiontype:(NSString *)transactiontype pMethod:(NSString *)pMethod currencyCode:(NSString *)currencyCode ]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
    
}


 /**
 * PayeezyClient method to process credit card payments regardless to PKPayment supported devices
  @param amount
  @param transactiontype
  @param pMethod
  @param currencyCode
  @param cardType
  @param cardholderName
  @param cardNumber
  @param expDate
  @return Returns
  @see
 */

-(void)submitNakedRefundDiscoverRefundTransaction:(NSString*)amount
                                  transactiontype:(NSString*)transactiontype
                                          pMethod:(NSString*)pMethod
                                     currencyCode:(NSString*)currencyCode
                                         cardType:(NSString*)cardType
                                   cardholderName:(NSString*)cardholderName
                                       cardNumber:(NSString*)cardNumber
                                          expDate:(NSString*)expDate
                                       completion:(void (^)(NSDictionary *dict, NSError* error))completion{
    [self postATransactionWithPayload:[self constructNakedRefundDiscoverRefundTransaction:(NSString*)amount
                                                                          transactiontype:(NSString*)transactiontype
                                                                                  pMethod:(NSString*)pMethod
                                                                             currencyCode:(NSString*)currencyCode
                                                                                 cardType:(NSString*)cardType
                                                                           cardholderName:(NSString*)cardholderName
                                                                               cardNumber:(NSString*)cardNumber
                                                                                  expDate:(NSString*)expDate ]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
    
}

/**
 * PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 * Use this method to do transactions via tele-check. Supported transactions are Purchase.
 * for moreinformation https://developer.payeezy.com/test_smart_docs/apis/post/transactions-8
 @param checkNumber
 @param checkType
 @param accountNumber
 @param routingNumber
 @param accountholderName
 @param customerIdType
 @param customerIdNumber
 @param clientEmail
 @param giftCardAmount
 @param vip
 @param clerkId
 @param deviceId
 @param releaseType
 @param registrationNumber
 @param registrationDate
 @param datedateOfBirth
 @param street
 @param city
 @param stateProvince
 @param zipzipPostalCode
 @param country
 @param pMethod
 @param transactionType
 @param totalAmount
 @param currencyCode
 @param merchantRef
 @return Returns
 @see
 */
-(void) submitPurchaseTelecheckPersonalTransaction:(NSString*)checkNumber
                                         checkType:(NSString*)checkType
                                     accountNumber:(NSString*)accountNumber
                                     routingNumber:(NSString*)routingNumber
                                 accountholderName:(NSString*)accountholderName
                                    customerIdType:(NSString*)customerIdType
                                  customerIdNumber:(NSString*)customerIdNumber
                                       clientEmail:(NSString*)clientEmail
                                    giftCardAmount:(NSString*)giftCardAmount
                                               vip:(NSString*)vip
                                           clerkId:(NSString*)clerkId
                                          deviceId:(NSString*)deviceId
                                       releaseType:(NSString*)releaseType
                                registrationNumber:(NSString*)registrationNumber
                                  registrationDate:(NSString*)registrationDate
                                       dateOfBirth:(NSString*)dateOfBirth
                                            street:(NSString*)street
                                              city:(NSString*)city
                                     stateProvince:(NSString*)stateProvince
                                     zipPostalCode:(NSString*)zipPostalCode
                                           country:(NSString*)country
                                           pMethod:(NSString*)pMethod
                                   transactionType:(NSString*)transactionType
                                       totalAmount:(NSString*)totalAmount
                                      currencyCode:(NSString*)currencyCode
                                       merchantRef:(NSString*)merchantRef
                                        completion:(void (^)(NSDictionary *dict, NSError* error))completion{
    [self postATransactionWithPayload:[self constructPurchaseTelecheckPersonalTransaction:(NSString*)checkNumber
                                                                                 checkType:(NSString*)checkType
                                                                             accountNumber:(NSString*)accountNumber
                                                                             routingNumber:(NSString*)routingNumber
                                                                         accountholderName:(NSString*)accountholderName
                                                                            customerIdType:(NSString*)customerIdType
                                                                          customerIdNumber:(NSString*)customerIdNumber
                                                                               clientEmail:(NSString*)clientEmail
                                                                            giftCardAmount:(NSString*)giftCardAmount
                                                                                       vip:(NSString*)vip
                                                                                   clerkId:(NSString*)clerkId
                                                                                  deviceId:(NSString*)deviceId
                                                                               releaseType:(NSString*)releaseType
                                                                        registrationNumber:(NSString*)registrationNumber
                                                                          registrationDate:(NSString*)registrationDate
                                                                               dateOfBirth:(NSString*)dateOfBirth
                                                                                    street:(NSString*)street
                                                                                      city:(NSString*)city
                                                                             stateProvince:(NSString*)stateProvince
                                                                             zipPostalCode:(NSString*)zipPostalCode
                                                                                   country:(NSString*)country
                                                                                   pMethod:(NSString*)pMethod
                                                                           transactionType:(NSString*)transactionType
                                                                               totalAmount:(NSString*)totalAmount
                                                                              currencyCode:(NSString*)currencyCode
                                                                               merchantRef:(NSString*)merchantRef ]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
}


/**
 * submitAuthorizeTransactionWithRecurringPaymentCreditCardDetails()
 * Use this method for 'Subscriptions' or 'Split-Shipments' using a previously authorized transaction
 * for more information https://developer.payeezy.com/payeezy-api-reference/apis/recurring-payments-split-shipment
 */

-(void)submitAuthorizeTransactionWithRecurringPaymentCreditCardDetails:(NSString*)totalAmount
                                                       transactionType:(NSString*)transactionType
                                              merchantRefForProcessing:(NSString*)merchantRef
                                                         paymentMethod:(NSString*)paymentMethod
                                                          currencyCode:(NSString*)currenyCode
                                                              cardtype:(NSString*)cardtype
                                                        cardHolderName:(NSString*)cardHolderName
                                                            cardNumber:(NSString*)cardNumber
                                               cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                               cardCVV:(NSString*)cardCVV
                                                             dbaNameSD:(NSString*)dbaNameSD
                                                              streetSD:(NSString*)streetSD
                                                              regionSD:(NSString*)regionSD
                                                                 midSD:(NSString*)midSD
                                                                 mccSD:(NSString*)mccSD
                                                          postalCodeSD:(NSString*)postalCodeSD
                                                         countryCodeSD:(NSString*)countryCodeSD
                                                 merchantContactInfoSD:(NSString*)merchantContactInfoSD
                                                            completion:(void (^)(NSDictionary *dict, NSError* error))completion{}
/**
 * PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 * Use this method for 'Subscriptions' or 'Split Shipments' using a previously authorized transaction.
 */

-(void)submitAuthorizeDiscoverTransactionRecurringPayment:(NSString*)totalAmount
                                          transactionType:(NSString*)transactionType
                                              merchantRef:(NSString*)merchantRef
                                                  pMethod:(NSString*)pMethod
                                             currencyCode:(NSString*)currencyCode
                                                 cardtype:(NSString*)cardtype
                                           cardHolderName:(NSString*)cardHolderName
                                               cardNumber:(NSString*)cardNumber
                                  cardExpirymMonthAndYear:(NSString*)cardExpirymMonthAndYear
                                                  cardCVV:(NSString*)cardCVV
                                             eciIndicator:(NSString*)eciIndicator
                                               completion:(void (^)(NSDictionary *dict, NSError* error))completion{}

-(void)submitPurchaseTransactionWithRecurringPaymentCreditCardDetails:(NSString*)cardType
                                                       cardHolderName:(NSString*)cardHolderName
                                                           cardNumber:(NSString*)cardNumber
                                              cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                              cardCVV:(NSString*)cardCVV
                                                         currencyCode:(NSString*)currencyCode
                                                          totalAmount:(NSString*)totalAmount
                                             merchantRefForProcessing:(NSString*)merchantRef
                                                           completion:(void (^)(NSDictionary *dict, NSError* error))completion{}

/**
 *  PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 @param totalAmount
 @param transactionType
 @param transactionTag
 @param merchantRef
 @param pMethod
 @param currencyCode
 @param cardtype
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param cardCVV
 @param tax1Amount
 @param tax2Amount
 @param tax2Number
 @param customerRef
 @param street
 @param city
 @param stateProvince
 @param zipPostalCode
 @param country
 @return Returns
 @see
 */

-(void)submitAuthorizeTransactionL2WithCreditCardDetails:(NSString*)totalAmount
                                         transactionType:(NSString*)transactionType
                                         transactionTag:(NSString*)transactionTag
                                merchantRefForProcessing:(NSString*)merchantRef
                                                 pMethod:(NSString*)pMethod
                                            currencyCode:(NSString*)currencyCode
                                                cardtype:(NSString*)cardtype
                                          cardHolderName:(NSString*)cardHolderName
                                              cardNumber:(NSString*)cardNumber
                                 cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                 cardCVV:(NSString*)cardCVV
                                              tax1Amount:(NSString*)tax1Amount
                                              tax1Number:(NSString*)tax1Number
                                              tax2Amount:(NSString*)tax2Amount
                                              tax2Number:(NSString*)tax2Number
                                             customerRef:(NSString*)customerRef
                                                  street:(NSString*)street
                                                    city:(NSString*)city
                                           stateProvince:(NSString*)stateProvince
                                           zipPostalCode:(NSString*)zipPostalCode
                                                 country:(NSString*)country
                                              completion:(void (^)(NSDictionary *dict, NSError* error))completion{
    [self postATransactionWithPayload:[self constructAuthorizeTransactionL2WithCreditCardDetails:(NSString*)totalAmount
                                                                                 transactionType:(NSString*)transactionType
                                                                                     merchantRef:(NSString*)merchantRef
                                                                                         pMethod:(NSString*)pMethod
                                                                                    currencyCode:(NSString*)currencyCode
                                                                                        cardtype:(NSString*)cardtype
                                                                                  cardHolderName:(NSString*)cardHolderName
                                                                                      cardNumber:(NSString*)cardNumber
                                                                                     cardExpMMYY:(NSString*)cardExpMMYY
                                                                                         cardCVV:(NSString*)cardCVV
                                                                                      tax1Amount:(NSString*)tax1Amount
                                                                                      tax1Number:(NSString*)tax1Number
                                                                                      tax2Amount:(NSString*)tax2Amount
                                                                                      tax2Number:(NSString*)tax2Number
                                                                                     customerRef:(NSString*)customerRef
                                                                                          street:(NSString*)street
                                                                                            city:(NSString*)city
                                                                                   stateProvince:(NSString*)stateProvince
                                                                                   zipPostalCode:(NSString*)zipPostalCode
                                                                                         country:(NSString*)country]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
}





-(void)submitAuthorizeTransactionWithL2L3CreditCardDetails:(NSString*)cardType
                                            cardHolderName:(NSString*)cardHolderName
                                                cardNumber:(NSString*)cardNumber
                                   cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                   cardCVV:(NSString*)cardCVV
                                              currencyCode:(NSString*)currenyCode
                                               totalAmount:(NSString*)totalAmount
                                  merchantRefForProcessing:(NSString*)merchantRef
                                                completion:(void (^)(NSDictionary *dict, NSError* error))completion{}

/**
 *  submitPurchaseTransactionWithL2L3CreditCardDetails()
 *   Level  II
 *   Level 2 data fields such as Freight, Duty, etc. - values are for informational purposes only and are not
 *   directly reflected in the Total Amount field for the transaction when processed. It is up to the Merchant
 *   to ensure that the Total Amount of the transaction reflects the desired Level 2 and 3 amounts. The Discount
 *   Amount in line items defaults to 0.00 if nothing is entered Card Types Supported:
 *      1. Visa
 *      2. Mastercard
 
 *      Level III
 
 *   The following properties are used to populate additional information about the transaction, including shipping details and line item information.
 *   Visa
 *   Mastercard
 
 *   "level3": {
 *      "alt_tax_amount": "{number}",
 *      "alt_tax_id": "{string}",
 *      "discount_amount": "{number}",
 *      "duty_amount": "{number}",
 *      "freight_amount": "{number}",
 *      "ship_from_zip": "{string}",
 *      "ship_to_address": {
 *          "city": "{string}",
 *          "state": "{string}",
 *          "zip": "{string}",
 *          "country": "{string}",
 *          "email": "{string}",
 *          "name": "{string}",
 *          "phone": "{string}",
 *          "address_1": "{string}",
 *          "customer_number": "{string}"
 *      },
 *      "line_items": [{
 *          "description": "{string}",
 *          "quantity": "{string}",
 *          "commodity_code": "{string}",
 *          "discount_amount": "{number}",
 *          "discount_indicator": "{string}",
 *          "gross_net_indicator": "{string}",
 *          "line_item_total": "{number}",
 *          "product_code": "{string}",
 *          "tax_amount": "{number}",
 *          "tax_rate": "{number}",
 *          "tax_type": "{string}",
 *          "unit_cost": "{number}",
 *          "unit_of_measure": "{string}"
 *      }]
 *   }
 *  for more information https://developer.payeezy.com/payeezy-api-reference/apis/credit-card-payments
 
Sample payload
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
     {
     "description":"item 1",
     "quantity":"5",
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
     "unit_of_measure":"meters"
    }]
 }
 }
 @param  transactionType
 @param  merchantRefForProcessing
 @param  pMethod
 @param  currencyCode
 @param  cardtype
 @param  cardHolderName
 @param  cardNumber
 @param  cardExpirymMonthAndYear
 @param  cardCVV
 @param  tax1Amount
 @param  tax1Number
 @param  tax2Amount
 @param  tax2Number
 @param  customerRef
 @param  description
 @param  quantity
 @param  commodity_code
 @param  discount_amount
 @param  discount_indicator
 @param  gross_net_indicator
 @param  line_item_total
 @param  product_code
 @param  tax_amount
 @param  tax_rate
 @param  tax_type
 @param  unit_cost
 @param  unit_of_measure
 @param  alt_tax_amount
 @param  alt_tax_id
 @param  l3_discount_amount
 @param  duty_amount
 @param  freight_amount
 @param  ship_from_zip
 @param  city
 @param  state
 @param  zip
 @param  country
 @param  email                  
 @return Returns
 @see
*/

-(void)submitPurchaseTransactionWithL2L3CreditCardDetails:(NSString*)amount
                                          transactionType:(NSString*)transactionType
                                 merchantRefForProcessing:(NSString*)merchantRefForProcessing
                                                  pMethod:(NSString*)pMethod
                                             currencyCode:(NSString*)currencyCode
                                                 cardtype:(NSString*)cardtype
                                           cardHolderName:(NSString*)cardHolderName
                                               cardNumber:(NSString*)cardNumber
                                  cardExpirymMonthAndYear:(NSString*)cardExpirymMonthAndYear
                                                  cardCVV:(NSString*)cardCVV
                                               tax1Amount:(NSNumber*)tax1Amount
                                               tax1Number:(NSString*)tax1Number
                                               tax2Amount:(NSNumber*)tax2Amount
                                               tax2Number:(NSString*)tax2Number
                                              customerRef:(NSString*)customerRef
                                              description:(NSString*)description
                                                 quantity:(NSString*)quantity
                                           commodity_code:(NSString*)commodity_code
                                          discount_amount: (NSString*)discount_amount
                                       discount_indicator:(NSString*)discount_indicator
                                      gross_net_indicator:(NSString*)gross_net_indicator
                                          line_item_total:(NSString*)line_item_total
                                             product_code:(NSString*)product_code
                                               tax_amount:(NSString*)tax_amount
                                                 tax_rate:(NSString*)tax_rate
                                                 tax_type:(NSString*)tax_type
                                                unit_cost:(NSString*)unit_cost
                                          unit_of_measure:(NSString*)unit_of_measure
                                           alt_tax_amount:(NSString*)alt_tax_amount
                                               alt_tax_id:(NSString*)alt_tax_id
                                       l3_discount_amount:(NSString*)l3_discount_amount
                                              duty_amount:(NSString*)duty_amount
                                           freight_amount:(NSString*)freight_amount
                                            ship_from_zip:(NSString*)ship_from_zip
                                                     city:(NSString*)city
                                                    state:(NSString*)state
                                                      zip:(NSString*)zip
                                                  country:(NSString*)country
                                                    email:(NSString*)email
                                                     name:(NSString*)name
                                                    phone:(NSString*)phone
                                                address_1:(NSString*)address_1
                                          customer_number:(NSString*)customer_number
                                               completion:(void (^)(NSDictionary *dict, NSError* error))completion{
    [self postATransactionWithPayload:[self constructPurchaseTransactionL2L3WithCreditCardDetails:(NSString*)amount //main
                                                                                  transactionType:(NSString*)transactionType
                                                                         merchantRefForProcessing:(NSString*)merchantRefForProcessing
                                                                                          pMethod:(NSString*)pMethod
                                                                                     currencyCode:(NSString*)currencyCode
                                       //credit_card
                                                                                         cardtype:(NSString*)cardtype
                                                                                   cardHolderName:(NSString*)cardHolderName
                                                                                       cardNumber:(NSString*)cardNumber
                                                                          cardExpirymMonthAndYear:(NSString*)cardExpirymMonthAndYear
                                                                                          cardCVV:(NSString*)cardCVV
                                       //level2
                                                                                       tax1Amount:(NSNumber*)tax1Amount
                                                                                       tax1Number:(NSString*)tax1Number
                                                                                       tax2Amount:(NSNumber*)tax2Amount
                                                                                      tax2Number:(NSString*)tax2Number
                                                                                      customerRef:(NSString*)customerRef
                                       //line_items
                                                                                      description:(NSString*)description
                                                                                         quantity:(NSString*)quantity
                                                                                   commodity_code:(NSString*)commodity_code
                                                                                  discount_amount: (NSString*)discount_amount
                                                                               discount_indicator:(NSString*)discount_indicator
                                                                              gross_net_indicator:(NSString*)gross_net_indicator
                                                                                  line_item_total:(NSString*)line_item_total
                                                                                     product_code:(NSString*)product_code
                                                                                       tax_amount:(NSString*)tax_amount
                                                                                         tax_rate:(NSString*)tax_rate
                                                                                         tax_type:(NSString*)tax_type
                                                                                        unit_cost:(NSString*)unit_cost
                                                                                  unit_of_measure:(NSString*)unit_of_measure
                                       //level3
                                                                                   alt_tax_amount:(NSString*)alt_tax_amount
                                                                                       alt_tax_id:(NSString*)alt_tax_id
                                                                               l3_discount_amount:(NSString*)l3_discount_amount
                                                                                      duty_amount:(NSString*)duty_amount
                                                                                   freight_amount:(NSString*)freight_amount
                                                                                    ship_from_zip:(NSString*)ship_from_zip
                                       //ship_to_address
                                                                                             city:(NSString*)city
                                                                                            state:(NSString*)state
                                                                                              zip:(NSString*)zip
                                                                                          country:(NSString*)country
                                                                                            email:(NSString*)email
                                                                                             name:(NSString*)name
                                                                                            phone:(NSString*)phone
                                                                                        address_1:(NSString*)address_1
                                                                                  customer_number:(NSString*)customer_number]  completion:^(NSDictionary *dict, NSError *error){
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if([dict valueForKey:STATUS_KEY_NAME]){ // valid response
            
            completion(dict,nil);
        }else{
            completion(dict,[NSError errorWithDomain:SERVER_ERROR_MSG code:101 userInfo:nil]);
        }
    }];
}

/**
 submitAuthorizeTransactionWithRecurringPaymentCreditCardDetails
 @param cardType
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param cardCVV
 @param currencyCode
 @param totalAmount
 @param merchantRef
 @return Returns
 @see
 */

-(void)submitAuthorizeTransactionWithRecurringPaymentCreditCardDetails:(NSString*)cardType
                                                       cardHolderName:(NSString*)cardHolderName
                                                           cardNumber:(NSString*)cardNumber
                                              cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                              cardCVV:(NSString*)cardCVV
                                                         currencyCode:(NSString*)currenyCode
                                                          totalAmount:(NSString*)totalAmount
                                             merchantRefForProcessing:(NSString*)merchantRef
                                                           completion:(void (^)(NSDictionary *dict, NSError* error))completion{}
/**
 submitPurchaseTransactionWithSoftSescriptorsCreditCardDetails
 @param cardType
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param cardCVV
 @param currencyCode
 @param totalAmount
 @param merchantRef
 @return Returns
 @see
 */

-(void)submitPurchaseTransactionWithSoftSescriptorsCreditCardDetails:(NSString*)cardType
                                                      cardHolderName:(NSString*)cardHolderName
                                                          cardNumber:(NSString*)cardNumber
                                             cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                             cardCVV:(NSString*)cardCVV
                                                        currencyCode:(NSString*)currencyCode
                                                         totalAmount:(NSString*)totalAmount
                                            merchantRefForProcessing:(NSString*)merchantRef
                                                          completion:(void (^)(NSDictionary *dict, NSError* error))completion{}




- (BOOL)isInternetReachable
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    if(reachability == NULL)
        return false;
    
    if (!(SCNetworkReachabilityGetFlags(reachability, &flags)))
        return false;
    
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
        // if target host is not reachable
        return false;
    
    
    BOOL isReachable = false;
    
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        // if target host is reachable and no connection is required
        //  then we'll assume (for now) that your on Wi-Fi
        isReachable = true;
    }
    
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        // ... and the connection is on-demand (or on-traffic) if the
        //     calling application is using the CFSocketStream or higher APIs
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            // ... and no [user] intervention is needed
            isReachable = true;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        // ... but WWAN connections are OK if the calling application
        //     is using the CFNetwork (CFSocketStream?) APIs.
        isReachable = true;
    }
    
    
    return isReachable;
}

-(NSString*)convertByteArrayToHexString:(NSData*)dataToBeConverted{
    
    
    /*  Since Hex will take two characters for each byte - hex string length is twice the bytes.
     *  Resource: http://stackoverflow.com/questions/3183841/base64-vs-hex-for-sending-binary-content-over-the-internet-in-xml-doc
     *  Simplest way %02x produces hex result for a byte
     *  x - lowercase
     *  X - uppercase
     */
    
    NSMutableString *hexString = [NSMutableString stringWithCapacity:[dataToBeConverted length]*2];
    const unsigned char *dataBytes = [dataToBeConverted bytes];
    for (NSInteger idB = 0; idB < [dataToBeConverted length]; ++idB) {
        [hexString appendFormat:@"%02x", dataBytes[idB]];
    }
    return hexString;
}





@end

