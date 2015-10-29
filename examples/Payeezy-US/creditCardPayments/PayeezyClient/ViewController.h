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
@property (strong, nonatomic) IBOutlet UITextField *card_holder_name;
@property (strong, nonatomic) IBOutlet UITextField *card_number;
@property (strong, nonatomic) IBOutlet UITextField *card_security_code;

- (IBAction)authorizeCaptureVisaTransactionCVV:(id)sender;// test case 1

@end

