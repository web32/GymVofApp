//
//  MSNewsViewController.h
//  Gym Vilshofen
//
//  Created by Maximilian Söllner on 26.10.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocalyticsSession.h"
#import "MSTabBarController.h"
#import "MSUtility.h"

@interface MSNewsViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIGestureRecognizerDelegate>

@property IBOutlet UIWebView *webView;
@property IBOutlet UIActivityIndicatorView *loading;
@property IBOutlet UIView *progress;
@property IBOutlet UIButton *backButton;

@property int contentLenght;
@property NSMutableData *responseData;
@property bool authed;


-(IBAction)back:(id)sender;

@end
