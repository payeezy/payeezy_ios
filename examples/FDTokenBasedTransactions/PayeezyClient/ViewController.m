//
//  ViewController.m
//  PayeezyClient
//
//  Created by First Data Corporation on 5/28/2015.
//  Copyright (c) 2015 First Data Corporation. All rights reserved.
//

#import "ViewController.h"
#import "PayeezySDK.h"


 // Credentials for shared test account in PROD/CERT environment
 // Does NOT process actual transactions cert credentials
#define KApiKey     @"y6pWAJNyJyjGv66IsVuWnklkKUPFbb0a"
#define KApiSecret  @"86fbae7030253af3cd15faef2a1f4b67353e41fb6799f576b5093ae52901e6f7"
#define KToken      @"fdoa-a480ce8951daa73262734cf102641994c1e55e7cdf4c02b6"
 
 // use following url to get token and proceed for transactions
#define KURL        @"https://api-cert.payeezy.com/v1/transactions/tokens"
 // use following url for transactions
#define PURL        @"https://api-cert.payeezy.com/v1/transactions"
 

 
@interface ViewController ()

@end

@implementation ViewController{
}

@synthesize pickerView;
@synthesize carditCardType;
@synthesize icredit_card;
@synthesize items = _items;

// create out UI image objects
@synthesize  masterCard ;
@synthesize  visaCard  ;
@synthesize  amexCard ;
@synthesize  discoverCard ;
@synthesize  fdTokenValue;

/*!
 *
 * \param
 * \returns
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set delegate and datasource of the pickerView
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    
    //init items array with colors
    self.items = [[NSArray alloc] initWithObjects:@"Select Test Credit Card & Payeezy Payment method+",@"Visa-4005519200000004-1030-123", @"Master-5424180279791732-0416-123",@"Amex-028426321341004-0416-1234", @"Discover-6011000990099818-0416-123",nil];
    
    // create out UI image objects
    masterCard = [UIImage imageNamed:@"mastercard.jpg"];
    visaCard = [UIImage imageNamed:@"visa.png"];
    amexCard = [UIImage imageNamed:@"american.jpg"];
    discoverCard = [UIImage imageNamed:@"discover.jpg"];
    
    carditCardType.image = amexCard;
    self.icredit_card = @{
                          @"type":@"American Express",
                          @"cardholder_name":@"John Smith",
                          @"card_number":@"373953192351004",
                          @"exp_date":@"0416",
                          @"cvv":@"1234"
                          };
    
}

/*!
 *
 * \param
 * \returns
 */
- (void)viewDidAppear:(BOOL)animated{
    _amountEntered.text = @"";
}

/*!
 *
 * \param
 * \returns
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIPickerView DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.items count];
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, self.pickerView.frame.size.height / 2 - 15, 400, 30)];
    [label setFont:[UIFont fontWithName:@"TrebuchetMS-Italic" size:13.0]];
    [label setTextColor:[UIColor darkTextColor]];
    
    label.text = [NSString stringWithFormat:@"%@", [self.items objectAtIndex:row]];
    label.textAlignment = NSTextAlignmentLeft; //Changed to NS as UI is deprecated.
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
       
    
    switch (row) {
            
        case 0:
            break;
            
        case 1:
            carditCardType.image = visaCard;
            self.icredit_card = @{
                                  @"type":@"visa",
                                  @"cardholder_name":@"John Smith",
                                  @"card_number":@"4005519200000004",
                                  @"exp_date":@"1030",
                                  @"cvv":@"123"
                                  };
            break;
            
        case 2:
            carditCardType.image = masterCard;
            self.icredit_card = @{
                                  @"type":@"Mastercard",
                                  @"cardholder_name":@"John Smith",
                                  @"card_number":@"5424180279791732",
                                  @"exp_date":@"1030",
                                  @"cvv":@"123"
                                  };
            break;
        case 3:
            carditCardType.image = amexCard;
            self.icredit_card = @{
                                  @"type":@"American Express",
                                  @"cardholder_name":@"John Smith",
                                  @"card_number":@"373953192351004",
                                  @"exp_date":@"0416",
                                  @"cvv":@"1234"
                                  };
            break;
            
        case 4:
            carditCardType.image = discoverCard;
            self.icredit_card = @{
                                  @"type":@"discover",
                                  @"cardholder_name":@"John Smith",
                                  @"card_number":@"6011000990099818",
                                  @"exp_date":@"0416",
                                  @"cvv":@"123"
                                  };
            break;
            
        default:
            carditCardType.image = amexCard;
            self.icredit_card = @{
                                  @"type":@"American Express",
                                  @"cardholder_name":@"John Smith",
                                  @"card_number":@"373953192351004",
                                  @"exp_date":@"0416",
                                  @"cvv":@"1234"
                                  };
            
            break;
    }
    
}


/*!
 * sample transaction - getFDToken using credit card
 * \param id
 * \returns IBAction
 */
// test case 4
- (IBAction)getFDToken:(id)sender {
    
         // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
    
        // Test credit card info
        // mutliple test cases
    
        NSDictionary* tokenizer = @{
                                      @"type":@"FDToken",  // you can change to Amex/Discover/Master Card here
                                      @"auth":@"false",
                                      @"ta_token":@"NOIW"
                                    };
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        if(![self.wait4Response isAnimating]){
            [self.wait4Response startAnimating];
        }
    
        [myClient submitGetFDTokenForCreditCard:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] type:tokenizer[@"type"] auth:tokenizer[@"auth"] ta_token:tokenizer[@"ta_token"] completion:^(NSDictionary *dict, NSError *error)
       {
           if([self.wait4Response isAnimating]){
            [self.wait4Response stopAnimating];
               
        }
        

        NSString *authStatusMessage = nil;
        
        NSDictionary *result = [dict objectForKey:@"token"];
        
        authStatusMessage = [NSString
                             stringWithFormat:@"Transaction details\r status:%@ \r  correlation id:%@ \r Tokenized Value:%@ \r type:%@  ", [dict objectForKey:@"status"],[dict objectForKey:@"correlation_id"],
                             [result objectForKey:@"value"],
                             [dict objectForKey:@"type"]];
        
        self.fdTokenValue =[result objectForKey:@"value"];
        
        /*  if (error == nil){
         authStatusMessage = [NSString stringWithFormat:@"Transaction details\r correlation_id:%@",
         [dict objectForKey:@"correlation_id"]];
         } else {
         authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         */
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                        message:authStatusMessage delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }];
   
}

/*!
 * Sample method for authorize Void using visa card
 * \param id
 * \returns IBAction
 */

- (IBAction)authorizeVoidTransactionCVV:(id)sender {
    
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:self.fdTokenValue cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"bank_resp_code"],
                                  [dict objectForKey:@"transaction_status"] ];
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
              
             [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"]  :@"200"];
                 
             }
            }
            else
            {
                authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                            message:authStatusMessage delegate:self
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    
}

/*!
 * Authorize Amt0 Visa Transaction CVV
 * \param id
 * \returns IBAction
 */
// test case 5
- (IBAction)authorizeAmt0TransactionCVV:(id)sender {
    
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:self.fdTokenValue cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"0" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"bank_resp_code"],
                                  [dict objectForKey:@"transaction_status"] ];
             }
             else
             {
                 authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
             }
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                             message:authStatusMessage delegate:self
                                                   cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:nil];
             [alert show];
         }];
    
}



/*!
 * Sample method for purchase Refund using visa card
 * \param id
 * \returns IBAction
 */
// test case 3
- (IBAction)purchaseRefundTransactionCVV:(id)sender {
    
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:self.fdTokenValue cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"purchase" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"bank_resp_code"],
                                  [dict objectForKey:@"transaction_status"] ];
            
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 
          [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"refund" :[dict objectForKey:@"transaction_id"] :@"200"];
             
             }
        }
        else
        {
            authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                        message:authStatusMessage delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
}


// test case 2
// Sample method for purchase Void using Discover card

- (IBAction)purchaseVoidTransactionCVV:(id)sender{
    
        // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
    
       PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
        if(![self.wait4Response isAnimating]){
            [self.wait4Response startAnimating];
        }
    
      [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:self.fdTokenValue cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"purchase" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
        {
           
           if([self.wait4Response isAnimating]){
               [self.wait4Response stopAnimating];
            }
           
        NSString *authStatusMessage = nil;
        
        if (error == nil)
        {
            authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                 [dict objectForKey:@"transaction_type"],
                                 [dict objectForKey:@"transaction_tag"],
                                 [dict objectForKey:@"correlation_id"],
                                 [dict objectForKey:@"bank_resp_code"],
                                 [dict objectForKey:@"transaction_status"] ];
            NSLog(@"authStatusMessage: %@",authStatusMessage);
            // calling void method here and pasing required parameneters
            if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
            [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :@"200"];
            }
           
            
        }
        else
        {
            authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                        message:authStatusMessage delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
       }];
}

// Sample method for purchase Void using Discover card test case 1

- (IBAction)authorizeVoidTransaction:(id)sender{
    

        
        // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:KURL];
        
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token"
         
                                                      completion:^(NSDictionary *dict, NSError *error) {
                                                          
                                                          NSString *authStatusMessage = nil;
                                                          
                                                          if (error == nil)
                                                          {
                                                              authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",
                                                                                   [dict objectForKey:@"transaction_type"],
                                                                                   [dict objectForKey:@"transaction_id"],
                                                                                   [dict objectForKey:@"transaction_tag"],
                                                                                   [dict objectForKey:@"correlation_id"],
                                                                                   [dict objectForKey:@"bank_resp_code"]];
                                                              
                                                              // calling void method here and pasing required parameneters
                                                              if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                                                                  
                                                              [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :@"200"];
                                                              }
                                                           
                                                              
                                                          }
                                                          else
                                                          {
                                                              authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                          }
                                                          
                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                                                          message:authStatusMessage delegate:self
                                                                                                cancelButtonTitle:@"Dismiss"
                                                                                                otherButtonTitles:nil];
                                                          [alert show];
                                                      }];
    
}


/*!
 * sample transaction - authorize Capture using visa
 * \param id
 * \returns IBAction
 */
// test case 4
- (IBAction)authorizeCaptureTransactionCVV:(id)sender {
    
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:PURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:self.fdTokenValue cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
     {
         
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
         }
         
         NSString *authStatusMessage = nil;
         
         if (error == nil)
         {
             authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                  [dict objectForKey:@"transaction_type"],
                                  [dict objectForKey:@"transaction_tag"],
                                  [dict objectForKey:@"correlation_id"],
                                  [dict objectForKey:@"bank_resp_code"],
                                  [dict objectForKey:@"transaction_status"] ];
             if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                 
             [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"capture" :[dict objectForKey:@"transaction_id"] :@"200"];
             }
             
         }
         else
         {
             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                         message:authStatusMessage delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
         [alert show];
     }];
    
}



/*!
 *
 * \param id
 * \returns IBAction
 */
- (IBAction)authorizeVoidTransactionAmex:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:KURL];
        
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token"
                                                       completion:^(NSDictionary *dict, NSError *error) {
                                                           
                                                           NSString *authStatusMessage = nil;
                                                           
                                                           if (error == nil)
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",
                                                                                    [dict objectForKey:@"transaction_type"],
                                                                                    [dict objectForKey:@"transaction_id"],
                                                                                    [dict objectForKey:@"transaction_tag"],
                                                                                    [dict objectForKey:@"correlation_id"],
                                                                                    [dict objectForKey:@"bank_resp_code"]];
                                                               
                                                               [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"void" :[dict objectForKey:@"transaction_id"] :amount];
                                                           }
                                                           else
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                           }
                                                           
                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                                                           message:authStatusMessage delegate:self
                                                                                                 cancelButtonTitle:@"Dismiss"
                                                                                                 otherButtonTitles:nil];
                                                           [alert show];
                                                       }];
    }
}

/*!
 *
 * \param id
 * \returns IBAction
 */

- (IBAction)authorizeRefundTransactionDiscover:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        NSString *amount = [[NSString stringWithFormat:@"%@",valueEntered] stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:KURL];
        
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"authorize" token_type:@"FDToken" method:@"token"
         
                                                       completion:^(NSDictionary *dict, NSError *error) {
                                                           
                                                           NSString *authStatusMessage = nil;
                                                           
                                                           if (error == nil)
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",
                                                                                    [dict objectForKey:@"transaction_type"],
                                                                                    [dict objectForKey:@"transaction_id"],
                                                                                    [dict objectForKey:@"transaction_tag"],
                                                                                    [dict objectForKey:@"correlation_id"],
                                                                                    [dict objectForKey:@"bank_resp_code"]];
                                                               [self voidRefundCaptureTransaction:@"abc1412096293369" :[dict objectForKey:@"transaction_tag"] :@"refund" :[dict objectForKey:@"transaction_id"] :amount];
                                                           }
                                                           else
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                           }
                                                           
                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                                                           message:authStatusMessage delegate:self
                                                                                                 cancelButtonTitle:@"Dismiss"
                                                                                                 otherButtonTitles:nil];
                                                           [alert show];
                                                       }];
    }
}

/*!
 *
 * \param id
 * \returns IBAction
 */

- (IBAction)purchaseVoidTransaction:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
       
        
        // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"purchase" token_type:@"FDToken" method:@"token"
         
                                                       completion:^(NSDictionary *dict, NSError *error) {
                                                           
                                                           NSString *authStatusMessage = nil;
                                                           
                                                           if (error == nil)
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",
                                                                                    [dict objectForKey:@"transaction_type"],
                                                                                    [dict objectForKey:@"transaction_id"],
                                                                                    [dict objectForKey:@"transaction_tag"],
                                                                                    [dict objectForKey:@"correlation_id"],
                                                                                    [dict objectForKey:@"bank_resp_code"]];                                                           }
                                                           else
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                           }
                                                           
                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                                                           message:authStatusMessage delegate:self
                                                                                                 cancelButtonTitle:@"Dismiss"
                                                                                                 otherButtonTitles:nil];
                                                           [alert show];
                                                       }];
    }
}

/*!
 *
 * \param id
 * \returns IBAction
 */

- (IBAction)purchaseRefundTransaction:(id)sender {
    
    NSDecimalNumber* valueEntered = [NSDecimalNumber decimalNumberWithString:_amountEntered.text];
    
    if (![valueEntered isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        
        
        // Test credit card info
        NSDictionary* credit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":@"Eck Test 3",
                                      @"card_number":@"4012000033330026",
                                      @"exp_date":@"0416",
                                      @"cvv":@"123"
                                      };
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        //myClient.url = KURL;
        
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:credit_card[@"card_number"] cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:@"USD" totalAmount:@"200" merchantRef:@"abc1412096293369"   transactionType:@"purchase" token_type:@"FDToken" method:@"token"
         
                                                       completion:^(NSDictionary *dict, NSError *error) {
                                                           
                                                           NSString *authStatusMessage = nil;
                                                           
                                                           if (error == nil)
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",
                                                                                    [dict objectForKey:@"transaction_type"],
                                                                                    [dict objectForKey:@"transaction_id"],
                                                                                    [dict objectForKey:@"transaction_tag"],
                                                                                    [dict objectForKey:@"correlation_id"],
                                                                                    [dict objectForKey:@"bank_resp_code"]];
                                                           }
                                                           else
                                                           {
                                                               authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                           }
                                                           
                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                                                           message:authStatusMessage delegate:self
                                                                                                 cancelButtonTitle:@"Dismiss"
                                                                                                 otherButtonTitles:nil];
                                                           [alert show];
                                                       }];
    }
}



/*!
 * voidTransaction
 * \param
 * \returns
 */
- (IBAction)voidRefundCaptureTransaction:(NSString *)merchant_ref :(NSString *)transaction_tag  :(NSString *)transaction_type   :(NSString *)transaction_id :(NSString *)totalamount  {
  
        // Test credit card info
        NSDictionary* void_transaction = @{
                                           @"merchant_ref": merchant_ref,
                                           @"transaction_tag": transaction_tag,
                                           @"transaction_type": transaction_type,
                                           @"transaction_id": transaction_id,
                                           @"method": @"credit_card",
                                           @"amount": totalamount,
                                           @"currency_code": @"USD"
                                           };
        
        NSString *vcrURL = [NSString stringWithFormat: @"%@/%@", PURL, transaction_id];
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:vcrURL];
        
        [myClient submitVoidCaptureRefundTransactionWithCreditCardDetails:void_transaction[@"merchant_ref"] transactiontag:void_transaction[@"transaction_tag"] transactionType:void_transaction[@"transaction_type"] transactionId:void_transaction[@"transaction_id"] paymentMethodType:void_transaction[@"method"] totalAmount:void_transaction[@"amount"] currencyCode:@"USD" completion:^(NSDictionary *dict, NSError *error) {
            
            NSString *authStatusMessage = nil;
            
            if (error == nil)
            {
                authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@",
                                     [dict objectForKey:@"transaction_type"],
                                     [dict objectForKey:@"transaction_id"],
                                     [dict objectForKey:@"transaction_tag"]];
                 NSLog(@"authStatusMessage: %@",authStatusMessage);
            }
            else
            {
                authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                            message:authStatusMessage delegate:self
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    
}




@end
