//
//  MSPlanViewController.h
//  Gym Vilshofen
//
//  Created by Maximilian Söllner on 25.10.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSUtility.h"
#import "MSStundeplanController.h"
#import "LocalyticsSession.h"

#import "MSPlanCell.h"
#import "MSInfoCell.h"
#import "MSLinkCell.h"
#import "MSNewsCell.h"

@interface MSPlanViewController : UITableViewController <UIAlertViewDelegate>

@property UIRefreshControl *control;

@property bool iNet, loaded, loggedIn, cached;

@property NSDictionary *data;
@property NSString *infoData;
@property NSString *day;

@end
