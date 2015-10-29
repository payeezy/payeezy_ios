//
//  ViewController.h
//  PayeezyClient
//
//  Created by First Data Corporation on 5/28/2015.
//  Copyright (c) 2015 First Data Corporation. All rights reserved.
//


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
@property (nonatomic, strong) NSArray * itemsOfType;
@property (nonatomic, strong) NSDictionary* icredit_card;
@property (nonatomic, strong) NSString* reflection;
@property (nonatomic, strong) NSString* fdTokenValue;
@property (nonatomic, strong) NSString* transaction_type;

@property (nonatomic, strong) IBOutlet UIPickerView * cardPickerView;
@property (nonatomic, strong) IBOutlet UIPickerView * typePickerView;
@property (strong, nonatomic) IBOutlet UITextField *amountEntered;
@property (strong, nonatomic) IBOutlet UITextField *merchantNameEntered;
@property (weak, nonatomic)   IBOutlet UIImageView *carditCardType;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *wait4Response;

@property (nonatomic, strong) UISegmentedControl *dccSegmentedControl;



- (IBAction)AuthorizeReversalTransaction:(id)sender;// test case 1

//- (IBAction)AuthorizeCaptureReversalTransaction:(id)sender;// test case 2

- (IBAction)PurchaseReversalTransaction:(id)sender;// test case 3

//- (IBAction)purchaseRefundReversalTransaction:(id)sender; // test case 4

@end

