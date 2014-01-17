//
//  MSPush.m
//  Gymnasium Vilshofen
//
//  Created by Michael Mayerhofer on 17.01.14.
//  Copyright (c) 2014 Maximilian Söllner. All rights reserved.
//

#import "MSPush.h"

@implementation MSPush

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badge"] intValue];
    NSString* alert = [[userInfo objectForKey:@"aps"] objectForKey: @"alert"];
    NSString* alerttitle = [[userInfo objectForKey:@"aps"] objectForKey: @"alerttitle"];
    NSString* code = [[userInfo objectForKey:@"aps"] objectForKey: @"code"];
    
    if ([code isEqual: @"testcode"]){
        //stuff
    }
    
    NSLog(@"remote notification: %@",[userInfo description]);
    NSLog(@"Nachricht: %@", alert);
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:alerttitle message:alert delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSLog(@"Device Token=%@", deviceToken);
    
    NSString* token = [NSString stringWithFormat:@"%@", deviceToken];
    
    token= [token substringWithRange:NSMakeRange(1, token.length - 2)];
    
    token = [token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* url = [NSString stringWithFormat:@"http://michaelmayer.cwsurf.de/MYSQL/addDeviceToken.php?deviceToken=%@", token];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        }
    }];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Error bei der Registrierung");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSString* alert = [[[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"] objectForKey:@"alert"];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Aktuell" message:alert delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        NSLog(@"Es ist ein Nachricht angekommen als du nicht da warst!!");
    }
    // Override point for customization after application launch.
    return YES;
}

@end
