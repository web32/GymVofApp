//
//  MSAppDelegate.m
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 09.12.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import "MSAppDelegate.h"

@implementation MSAppDelegate

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
        
        if (![klasseNeu isEqualToArray: klasseAlt] && klasseAlt != nil) {
            
            
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


#pragma mark RemoteNotification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Device Token=%@", deviceToken);
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"name"]){
        
        NSString* Token = [NSString stringWithFormat:@"%@", deviceToken];
        Token = [Token substringWithRange:NSMakeRange(1, Token.length - 2)];
        Token = [Token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
        NSLog(@"%@", name);
        NSString* URLname = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", URLname);
        NSString* url = [NSString stringWithFormat:@"http://www.4mayerhofers.de/Push/addDeviceToken.php?deviceToken=%@&name=%@", Token, URLname];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Error beim senden des Tokens");
            }
            else{
                NSLog(@"Token wurde gesendt");
            }
        }];
    }
    else{
        UIAlertView *alertViewname = [[UIAlertView alloc] initWithTitle:@"Gib hier bitte deinen Namen ein" message:@"Name eingeben" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertViewname.tag = 2;
        alertViewname.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertViewname show];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	
	NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSLog(@"application didReceiveRemoteNotification");
    
    NSString* alerttype = [userInfo objectForKey:@"alerttype"];
    NSString* alert =  [[userInfo objectForKey:@"aps" ] objectForKey:@"alert"];
    NSString* alerttext = [userInfo objectForKey:@"alerttext"];
    NSString* Cancel = [userInfo objectForKey:@"cancel"];
    NSString* Button1 = [userInfo objectForKey:@"button1"];
    
    NSLog(@"%@", userInfo);
    
    NSLog(@"Type: %@", alerttype);
    NSLog(@"Title: %@", alert);
    NSLog(@"Nachricht: %@", alerttext);
    NSLog(@"Cancel: %@", Cancel);
    NSLog(@"Button1: %@", Button1);
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateActive) {
        
        if ([alerttype isEqualToString:@"1cb"]){
            UIAlertView* alertView1cb = [[UIAlertView alloc] initWithTitle:alert message:alerttext delegate:nil cancelButtonTitle:Cancel otherButtonTitles:nil];
            [alertView1cb show];
        }
        if ([alerttype isEqualToString:@"name"]){
            UIAlertView *alertViewname = [[UIAlertView alloc] initWithTitle:alert message:alerttext delegate:self cancelButtonTitle:Cancel otherButtonTitles:nil] ;
            alertViewname.tag = 2;
            alertViewname.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertViewname show];
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:
     UIApplicationBackgroundFetchIntervalMinimum];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    //Farbe der Navigation-Bar auf rot ändern
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(205.0/255) green:(42.0/255) blue:(42.0/255) alpha:1]];
    
    
    return YES;
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {  //Achtung!! diese Methode wird nur aufgerufen wenn die App nicht läuft, und man gleich nach dem die Notification eingetroffen ist auf dem Springboard Start drückt
        
        NSString* alerttype = [[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"alerttype"];
        NSString* alerttext = [[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"alerttext"];
        NSString* alert = [[[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"] objectForKey:@"alert"];
        NSString* Cancel = [[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"cancel"];
        NSString* Button1 = [[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"button1"];
        
        NSLog(@"Type: %@", alerttype);
        NSLog(@"Title: %@", alerttext);
        NSLog(@"Nachricht: %@", alert);
        NSLog(@"Cancel: %@", Cancel);
        NSLog(@"Button1: %@", Button1);
        
        if ([alerttype isEqualToString:@"1cb"]){
            UIAlertView* alertView1cb = [[UIAlertView alloc] initWithTitle:alert message:alerttext delegate:nil cancelButtonTitle:Cancel otherButtonTitles:nil];
            [alertView1cb show];
        }
        if ([alerttype isEqualToString:@"name"]){
            UIAlertView *alertViewname = [[UIAlertView alloc] initWithTitle:alert message:alerttext delegate:self cancelButtonTitle:Cancel otherButtonTitles:nil] ;
            alertViewname.tag = 2;
            alertViewname.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertViewname show];
        }
    }
    
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
                                                                           UIRemoteNotificationTypeSound)];
	
    return YES;
}

- (void)alertView:(UIAlertView *)alertViewname clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString* name =[alertViewname textFieldAtIndex:0].text;
    
    [[NSUserDefaults standardUserDefaults] setValue: name forKey: @"name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end
