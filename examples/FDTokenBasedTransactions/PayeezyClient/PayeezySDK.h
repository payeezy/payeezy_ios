
/*!
 @header PayeezySDK.h
 @author First Data Corporation
 @copyright  Copyright (c) 2015 First Data Corporation. All rights reserved.
 @version    2.0.0
 @brief This is the header file for Payeezy SDK integration
 @discussion
 
 Payeezy supports the following method of payments
 * Purchase
 * Pre-Authorization (includes $0 Auth)
 * Pre-Authorization Completion
 * Refund
 * Void
 * Tagged Pre-Authorization Completion
 * Tagged Void
 * Tagged Refund
 * For API processing details, click here https://developer.payeezy.com/integration
 */

#import <Foundation/Foundation.h>
/*!
	@constant PayeezyClientVersionNumber
 */
FOUNDATION_EXPORT double PayeezyClientVersionNumber;
/*!
	@constant PayeezyClientVersionString[]
 */
FOUNDATION_EXPORT const unsigned char PayeezyClientVersionString[];


@protocol PayeezySDK <NSObject>

/*!
 @discussion
 PayeezyClient init method
 Initialize with apikey, apiSecret, merchantToken
 Refer developer.payeezy.com documentation to get apiKey,merchantToken and apiSecret
 @param apiKey
 @param apiSecret
 @param merchantToken
 @result Returns self
 @see sand/test enviroment url=https://api-cert.payeezy.com/v1/transactions
 @see live enviroment url https://api.payeezy.com/v1/transactions
 */

-(id)initWithApiKey:(NSString *)apiKey
          apiSecret:(NSString *)apiSecret
      merchantToken:(NSString *)merchantToken
                url:(NSString *)url;


/*!
 @discussion 
 PayeezyClient 3DS method that takes in encoded payment data object - PKPaymentRequestToken returns
 a response and error
 Use this method to make 3-D Secure Transaction that requires a 3-D Secure cryptogram (value of CAVV)
 To use 3-D Secure, please contact Cardinal Commerce to register at https://registration.altpayfirstdata.com .
 Be sure to select Global Gateway e4 from the First Data Gateway Platform drop down menu.
 Once the form is submitted you will receive further instructions from Cardinal commerce.
 @param paymentData
 @param transactionType
 @param applicationData
 @param merchantIdentifier
 @param merchantRef
 @result Returns
 @see To use 3-D Secure, see {@link  https://registration.altpayfirstdata.com }
 */

-(void)submit3DSTransactionWithPaymentInfo:(NSData *)paymentData
                           transactionType:(NSString *)transactionType
                           applicationData:(NSData *)applicationData
                        merchantIdentifier:(NSString *)merchantIdentifier
                               merchantRef:(NSString *)merchantRef
                                completion:(void(^)(NSDictionary *response, NSError *error))completion;

-(void)submitPostFDTokenForCreditCard:(NSString*)cardType
                      cardHolderName:(NSString*)cardHolderName
                          cardNumber:(NSString*)cardNumber
             cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                             cardCVV:(NSString*)cardCVV
                                type:(NSString*)type
                                auth:(NSString*)auth
                            ta_token:(NSString*)ta_token
                          completion:(void (^)(NSDictionary *dict, NSError* error))completion;

-(void)submitGetFDTokenForCreditCard:(NSString*)cardType
                       cardHolderName:(NSString*)cardHolderName
                           cardNumber:(NSString*)cardNumber
              cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                              cardCVV:(NSString*)cardCVV
                                 type:(NSString*)type
                                 auth:(NSString*)auth
                             ta_token:(NSString*)ta_token
                      js_security_key:(NSString *)js_security_key
                             callback:(NSString *)callback
                           completion:(void (^)(NSString *dict, NSError* error))completion;

/*!
 @discussion
 PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 Use this method to submit payments credit and debit cards. Supported transaction type is 'authorize'.
 It supports Visa payments, MasterCard payments,  American Express payments and Discover payments
 
 @see  For more information {@link https://developer.payeezy.com/payeezy-api-reference/apis/credit-card-payments}
 @param cardType
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param cardCVV
 @param currencyCode
 @param totalAmount
 @param merchantRef
 @result Returns Returns payload response string

 */

-(void)submitAuthorizePurchaseTransactionWithCreditCardDetails:(NSString*)cardCVV
                                           cardExpMMYY:(NSString*)cardExpMMYY
                                            cardNumber:(NSString*)cardNumber
                                        cardHolderName:(NSString*)cardHolderName
                                              cardType:(NSString*)cardType
                                          currencyCode:(NSString*)currencyCode
                                           totalAmount:(NSString*)totalAmount
                                           merchantRef:(NSString*)merchantRef
                                       transactionType:(NSString*)transactionType
                                            token_type:(NSString*)token_type
                                                method:(NSString*)method
                                            completion:(void (^)(NSDictionary *dict, NSError* error))completion;



/*!
 @discussion
 Use this method to 'capture' or 'void' an authorization or to 'refund' a charge
 @see For more information {@link  https://developer.payeezy.com/payeezy-api-reference/apis/capture-or-reverse-payment}
 @param merchantRef
 @param transactiontag
 @param transactionType
 @param transactionId
 @param paymentMethodType
 @param totalAmount
 @param currencyCode
 @result Returns Returns payload response string
 */

-(void)submitVoidCaptureRefundTransactionWithCreditCardDetails:(NSString*)merchantRef
                                                transactiontag:(NSString*)transactiontag
                                               transactionType:(NSString*)transactionType
                                               transactionId:(NSString*)transactionId
                                             paymentMethodType:(NSString*)paymentMethodType
                                                   totalAmount:(NSString*)totalAmount
                                                  currencyCode:(NSString*)currencyCode
                                                    completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*! 
 @discussion
 this method support association-sponsored Address Verification Services
 @param cardType
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param cardCVV
 @param currencyCode
 @param totalAmount
 @param merchantRef
 @result Returns payload response string
 */

-(void)submitAuthorizeTransactionWithAVSCreditCardDetails:(NSString*)cardType
                                           cardHolderName:(NSString*)cardHolderName
                                               cardNumber:(NSString*)cardNumber
                                  cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                  cardCVV:(NSString*)cardCVV
                                             currencyCode:(NSString*)currenyCode
                                              totalAmount:(NSString*)totalAmount
                                 merchantRefForProcessing:(NSString*)merchantRef
                                               completion:(void (^)(NSDictionary *dict, NSError* error))completion;


/*!
 @discussion
 this method support association-sponsored Address Verification Services
 @param cardType
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param cardCVV
 @param currencyCode
 @param totalAmount
 @param merchantRef
 @result Returns payload response string
 */

-(void)submitPurchaseTransactionWithAVSCreditCardDetails:(NSString*)cardType
                                          cardHolderName:(NSString*)cardHolderName
                                              cardNumber:(NSString*)cardNumber
                                 cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                 cardCVV:(NSString*)cardCVV
                                            currencyCode:(NSString*)currencyCode
                                             totalAmount:(NSString*)totalAmount
                                merchantRefForProcessing:(NSString*)merchantRef
                                              completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
 @discussion
   A descriptor is a piece of identifying information about a merchant, e.g. business name, phone number,
   city and/or state, which appears on buyers’ credit/debit card statements. These descriptors remind cardholders
   of the details of the purchase and give them a way to contact the merchant. The standard descriptor information
   that gets passed through to the cardholder’s statement is the DBA name and customer service phone number that
   you provide with your merchant account application. While it is the card issuer’s discretion as to how many
   characters will show up in each field, if you keep the DBA Name field to fewer than 22 characters and the city
   field to fewer than 11 characters they should all show up on the cardholder’s statement. Visa requires MOTO merchants
   to put a phone number in the City field. Ecommerce merchants may use the City field for a URL, email address
   or phone number. There are additional fields that can be used; however, the majority of those will not appear
   on a statement. Ex:Soft Descriptor: ABCMovies.com Caddyshack 8885551212 Note:In this example, ABCMovies.com and
   Caddyshack are entered in the DBA Name field.Phone numbers should always be entered with numeric characters only.
 @see For more information {@link  https://developer.payeezy.com/payeezy-api-reference/apis/credit-card-payments}
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
 @result Returns payload response string
 */

-(void) submitAuthorizeTransactionWithSoftSescriptorsCreditCardDetails:(NSString*)totalAmount
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
                                                            completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
 @discussion

 submitPurchaseTransactionWithSoftSescriptorsCreditCardDetails()
 A descriptor is a piece of identifying information about a merchant, e.g. business name, phone number,
 city and/or state, which appears on buyers’ credit/debit card statements. These descriptors remind cardholders
 of the details of the purchase and give them a way to contact the merchant. The standard descriptor information
 that gets passed through to the cardholder’s statement is the DBA name and customer service phone number that
 you provide with your merchant account application. While it is the card issuer’s discretion as to how many
 characters will show up in each field, if you keep the DBA Name field to fewer than 22 characters and the city
 field to fewer than 11 characters they should all show up on the cardholder’s statement. Visa requires MOTO merchants
 to put a phone number in the City field. Ecommerce merchants may use the City field for a URL, email address
 or phone number. There are additional fields that can be used; however, the majority of those will not appear
 on a statement. Ex:Soft Descriptor: ABCMovies.com Caddyshack 8885551212 Note:In this example, ABCMovies.com and
 Caddyshack are entered in the DBA Name field.Phone numbers should always be entered with numeric characters only.
 @see For more information {@link  https://developer.payeezy.com/payeezy-api-reference/apis/credit-card-payments}
 @param cardType
 @param cardHolderName
 @param cardNumber
 @param cardExpMMYY
 @param cardCVV
 @param currencyCode
 @param totalAmount
 @param merchantRef
 @result Returns payload response string
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
                                                          completion:(void (^)(NSDictionary *dict, NSError* error))completion;


/*!
  @discussion
  submitAuthorizeTransactionWithRecurringPaymentCreditCardDetails()
  Use this method for 'Subscriptions' or 'Split-Shipments' using a previously authorized transaction
 @see For more information {@link  https://developer.payeezy.com/payeezy-api-reference/apis/recurring-payments-split-shipment}
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
                                                            completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
  @discussion
  PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 @see For more information {@link https://developer.payeezy.com/payeezy-api-reference/apis/recurring-payments-split-shipment}
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
                                                           completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
  @discussion
 Level  II
 Level 2 data fields such as Freight, Duty, etc. - values are for informational purposes only and are not
 directly reflected in the Total Amount field for the transaction when processed. It is up to the Merchant
 to ensure that the Total Amount of the transaction reflects the desired Level 2 and 3 amounts. The Discount
 Amount in line items defaults to 0.00 if nothing is entered Card Types Supported:
 1. Visa
 2. Mastercard
 
 Level III
 The following properties are used to populate additional information about the transaction, including shipping details and
 line item information.
 1. Visa
 2. Mastercard
 @code
 "level3": {
 "alt_tax_amount": "{number}",
 "alt_tax_id": "{string}",
 "discount_amount": "{number}",
 "duty_amount": "{number}",
 "freight_amount": "{number}",
 "ship_from_zip": "{string}",
 "ship_to_address": {
 "city": "{string}",
 "state": "{string}",
 "zip": "{string}",
 "country": "{string}",
 "email": "{string}",
 "name": "{string}",
 "phone": "{string}",
 "address_1": "{string}",
 "customer_number": "{string}"
 },
 "line_items": [{
 "description": "{string}",
 "quantity": "{string}",
 "commodity_code": "{string}",
 "discount_amount": "{number}",
 "discount_indicator": "{string}",
 "gross_net_indicator": "{string}",
 "line_item_total": "{number}",
 "product_code": "{string}",
 "tax_amount": "{number}",
 "tax_rate": "{number}",
 "tax_type": "{string}",
 "unit_cost": "{number}",
 "unit_of_measure": "{string}"
 }]
 } 
 @endcode
 @see  For more information {@link  https://developer.payeezy.com/payeezy-api-reference/apis/credit-card-payments}
 @result Returns payload response string
 */

-(void)submitAuthorizeTransactionWithL2L3CreditCardDetails:(NSString*)cardType
                                            cardHolderName:(NSString*)cardHolderName
                                                cardNumber:(NSString*)cardNumber
                                   cardExpirymMonthAndYear:(NSString*)cardExpMMYY
                                                   cardCVV:(NSString*)cardCVV
                                              currencyCode:(NSString*)currenyCode
                                               totalAmount:(NSString*)totalAmount
                                  merchantRefForProcessing:(NSString*)merchantRef
                                                completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
  @discussion
 submitPurchaseTransactionWithL2L3CreditCardDetails()
 Level  II
 Level 2 data fields such as Freight, Duty, etc. - values are for informational purposes only and are not
 directly reflected in the Total Amount field for the transaction when processed. It is up to the Merchant
 to ensure that the Total Amount of the transaction reflects the desired Level 2 and 3 amounts. The Discount
 Amount in line items defaults to 0.00 if nothing is entered Card Types Supported:
 1. Visa
 2. Mastercard
 
 Level III
 The following properties are used to populate additional information about the transaction, including shipping details and
 line item information.
 1. Visa
 2. Mastercard
 
 @code
 "level3": {
 "alt_tax_amount": "{number}",
 "alt_tax_id": "{string}",
 "discount_amount": "{number}",
 "duty_amount": "{number}",
 "freight_amount": "{number}",
 "ship_from_zip": "{string}",
 "ship_to_address": {
 "city": "{string}",
 "state": "{string}",
 "zip": "{string}",
 "country": "{string}",
 "email": "{string}",
 "name": "{string}",
 "phone": "{string}",
 "address_1": "{string}",
 "customer_number": "{string}"
 },
 "line_items": [{
 "description": "{string}",
 "quantity": "{string}",
 "commodity_code": "{string}",
 "discount_amount": "{number}",
 "discount_indicator": "{string}",
 "gross_net_indicator": "{string}",
 "line_item_total": "{number}",
 "product_code": "{string}",
 "tax_amount": "{number}",
 "tax_rate": "{number}",
 "tax_type": "{string}",
 "unit_cost": "{number}",
 "unit_of_measure": "{string}"
 }]
 }
 @endcode
 @see  For more information {@link  https://developer.payeezy.com/payeezy-api-reference/apis/credit-card-payments}
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
 @result Returns payload response string
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
                                          customer_number:(NSString*)customer_number                                               completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
 @discussion
 PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 this method support association-sponsored Address Verification Services
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
 @result Returns payload response string
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
                                               completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
 @discussion
 PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 Use this method for 'Subscriptions' or 'Split Shipments' using a previously authorized transaction.
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
                                               completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
  @discussion
 PayeezyClient method to process credit card payments regardless to PKPayment supported devices
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
 @result Returns payload response string
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
                                              completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
 @discussion
 PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 @param cardHolderName
 @param cardNumber
 @param cardType
 @param cardCost
 @param totalAmt
 @param transactiontype
 @param pMethod
 @param currencyCode
 @result Returns payload response string
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
                                 completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
  @discussion
  PayeezyClient method to process credit card payments regardless to PKPayment supported devices
  Use this method to do transactions via tele-check. Supported transactions are Purchase.
 @see For more information, see {@link https://developer.payeezy.com/test_smart_docs/apis/post/transactions-8 }
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
 @result Returns payload response string
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
                                        completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
  @discussion
  PayeezyClient method to process credit card payments regardless to PKPayment supported devices
  Use this method for 'Subscriptions' or 'Split Shipments' using a previously authorized transaction.
  Split shipment
  Sample payload for split payment is shown below
 @code
 split_shipment
 This field is used to provide the shipment fraction and billed for the fraction of the total transaction amount.
 Value: x/y, where x = current shipment & y = total number of shipments.
 If y is not known, y = 99.
 Ex: shipment1 - 01/99,
 shipment2 - 02/99
 ...
 When sending final shipment, x = y
 Ex: shipment3 - 03/03.
 @endcode
 @param merchantRef
 @param transactiontag
 @param transactionType
 @param paymentMethodType
 @param splitShipment
 @param totalAmount
 @param currencyCode
 @result Returns payload response string
 @see
 */
-(void)submitSplitTransactionWithCreditCardDetails:(NSString*)merchantRef
                                    transactiontag:(NSString*)transactiontag
                                   transactionType:(NSString*)transactionType
                                 paymentMethodType:(NSString*)paymentMethodType
                                     splitShipment:(NSString *)splitShipment
                                       totalAmount:(NSString*)totalAmount
                                      currencyCode:(NSString*)currencyCode
                                        completion:(void (^)(NSDictionary *dict, NSError* error))completion;

/*!
 @discussion
 PayeezyClient method to process credit card payments regardless to PKPayment supported devices
 @param amount
 @param transactiontype
 @param pMethod
 @param currencyCode
 @param cardType
 @param cardholderName
 @param cardNumber
 @param expDate
 @result Returns payload response string
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
                                       completion:(void (^)(NSDictionary *dict, NSError* error))completion;

@end


@interface PayeezySDK : NSObject<NSURLConnectionDelegate,NSURLSessionDelegate,PayeezySDK>


@property (nonatomic,strong) NSString* apiKey;
@property (nonatomic,strong) NSString* apiSecret;
@property (nonatomic,strong) NSString* merchantToken;
@property (nonatomic,strong) NSString* merchantIdentifier;
@property (nonatomic,strong) NSString* trToken;
@property (nonatomic,strong) NSString* environment;
@property (nonatomic,strong) NSString* url;

@end

