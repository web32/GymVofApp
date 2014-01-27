//
//  MSEinstellungsViewController.h
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 09.12.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocalyticsSession.h"

#import "MSUtility.h"

@interface MSEinstellungsViewController : UIViewController

@property IBOutlet UISwitch *background, *lehrerModus;
@property IBOutlet UITextField *klasse, *lehrer;

-(IBAction)backgroundSchalten:(id)sender;
-(IBAction)lehrerSchalten:(id)sender;

@end
