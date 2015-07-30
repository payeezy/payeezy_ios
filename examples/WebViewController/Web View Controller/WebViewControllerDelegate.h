//
//  WebViewControllerDelegate.h
//  Web Template


#import <Foundation/Foundation.h>

/**
* WebViewController is responsible for all
* messages that can be used in HTML
*/

@class WebViewController;
@interface WebViewControllerDelegate : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) WebViewController *webViewController;

/*
* Test alert from Objective-C
 */
-(void)message:(NSString *)name;

/* On successful picture selection, a base64 image
* is sent to the JS function processImage();
*/


@end
