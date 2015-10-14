//
//  ViewController.h
//  PayeezyClient

// 5 test cases are covered in this sample

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    NSArray * _cardItems;
     NSArray * _featureItems;
}


@property (strong, nonatomic) IBOutlet UIButton *makePaymentButton;
@property (strong, nonatomic) IBOutlet UIButton *makePurchaseVoidVisaCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makeAuthorizeAmexCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makeAuthorizeCaptureVisaCVVButton;
@property (strong, nonatomic) IBOutlet UIButton *makePurchaseRefundVisaTransactionCVVButton;
// create out UI image objects
@property (strong, nonatomic) UIImage * masterCard ;
@property (strong, nonatomic) UIImage * visaCard ;


@property (nonatomic, strong) NSArray * cardItems;
@property (nonatomic, strong) NSArray * featureItems;

@property (nonatomic, strong) NSDictionary* icredit_card;
@property (nonatomic, strong) NSDictionary* ifeature;

@property (nonatomic, strong) NSString* fdTokenValue;

@property (nonatomic, strong) IBOutlet UIPickerView * cardPickerView;
@property (nonatomic, strong) IBOutlet UIPickerView * featurePickerView;
@property (strong, nonatomic) IBOutlet UITextField *amountEntered;
@property (strong, nonatomic) IBOutlet UITextField *merchantNameEntered;
@property (weak, nonatomic)   IBOutlet UIImageView *carditCardType;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *wait4Response;

- (IBAction)getRateReferenceResponse:(id)sender;// get rate test case 1

- (IBAction)purchaseVoidTransaction:(id)sender;// test case 2

- (IBAction)purchaseRefundTransaction:(id)sender; // test case 3

- (IBAction)nakedRefundTransaction:(id)sender;// test case 4



@end

