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
// create out UI image objects
@property (strong, nonatomic) UIImage * masterCard ;
@property (strong, nonatomic) UIImage * visaCard ;
@property (strong, nonatomic) UIImage * amexCard ;
@property (strong, nonatomic) UIImage * discoverCard;

@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) NSDictionary* icredit_card;
@property (nonatomic, strong) NSString* fdTokenValue;

@property (nonatomic, strong) IBOutlet UIPickerView * pickerView;
@property (strong, nonatomic) IBOutlet UITextField *amountEntered;
@property (strong, nonatomic) IBOutlet UITextField *merchantNameEntered;
@property (weak, nonatomic)   IBOutlet UIImageView *carditCardType;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *wait4Response;


// Generate Token without  ta_token & auth -  - POST API with 0$ Auth
// Generate Token - Backward compatible -  POST API call
// refer documentation for more details
- (IBAction)postTokenizeCreditCards:(id)sender;// test case 1

// Generate Token without  ta_token & auth -  GET API with 0$ Auth
// Generate Token - Backward compatible -  GET API call
// refer documentation for more details

- (IBAction)getTokenizeCreditCards:(id)sender;// test case 1

- (IBAction)purchaseVoidTransactionCVV:(id)sender;// test case 2

- (IBAction)purchaseRefundTransactionCVV:(id)sender; // test case 3

- (IBAction)authorizeAmt0TransactionCVV:(id)sender;// test case 4

- (IBAction)authorizeCaptureTransactionCVV:(id)sender;// test case 5

- (IBAction)authorizeVoidTransactionCVV:(id)sender;// test case 6

@end

