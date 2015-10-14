//
//  ViewController.h
//  PayeezyClient
//
//  Created by First Data Corporation on 5/28/2015.
//  Copyright (c) 2015 First Data Corporation. All rights reserved.
//
// 5 test cases are covered in this sample

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    NSArray * _items;
}


@property (strong, nonatomic) IBOutlet UIButton *makePaymentButton;
@property (strong, nonatomic) IBOutlet UIButton *makePurchaseVoidVisaCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makeAuthorizeAmexCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makeAuthorizeCaptureVisaCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makePurchaseRefundVisaTransactionCVVButton;


@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) NSDictionary* icredit_card;
@property (nonatomic, strong) NSString* fdTokenValue;

@property (strong, nonatomic) IBOutlet UITextField *amountEntered;
@property (strong, nonatomic) IBOutlet UITextField *merchantNameEntered;
@property (weak, nonatomic)   IBOutlet UIImageView *carditCardType;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *wait4Response;


// Generate Token without  ta_token & auth -  - POST API with 0$ Auth
// Generate Token - Backward compatible -  POST API call
// refer documentation for more details
- (IBAction) postTokenizeCreditCards:(id)sender;// test case 1

// Generate Token without  ta_token & auth -  GET API with 0$ Auth
// Generate Token - Backward compatible -  GET API call
// refer documentation for more details

- (IBAction) getTokenizeCreditCards:(id)sender;// test case 1

- (IBAction) purchaseVoidTransactionCVV:(id)sender;// test case 2

- (IBAction) purchaseRefundTransactionCVV:(id)sender; // test case 3

- (IBAction) authorizeAmt0TransactionCVV:(id)sender;// test case 4

- (IBAction) authorizeCaptureTransactionCVV:(id)sender;// test case 5

- (IBAction) authorizeVoidTransactionCVV:(id)sender;// test case 6

//---------------  German Direct Debit (start) -------------------------//

- (IBAction) purchaseVoidAVSTransactionForGermanDirectDebit:(id)sender;// test case 7

- (IBAction) purchaseRefundAVSTransactionForGermanDirectDebit:(id)sender;// test case 8

- (IBAction) creditVoidAVSTransactionForGermanDirectDebit:(id)sender;// test case 9

- (IBAction) purchaseVoidSoftDescTransactionForGermanDirectDebit:(id)sender;// test case 10

- (IBAction) purchaseRefundSoftDescTransactionForGermanDirectDebit:(id)sender;// test case 11

- (IBAction) creditVoidSoftDescTransactionForGermanDirectDebit:(id)sender;// test case 12

- (IBAction) purchaseVoidL2L3TransactionForGermanDirectDebit:(id)sender;// test case 13

- (IBAction) purchaseRefundL2L3TransactionForGermanDirectDebit:(id)sender;// test case 14

- (IBAction) creditVoidL2L3TransactionForGermanDirectDebit:(id)sender;// test case 15


//---------------  German Direct Debit (end) -------------------------//

@end

