//
//  MSKontaktViewController.h
//  Gym Vilshofen
//
//  Created by Maximilian Söllner on 28.10.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocalyticsSession.h"
#import "MSUtility.h"

@interface MSKontaktViewController : UIViewController <UIWebViewDelegate>

@property IBOutlet UIWebView *webView;
@property IBOutlet UIActivityIndicatorView *loading;

@end
