//
//  WebViewControllerDelegate.m
//  Web Template


#import "WebViewControllerDelegate.h"
#import "NSData+Base64.h"
#import "WebViewController.h"

@implementation WebViewControllerDelegate

@synthesize webViewController;

-(void)message:(NSString *)name
{
    //Showing a basic pop up alert
    
    NSString *message = [NSString stringWithFormat:
                         @"Your name is %@", name ];
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Message From OBJ-C" 
                          message:message 
                          delegate:nil 
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles:nil, nil];
    
    [alert show];
}


@end
