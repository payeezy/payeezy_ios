//
//  ViewController.h
//  PayeezyClient
//
//  Created by First Data Corporation on 8/28/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *makePaymentButton;
@property (strong, nonatomic) IBOutlet UIButton *makePurchaseVoidVisaCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makeAuthorizeAmexCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makeAuthorizeCaptureVisaCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makePurchaseRefundVisaTransactionCVVButton;


@property (strong, nonatomic) IBOutlet UITextField *amountEntered;
@property (strong, nonatomic) IBOutlet UITextField *merchantNameEntered;

- (IBAction)authorizeTransaction:(id)sender;

// CCV Visa testcases

- (IBAction)purchaseVoidMasterCardTransactionCVV:(id)sender;


/**IMP**/
- (IBAction)purchaseVoidVisaTransactionCVV:(id)sender;// test 1
/**IMP**/
- (IBAction)purchaseRefundVisaTransactionCVV:(id)sender; // test 2
/**IMP**/
- (IBAction)authorizeCaptureVisaTransactionCVV:(id)sender;// test 3



/**IMP**/
- (IBAction)authorizeAmt0VisaTransactionCVV:(id)sender;
/**IMP**/
- (IBAction)authorizeVoidVisaTransactionCVV:(id)sender;

/**IMP_**/
- (IBAction)purchaseVoidDiscoverTransactionCVV:(id)sender;
- (IBAction)purchaseRefundAmexTransactionCVV:(id)sender;
- (IBAction)purchaseRefundMasterCardTransactionCVV:(id)sender;

// CVV Amex testcases
- (IBAction)authorizeVoidAmexTransactionCVV:(id)sender;
- (IBAction)purchaseVoidAmexTransactionCVV:(id)sender;
- (IBAction)authorizeCaptureAmexTransactionCVV:(id)sender;

// CVV MasterCard testcases


- (IBAction)authorizeAmt0MasterCardTransactionCVV:(id)sender;
- (IBAction)authorizeVoidMasterCardTransactionCVV:(id)sender;
- (IBAction)authorizeCaptureMasterCardTransactionCVV:(id)sender;

// CVV Discover testcases

- (IBAction)purchaseRefundDiscoverTransactionCVV:(id)sender;
- (IBAction)authorizeAmt0DiscoverTransactionCVV:(id)sender;
- (IBAction)authorizeVoidDiscoverTransactionCVV:(id)sender;
- (IBAction)authorizeCaptureDiscoverTransactionCVV:(id)sender;

// AVS Visa testcases
- (IBAction)purchaseVoidVisaTransactionAVS:(id)sender;
- (IBAction)purchaseRefundVisaTransactionAVS:(id)sender;
/**IMP**/
- (IBAction)authorizeAmt0VisaTransactionAVS:(id)sender;// test 4
- (IBAction)authorizeVoidVisaTransactionAVS:(id)sender;
- (IBAction)authorizeCaptureVisaTransactionAVS:(id)sender;

// AVS Amex testcases
- (IBAction)purchaseVoidAmexTransactionAVS:(id)sender;
- (IBAction)purchaseRefundAmexTransactionAVS:(id)sender;
- (IBAction)authorizeAmt0AmexTransactionAVS:(id)sender;
- (IBAction)authorizeVoidAmexTransactionAVS:(id)sender;
- (IBAction)authorizeCaptureAmexTransactionAVS:(id)sender;

// AVS MasterCard testcases
- (IBAction)purchaseVoidMasterCardTransactionAVS:(id)sender;
- (IBAction)purchaseRefundMasterCardTransactionAVS:(id)sender;
- (IBAction)authorizeAmt0MasterCardTransactionAVS:(id)sender;
- (IBAction)authorizeVoidMasterCardTransactionAVS:(id)sender;
- (IBAction)authorizeCaptureMasterCardTransactionAVS:(id)sender;

// AVS Discover testcases
- (IBAction)purchaseVoidDiscoverTransactionAVS:(id)sender;
- (IBAction)purchaseRefundDiscoverTransactionAVS:(id)sender;
- (IBAction)authorizeAmt0DiscoverTransactionAVS:(id)sender;
- (IBAction)authorizeVoidDiscoverTransactionAVS:(id)sender;
- (IBAction)authorizeCaptureDiscoverTransactionAVS:(id)sender;

// Split shipments
/**IMP**/
- (IBAction)authorizeSplitDiscoverTransaction:(id)sender; // test 5


// L2 Amex testcases
- (IBAction)purchaseAmexTransactionL2:(id)sender;
/**IMP**/
- (IBAction)authorizeCaptureAmexTransactionL2:(id)sender; // test 6
- (IBAction)regularCaptureAmexTransactionL2:(id)sender;

// L2 L3 - Visa
/**IMP**/
- (IBAction)purchaseVisaTransactionL2L3:(id)sender; // test 7
- (IBAction)authorizeCaptureVisaTransactionSplit:(id)sender;
- (IBAction)regularCaptureVisaTransactionSplit:(id)sender;

// L2 L3 - Master Card
/**IMP_**/
- (IBAction)purchaseMasterCardTransactionSplit:(id)sender; // test 8
- (IBAction)authorizeCaptureMasterCardTransactionSplit:(id)sender;
- (IBAction)regularCaptureMasterCardTransactionSplit:(id)sender;

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

- (IBAction)purchaseAmexTransactionRecurringPayment:(id)sender;
- (IBAction)authorizeAmexTransactionRecurringPayment:(id)sender;


- (IBAction)authorizeVisaTransactionRecurringPayment:(id)sender;

- (IBAction)purchaseMasterCardTransactionRecurringPayment:(id)sender;
- (IBAction)authorizeMasterCardTransactionRecurringPayment:(id)sender;

- (IBAction)purchaseDiscoverTransactionRecurringPayment:(id)sender;

/**IMP Recurring indicator	Visa	Purchase **/
- (IBAction)authorizeDiscoverTransactionRecurringPayment:(id)sender; // test 9
/** IMP
 {
 "amount":"1937",
 "transaction_type":"purchase",
 "merchant_ref":"abc1412096293369",
 "method":"credit_card",
 "currency_code":"USD",
 "credit_card":{
 "type":"visa",
 "cardholder_name":"Eck Test 3",
 "card_number":"4012000033330026",
 "exp_date":"0416",
 "cvv":"123"
 },"eci_indicator":"2"
 }
 **/
- (IBAction)purchaseVisaTransactionRecurringPayment:(id)sender; // TO DO

//Soft descriptor - Visa

- (IBAction)purchaseVisaTransactionSoftDescriptor:(id)sender;
/**IMP**/
- (IBAction)authorizeCaptureVisaTransactionSoftDescriptor:(id)sender; //test 10
- (IBAction)regularCaptureVisaTransactionSoftDescriptor:(id)sender;

//Soft descriptor - Master Card
- (IBAction)purchaseMasterCardTransactionSoftDescriptor:(id)sender;
- (IBAction)authorizeCaptureMasterCardTransactionSoftDescriptor:(id)sender;
- (IBAction)regularCaptureMasterCardTransactionSoftDescriptor:(id)sender;

//Soft descriptor - Discover
- (IBAction)purchaseDiscoverTransactionSoftDescriptor:(id)sender;
- (IBAction)authorizeCaptureDiscoverTransactionSoftDescriptor:(id)sender;
- (IBAction)regularCaptureDiscoverTransactionSoftDescriptor:(id)sender;

//Soft descriptor - Discover
- (IBAction)purchaseAmexCardTransactionSoftDescriptor:(id)sender;
- (IBAction)authorizeCaptureAmexTransactionSoftDescriptor:(id)sender;
- (IBAction)regularCaptureAmexTransactionSoftDescriptor:(id)sender;

//Transarmor
/*
 {
 "merchant_ref": "GODADDY",
 "transaction_type": "authorize",
 "method": "token",
 "amount": "0733",
 "currency_code": "USD",     "token": { "token_type":"transarmor",
 "token": {
 "token_type":"transarmor",
 "token_data":{
 "value" : "028426321341004",
 "type": "American Express",
 "cardholder_name": "xyz",
 "exp_date": "0416",
 "cvv":"1234"
 }
 }
 }
 
 Void:
 {
 "merchant_ref": "GODADDY",
 "transaction_type": "void",
 "method": "token",
 "amount": "0733",
 "currency_code": "USD",     "token": { "token_type":"transarmor",
 "token_data": {
 "value": "028426321341004",
 "type": "American Express",
 "cardholder_name": "xyz",
 "exp_date": "0416"
 }
 }
 */
/**IMP_**/
- (IBAction)authorizeVoidMastercardTransactionCVVTransarmor:(id)sender; // test 11


// ValueLink transaction
/** IMP**/
- (IBAction)activationTransactionValueLink:(id)sender;

/** IMP_**/
//ValueLink	Gift	Purchase - naked void

- (IBAction)purchaseTransactionValueLink:(id)sender;
- (IBAction)cashoutNakedVoidTransactionValueLink:(id)sender;
- (IBAction)reloadTaggedVoidTransactionValueLink:(id)sender;
- (IBAction)purchaseNakedVoidTransactionValueLink:(id)sender;
- (IBAction)purchaseTaggedVoidTransactionValueLink:(id)sender;
- (IBAction)taggedRefundTaggedVoidTransactionValueLink:(id)sender;
- (IBAction)nakedRefundTransactionValueLink:(id)sender;
- (IBAction)balanceInquiryTransactionValueLink:(id)sender;
- (IBAction)splitTenderingPurchaseTransactionValueLink:(id)sender;


/** Naked Refund	Discover	Refund
 {"amount":"2010","transaction_type":"refund","method":"credit_card","currency_code":"USD","credit_card":{"type":"discover","cardholder_name":"JT Refund Discover", "card_number":"6510000000001248","exp_date":"0416"}}
 **/
/** IMP**/
- (IBAction)nakedRefundDiscoverRefundTransaction:(id)sender;



/** Naked void	Discover	Purchase - naked void	"{
amount:0109,
transaction_type:purchase,
merchant_ref:abc1412096293369,
method:credit_card,
currency_code:USD,
credit_card:{
    ""type"":""discover,
    ""cardholder_name"":""Eck Test 3"",
    ""card_number"":""6011000990099818"",
    ""exp_date"":""0416"",
    ""cvv"":""123""
}
}

Naked Void: OK5485
{
    ""amount"":""0109"",
    ""transaction_type"":""void"",
    ""merchant_ref"":""abc1412096293369"",
    ""method"":""credit_card"",
    ""currency_code"":""USD"",
    ""credit_card"":{
        ""type"":""discover"",
        ""cardholder_name"":""Eck Test 3"",
        ""card_number"":""6011000990099818"",
        ""exp_date"":""0416"",
        ""cvv"":""123""
    }
}
"
**/

//Purchase Telecheck	Personal
/** IMP **/
- (IBAction)purchaseTelecheckPersonalTransaction:(id)sender;

//- (IBAction)voidTransaction:(id)sender;
//- (IBAction)captureTransaction:(id)sender;
//- (IBAction)refundTransaction:(id)sender;



@end

