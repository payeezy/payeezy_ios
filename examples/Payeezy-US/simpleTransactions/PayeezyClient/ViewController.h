//
//  ViewController.h
//  PayeezyClient
//
//  Created by First Data Corporation on 8/28/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//
// 5 test cases are covered in this sample

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *makePaymentButton;
@property (strong, nonatomic) IBOutlet UIButton *makePurchaseVoidVisaCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makeAuthorizeAmexCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makeAuthorizeCaptureVisaCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makePurchaseRefundVisaTransactionCVVButton;


@property (strong, nonatomic) IBOutlet UITextField *amountEntered;
@property (strong, nonatomic) IBOutlet UITextField *merchantNameEntered;

// simple transactions

- (IBAction)purchaseVoidDiscoverTransactionCVV:(id)sender;// test case 1

- (IBAction)purchaseVoidVisaTransactionCVV:(id)sender;// test case 2

- (IBAction)purchaseRefundVisaTransactionCVV:(id)sender; // test case 3

- (IBAction)authorizeCaptureVisaTransactionCVV:(id)sender;// test case 4

- (IBAction)authorizeAmt0VisaTransactionCVV:(id)sender;// test case 5

- (IBAction)authorizeVoidVisaTransactionCVV:(id)sender;// test case 6

@end

