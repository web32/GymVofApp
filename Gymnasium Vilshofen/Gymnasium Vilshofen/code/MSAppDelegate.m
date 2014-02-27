//
//  MSAppDelegate.m
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 09.12.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import "MSAppDelegate.h"

@implementation MSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:
                                                                UIApplicationBackgroundFetchIntervalMinimum];

    //Farbe der Navigation-Bar auf rot ändern
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(205.0/255) green:(42.0/255) blue:(42.0/255) alpha:1]];
    
    
    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
    
    //Badgenumber wieder auf 0 setzen
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[LocalyticsSession shared] LocalyticsSession:@"605d4dc4c8805a7a943f576-d056f220-7b20-11e3-1915-004a77f8b47f"];
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
    
    //NSUserDefaults aktualisieren
    long version = 1;
    long hasLaunchedVersion = [[NSUserDefaults standardUserDefaults] integerForKey:@"version"];
    
    if (version > hasLaunchedVersion) {
        if(version == 1) {
            NSString *klasse = [[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"];
            NSString *u = [[NSUserDefaults standardUserDefaults] stringForKey:@"u"];
            NSString *p = [[NSUserDefaults standardUserDefaults] stringForKey:@"p"];
            NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
            [[NSUserDefaults standardUserDefaults] setObject:klasse forKey:@"klasse"];
            [[NSUserDefaults standardUserDefaults] setInteger:version forKey:@"version"];
            [[NSUserDefaults standardUserDefaults] setObject:u forKey:@"u"];
            [[NSUserDefaults standardUserDefaults] setObject:p forKey:@"p"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"Updated NSUserDefault from version 0 to 1");
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];

}

-(void)application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSString *response = [MSUtility httpStringFromURL: [NSURL URLWithString:[NSString stringWithFormat:@"http://gymvof.api.maximilian-soellner.de/api/r1/vplan"]]];
    
    if (response.length == 0) {
        completionHandler(UIBackgroundFetchResultFailed);
        return;
    }
    
    response = [MSUtility cleanString:response];
    
    
    
    NSData *toJson = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    id json = [NSJSONSerialization
               JSONObjectWithData: toJson
               options:0
               error:nil];
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSDictionary *newData = json;
        
        
        NSLog(@"Klasse: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"klasse"]);
        
        NSArray *klasseNeu = [newData objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"klasse"]];
        NSLog(@"Klasse: %@", klasseNeu);
        
        NSArray *klasseAlt = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"vPlan"]
                                objectForKey: [[NSUserDefaults standardUserDefaults] objectForKey:@"klasse"]];
        
        if (![klasseNeu isEqualToArray: klasseAlt] && klasseAlt != nil || true) {
            //Meldung IMMER aktiv!
            
            
            NSString *message = @"Es gibt Änderungen am Vertretungsplan";

            
            [self sendNotificationWithMessage: message];
            
            NSDictionary *dictionary =
            [NSDictionary dictionaryWithObjectsAndKeys:
             [[NSUserDefaults standardUserDefaults] objectForKey:@"klasse"], @"Klasse",
             @"Ja", @"Aktualisiert",
             nil];
            [[LocalyticsSession shared] tagEvent:@"Background Fetch" attributes:dictionary];
            [[LocalyticsSession shared] upload];
        } else {
            NSDictionary *dictionary =
            [NSDictionary dictionaryWithObjectsAndKeys:
             [[NSUserDefaults standardUserDefaults] objectForKey:@"klasse"], @"Klasse",
             @"Nein", @"Aktualisiert",
             nil];
            [[LocalyticsSession shared] tagEvent:@"Background Fetch" attributes:dictionary];
            [[LocalyticsSession shared] upload];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"vPlan"];
    }

    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)sendNotificationWithMessage:(NSString *)message
{
    NSLog(@"Send notification 1");
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"background"]) {
        NSLog(@"Send notification 2");
    
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.alertBody = message;
        localNotif.alertAction = @"Öffnen";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    }
}

@end
