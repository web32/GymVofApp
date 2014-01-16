//
//  MSEinstellungsViewController.h
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 09.12.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocalyticsSession.h"

@interface MSEinstellungsViewController : UIViewController

@property IBOutlet UISwitch *background;
@property IBOutlet UITextField *klasse;

-(IBAction)backgroundSchalten:(id)sender;

@end
