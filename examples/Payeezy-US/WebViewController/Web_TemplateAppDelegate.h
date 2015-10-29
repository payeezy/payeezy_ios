//
//  Web_TemplateAppDelegate.h
//  Web Template
//
//  Created by Kyle Newsome on 11-08-22.
//  Copyright 2011 BitWit.ca. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebViewController;

@interface Web_TemplateAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet WebViewController *viewController;

@end
