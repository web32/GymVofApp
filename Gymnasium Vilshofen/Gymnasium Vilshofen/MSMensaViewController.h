//
//  MSMensaViewController.h
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 09.12.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocalyticsSession.h"
#import "MSUtility.h"

@interface MSMensaViewController : UIViewController <UIWebViewDelegate>

@property (strong) IBOutlet UIWebView* webView;
@property (strong) IBOutlet UIActivityIndicatorView *loading;

@end
