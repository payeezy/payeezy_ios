//
//  WebViewController.h
//  Web View Controller


#import <UIKit/UIKit.h>

@class WebViewControllerDelegate;
@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WebViewControllerDelegate *functionDelegate;

-(void)loadPageWithURL:(NSString *)url;
-(void)loadPageFromFile:(NSString *)html;



@end
