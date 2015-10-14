//
//  ViewController.m
//  PayeezyClient


#import "ViewController.h"
#import "PayeezySDK.h"

/*
 Refer developer.payeezy.com = d.payeezy.com = dev portal
 Securing APIKey, token constant values in IOS app :
 http://stackoverflow.com/questions/9448632/best-practices-for-ios-applications-security?rq=1
 */

/* Cert/Demo enviroment for test and integartion */
#define kEnvironment @"QA"

/* Refer to dev portal -> 'My APIs' page -> app -> API Key */
#define KApiKey     @"ehCz1VGlwNeeGcN5LjA5c2nvWKTnEZRn"

/* Refer to dev portal -> 'My APIs' page -> app -> API Key */
//#define KApiKey     @"fP0iYUx4oJ8LolKl2LiOT1Zo94mL0IDQ"


/* Refer to dev portal -> 'My APIs' page -> app -> Api Secret */
//#define KApiSecret  @"2b940ece234ee38131e70cc617aa2afa3d7ff8508856917958e7feb3gk289436"
#define KApiSecret  @"3b940fce234ee38131e70cc617aa2afa3d7ff8508856917958e7feb3ef190448"


/* Refer to dev portal -> 'My Merchants' page -> SANDBOX -> Token */
//#define KToken      @"fdoa-d5i0ree9t1dae7b2i2t34cf102641994c1e55e7cdf4c02b7"

/* Refer to dev portal -> 'My Merchants' page -> SANDBOX -> Token */
#define KToken      @"fdoa-d790ce8951daa73262645cf102641994c1e55e7cdf4c03c8"

/* use following url to get token (POST) and proceed for transactions */
#define KURL        @"https://api-cert.payeezy.com/v1/transactions/tokens"

/* use following url to get token (GET) and proceed for transactions */
#define SURL        @"https://api-cert.payeezy.com/v1/securitytokens?"

/* use following url for transactions */
#define PURL        @"https://api-qa.payeezy.com/v1/transactions"

/* use following url for transactions */
#define DCC_URL        @"https://api-qa.payeezy.com/v1/transactions/exchange_rate"

 
/*
 DCC is only for Visa and Master Card
 
 CVV      -> Visa       -> Naked Refund,  Purchase - Void, Purchase - Refund
 
 CVV      -> MasterCard -> Naked Refund,  Purchase - Void, Purchase - Refund
 
 AVS      -> Visa       -> Naked Refund,  Purchase - Void, Purchase - Refund
 
 AVS      -> MasterCard -> Naked Refund,  Purchase - Void, Purchase - Refund

 SoftDesc -> Visa       -> Naked Refund,  Purchase - Void, Purchase - Refund
 
 SoftDesc -> MasterCard -> Naked Refund,  Purchase - Void, Purchase - Refund
 
 */
 
@interface ViewController ()

@end

@implementation ViewController{
}

@synthesize cardPickerView;
@synthesize featurePickerView;
@synthesize carditCardType;
@synthesize icredit_card;
@synthesize cardItems = _cardItems;
@synthesize featureItems = _featureItems;

// create out UI image objects
@synthesize  masterCard ;
@synthesize  visaCard  ;


/*!
 *
 * \param
 * \returns
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set delegate and datasource of the pickerView
    self.cardPickerView.delegate = self;
    self.cardPickerView.dataSource = self;
    
    self.featurePickerView.delegate = self;
    self.featurePickerView.dataSource = self;
    
    
    //init items array with colors
    self.cardItems = [[NSArray alloc] initWithObjects:@"Select Payeezy Test Credit Card+",@"Visa-4005519200000004-1030-123", @"Master-5424180279791732-0416-123",nil];
    
    //init items array with colors
    self.featureItems = [[NSArray alloc] initWithObjects:@"Select Payeezy Payment method+",@"CVV", @"AVS", @"Soft Descriptor",nil];
    
    
    // create out UI image objects
    masterCard = [UIImage imageNamed:@"mastercard.jpg"];
    visaCard = [UIImage imageNamed:@"visa.png"];
 
    
    carditCardType.image = visaCard;
    self.icredit_card = @{
                          @"type":@"Visa",
                          @"cardholder_name":@"John Smith",
                          @"card_number":@"4005519200000004",
                          @"exp_date":@"1030",
                          @"cvv":@"123"
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
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)cardPickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.cardPickerView){
        return [self.cardItems count];
    }else if (pickerView == self.featurePickerView){
        return [self.featureItems count];
    }else {
        return 0;
    }
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)cardPickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (pickerView == self.cardPickerView){
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, self.cardPickerView.frame.size.height / 2 - 15, 400, 30)];
        [label setFont:[UIFont fontWithName:@"TrebuchetMS-Italic" size:13.0]];
        [label setTextColor:[UIColor darkTextColor]];
        
        label.text = [NSString stringWithFormat:@"%@", [self.cardItems objectAtIndex:row]];
        label.textAlignment = NSTextAlignmentLeft; //Changed to NS as UI is deprecated.
        label.backgroundColor = [UIColor clearColor];
        
        return label;
    }else if (pickerView == self.featurePickerView){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, self.featurePickerView.frame.size.height / 2 - 15, 400, 30)];
        [label setFont:[UIFont fontWithName:@"TrebuchetMS-Italic" size:13.0]];
        [label setTextColor:[UIColor darkTextColor]];
        
        label.text = [NSString stringWithFormat:@"%@", [self.featureItems objectAtIndex:row]];
        label.textAlignment = NSTextAlignmentLeft; //Changed to NS as UI is deprecated.
        label.backgroundColor = [UIColor clearColor];
        
        return label;
    } else {
        return nil;
    }
}

//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.cardPickerView){
        
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
                
            default:
                carditCardType.image = visaCard;
                self.icredit_card = @{
                                      @"type":@"visa",
                                      @"cardholder_name":@"John Smith",
                                      @"card_number":@"4005519200000004",
                                      @"exp_date":@"1030",
                                      @"cvv":@"123"
                                      };
                break;
                
        }
    }else if (pickerView == self.featurePickerView){
        
    }
    
}


/*!
 * sample transaction - getFDToken using credit card
 * \param id
 * \returns IBAction
 */
// test case 4
- (IBAction)postTokenizeCreditCards:(id)sender {
    
         // Test credit card info
        NSDictionary* credit_card = self.icredit_card ;
    
        NSDictionary* tokenizer = @{
                                      @"type":@"FDToken",  // you can change to Amex/Discover/Master Card here
                                      @"auth":@"false",
                                      @"ta_token":@"NOIW"   // to fetch ta_token please refer developer.payeezy
                                    };
        
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
        
        if(![self.wait4Response isAnimating]){
            [self.wait4Response startAnimating];
        }
    
        [myClient submitPostFDTokenForCreditCard:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] type:tokenizer[@"type"] auth:tokenizer[@"auth"] ta_token:tokenizer[@"ta_token"] completion:^(NSDictionary *dict, NSError *error)
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                        message:authStatusMessage delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }];
   
}

/*!
 * sample transaction - getFDToken using credit card
 * \param id
 * \returns IBAction
 */
// test case 4
- (IBAction)getTokenizeCreditCards:(id)sender {
    
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    
    NSDictionary* tokenizer = @{
                                @"type":@"FDToken",  // you can change to Amex/Discover/Master Card here
                                @"auth":@"false",
                                @"ta_token":@"NOIW",
                                @"js_security_key":@"js-6125e57ce5c46e10087a545b9e9d7354c23e1a1670d9e9c7",  // you can change it to object variable as you have apikey
                                @"callback":@"Payeezy.callback"
                                };
   
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:SURL];
    
    if(![self.wait4Response isAnimating]){
        [self.wait4Response startAnimating];
    }
    
    [myClient submitGetFDTokenForCreditCard:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] type:tokenizer[@"type"] auth:tokenizer[@"auth"] ta_token:tokenizer[@"ta_token"] js_security_key:tokenizer[@"js_security_key"] callback:tokenizer[@"callback"] completion:^(NSString *dict, NSError *error)
     {
         if([self.wait4Response isAnimating]){
             [self.wait4Response stopAnimating];
             
         }
        
         // parse the response  substring to read = Payeezy.callback( .... )
         NSString *result = nil;
         NSString *authStatusMessage = nil;
         
         
         // Determine "<div>" location
         NSRange divRange = [dict rangeOfString:@"(" options:NSCaseInsensitiveSearch];
         if (divRange.location != NSNotFound)
         {
             // Determine "</div>" location according to "<div>" location
             NSRange endDivRange;
             
             endDivRange.location = divRange.length + divRange.location;
             endDivRange.length   = [dict length] - endDivRange.location;
             endDivRange = [dict rangeOfString:@")" options:NSCaseInsensitiveSearch range:endDivRange];
             
             if (endDivRange.location != NSNotFound)
             {
                 // Tags found: retrieve string between them
                 divRange.location += divRange.length;
                 divRange.length = endDivRange.location - divRange.location;
                 
                 result = [dict substringWithRange:divRange];
             }
         }
         
         //parse login end
         
         // convert json string to NSDictionary
         
         NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         NSDictionary *results = [json objectForKey:@"results"];
         
         
         NSDictionary *tokenKey = [results objectForKey:@"token"];
         
       //  NSLog(@"results ::::: %@",tokenKey);
         
         self.fdTokenValue =[tokenKey objectForKey:@"value"];

        // NSLog(@"results ::::: %@",self.fdTokenValue);
         
         authStatusMessage = [NSString
                              stringWithFormat:@"Transaction details\r status:%@ \r  correlation id:%@ \r Tokenized Value:%@ \r type:%@  ", [results objectForKey:@"status"],[results objectForKey:@"correlation_id"],
                              [tokenKey objectForKey:@"value"],
                              [tokenKey objectForKey:@"type"]];
         
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



/*!
 *
 * \param id
 * \returns IBAction
 */

- (IBAction)purchaseVoidTransaction:(id)sender {
    
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

/*!
 *
 * \param id
 * \returns IBAction
 */

- (IBAction)purchaseRefundTransaction:(id)sender {
    
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


/*!
 *
 * \param id
 * \returns IBAction
 */

- (IBAction)nakedRefundTransaction:(id)sender {
    
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

/*!
 *
 * \param id
 * \returns IBAction
 */

- (IBAction)getRateReferenceResponse:(id)sender {
    
    // Test credit card info
    NSDictionary* rate_reference = @{
                                  @"rate_type":@"card_rate",
                                  @"bin":@"438980",
                                  @"amount":@"100"
                                 };
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken  url:DCC_URL];
    
    [myClient submitRequestForDCCExchangeRate:rate_reference[@"rate_type"] bin:rate_reference[@"bin"] amount:rate_reference[@"amount"] completion:^(NSDictionary *dict, NSError *error) {
                                                               
                                                               NSString *authStatusMessage = nil;
                                                               
                                                               if (error == nil)
                                                               {
                                                                  
                                                                   /*
                                            {"amount":"591","correlation_id":"56.1439577331149","rate_id":"125875","exchange_rate":"5.9104","dcc_offered":"true","rate_expiry_timestamp":"2016-07-14T14:49:00.000+02:00","margin_percentage":"3.0000","echange_rate_source":"REUTERS WHOLESALE INTERBANK","source_timestamp":"2015-07-30T16:49:00.000+02:00"}
                                                                    */
                                                                   
                                                                   
                                                                   authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\r Rate Id:%@\r Exchange Rate:%@\r Dcc Offered:%@\rrate_expiry_timestamp:%@\r Rate Expiry Timestamp:%@",
                                                                                        [dict objectForKey:@"rate_id"],
                                                                                        [dict objectForKey:@"echange_rate_source"],
                                                                                        [dict objectForKey:@"dcc_offered"],
                                                                                        [dict objectForKey:@"correlation_id"],
                                                                                        [dict objectForKey:@"amount"]];                                                           }
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
