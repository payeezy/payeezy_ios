# Payeezy IOS Examples 

Objective-C classes and implemenation 
*  ViewController.h | app header
*  ViewController.m | app Impl
*  PayeezySDK.h | library header 
*  PayeezySDK.m | library Impl 

Sample app Print screen : 

simpleTransactions 
Credit Card Payments - Sample app demonstate only credit card related tansactions Primary transactions. App display text box to enter amount in dollars and then you can click on CC primary transactions. Please note that these transactions are not token based transations. all the transactions are made based on CC details.
* authorize-Amt0
* authorize-Void
* authorize-Capture
* purchase-Refund
* purchase-Void

creditCardPayments
Authorize Capture transactions - Sample app demonstate only credit card related tansactions Primary transactions. App display text box to enter CC Name/amount/CC exp and then you can click on CC primary transactions. Please note that these transactions are not token based transations. all the transactions are made based on CC details.
* authorize-Amt0
* authorize-Void
* authorize-Capture
* purchase-Refund
* purchase-Void

complexTransactions - Sample app demonstate only credit card related tansactions Scondary transactions. App display text box to enter CC Name/amount/CC exp and then you can click on CC primary transactions. Please note that these transactions are not token based transations. all the transactions are made based on CC details.

*	Credit Card Payments
*	PayPal Transactions
*	Gift Card (via ValueLink) Transactions
*	eCheck (via TeleCheck) Transactions
*	3D Secure Transactions

FDTokenBasedTransactions - Many ways you can generate token ...based on your requirement. 
*	Generate Token with ta_token - auth false - GET/POST API
*	Generate Token with ta_token - auth true - GET/POST API
*	Generate Token without  ta_token & auth -  - GET/POST API with 0$ Auth

## Contributing

1. Fork it 
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request  

## Feedback

Payeezy  SDK is in active development. We appreciate the time you take to try it out and welcome your feedback!
Here are a few ways to get in touch:
* [GitHub Issues](https://github.com/payeezy/payeezy/issues) - For generally applicable issues and feedback
* support@payeezy.com - for personal support at any phase of integration
* [1.855.799.0790](tel:+18557990790)  - for personal support in real time 

## Terms of Use

Terms and conditions for using Payeezy SDK: Please see [Payeezy Terms & conditions](https://developer.payeezy.com/terms-use)
 
### License
The Payeezy SDK is open source and available under the MIT license. See the LICENSE file for more info.
