# Payeezy SDK for iOS
[![CocoaPods](https://img.shields.io/cocoapods/l/Stripe.svg?style=flat)](https://github.com/payeezy/payeezy_ios/raw/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/p/Stripe.svg?style=flat)](https://github.com/nohup-atulparmar/payeezy_ios)

The Payeezy iOS SDK support secure In-App payments via Apple's Apple Pay technology.
* SDK provide support for all major credit cards payment brands, simple transaction like (Purchase,Pre-Authorization (includes $0 Auth),Pre-Authorization Completion,Refund,Void,Tagged Pre-Authorization Completion,Tagged Void, Tagged Refund, Gift Card and tele-check)  transactions
* SDK also provide support association-sponsored Address Verification Services & association-sponsored Card Verification services
* Use Gettoken POST API call to fetch token from Payeezy server and use token for feature transactions ex. authorize/Purchase

* Tokenised Transactions- Token is generated for the card and the transactions are made using the token.US merchants will receive Transarmor multi-use tokens and EU merchants will receive Datavault tokens.
* AVS,CVV, SoftDescriptor and 3DS Card Transactions- This feature is used to make credit card transactions [Non-Tokenised].<US merchants/EU Merchant>

* Dynamic Currency Conversion and Dynamic Pricing- <US merchants/EU Merchant>
There are two types of conversion possible "Merchant Rate" and "Card Rate".
Merchant Rate - Merchant sends the Amount and the Currency Code to which the exchange rate has to be applied
Card Rate - Merchant sends the Amount and the First 6 Digits of the credit card number(BIN). 
Based on BIN the Currency Code is figured out based on which the exchange rate is applied

* TimeOutReversal-  <EU Merchants> Any transaction can be reversed except for VOID.
We will have to send an additional attribute "reversal_id" in the request payload. 

* GermanDirectDebit- This method is applicable only to merchants domiciled in Germany.
For more details on example. click on [example](https://github.com/payeezy/payeezy_ios/tree/master/examples) folder.

For appledocs, click [here] (http://htmlpreview.github.io/?https://github.com/payeezy/payeezy_ios/blob/master/appledocs/index.htm) 
# Minimum System requirements
The iOS mobile SDK requires iOS SDK 6 and XCode 5.1 and above

## iOS SDK Integration
We've written a simple step by step integration [iOS guide](../../tree/master/guide/payeezy_iOS_SDK042015.pdf) that explains everything from installation, to creating payment tokens, to Apple Pay integration and more.

#####To install with [Cocoapods](http://cocoapods.org), add the following to your Podfile:
`pod 'PayeezySDK', :git => 'https://github.com/payeezy/payeezy_ios.git'`

# Getting Started with Payeezy
Using below listed steps, you can easily integrate your mobile/web payment application with Payeezy APIs and go LIVE!
*	LITE  - REGISTRATION  
*	GET CERTIFIED
*	ADD MERCHANTS 
*	LIVE!

![alt tag](https://github.com/payeezy/get_started_with_payeezy/raw/master/payeezy_flow_diagram.png)

For more information on getting started, visit  [get_start_with_payeezy guide] (https://github.com/payeezy/get_started_with_payeezy/blob/master/get_started_with_payeezy042015.pdf) or [download](https://github.com/payeezy/get_started_with_payeezy/raw/master/get_started_with_payeezy042015.pdf)

# Testing - Payeezy {SANDBOX region}
For test credit card,eCheck,GiftCard please refer to [test data ](https://github.com/payeezy/testing_payeezy/blob/master/payeezy_testdata042015.pdf) or [download] (https://github.com/payeezy/testing_payeezy/raw/master/payeezy_testdata042015.pdf)

# Error code/response - Payeezy {SANDBOX/PROD region}
For HTTP status code, API Error codes and error description please refer to [API error code ](https://developer.payeezy.com/payeezy_new_docs/apis) and select your API

#Questions?
We're always happy to help with code or other questions you might have! Check out [FAQ page](https://developer.payeezy.com/faq-page) or call us. 

## Contributing
1. Fork it 
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request  

## Feedback
We appreciate the time you take to try out our sample code and welcome your feedback. Here are a few ways to get in touch:
* For generally applicable issues and feedback, create an issue in this repository.
* support@payeezy.com - for personal support at any phase of integration
* [1.855.799.0790](tel:+18557990790)  - for personal support in real time 

## Terms of Use

Terms and conditions for using Payeezy IOS SDK: Please see [Payeezy Terms & conditions](https://developer.payeezy.com/terms-use)
 
### License
The Payeezy IOS SDK is open source and available under the MIT license. See the LICENSE file for more info.
