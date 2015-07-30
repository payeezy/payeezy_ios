//
//  WebViewController.m
//  Web View Controller


#import "WebViewController.h"
#import "WebViewControllerDelegate.h"

@implementation WebViewController

@synthesize webView;
@synthesize functionDelegate;

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //make a frame fore the webview based on the view's frame
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:webView];
    
    //UIWebViewDelegate will be self
    [webView setDelegate:self];
    // Web Requests that start with the scheme "objc://" will be caught and sent to the WebViewControllerDelegate
    self.functionDelegate = [[WebViewControllerDelegate alloc] init];
    functionDelegate.webViewController = self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.webView = nil;
    self.functionDelegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - StackingWebViewController

/* Loads a URL string into the webview */
- (void)loadPageWithURL:(NSString *)url {
    NSURL *theURL = [NSURL URLWithString:url];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
    [webView loadRequest:theRequest];
}
/* Loads page from file */
- (void)loadPageFromFile:(NSString *)html {
    //First we load up the index.html file
    NSString *path = [[NSBundle mainBundle] pathForResource:[html stringByDeletingPathExtension] ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:path];
    
    // Next we need to set up a proper base URL for our files
    NSString *resourceURL = [[NSBundle mainBundle] resourcePath];
    // The URL in the raw still needs some cleaning
    // Need to be double-slashes to work correctly with UIWebView, so change all "/" to "//"
    resourceURL = [resourceURL stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    // Also need to replace all spaces with "%20"
    resourceURL = [resourceURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //And make a proper URL
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//", resourceURL]];
    
    //Finally let's load up the html data and passthe Base URL for the CSS and Javascript files
    [webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    //This will catch clicked links and location changes made from Javascript, but no other request types
    if (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeOther)
    {
        NSURL *URL = [request URL]; //Get the URL
        //The [URL scheme] is the "http" or "ftp" portion, for example
        //so let's make one up that isn't used at all -> "objc"
        //
        if ( [[URL scheme] isEqualToString:@"objc"] ) {
            //The [URL host] is the next part of the link
            //so we can use that like a selector
            
            NSString *selectorName = [URL host];
            id data = nil;
            
            NSMutableArray *parameters = [NSMutableArray array];
            if ( ![[URL path] isEqualToString:@""] )
            {
                selectorName =  [NSString stringWithFormat:@"%@:", selectorName];
                parameters = [NSMutableArray arrayWithArray: [[URL path] componentsSeparatedByString:@"/"] ];
                [parameters removeObjectAtIndex:0]; //first object is just a slash "/"
                if ( [parameters count] == 1 ){
                    data = [parameters objectAtIndex:0];
                }
                else{
                    data = parameters;
                }
            }
            
            SEL method = NSSelectorFromString( selectorName );
            if ([functionDelegate respondsToSelector:method])
            {
                //This line may give a warning but that's ok, we are being memory concious
                // See: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
                [functionDelegate performSelector:method withObject:data];
            }
            return NO;
        }
        
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //Nothing for now
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //Nothing for now
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //Nothing for now
}

@end
