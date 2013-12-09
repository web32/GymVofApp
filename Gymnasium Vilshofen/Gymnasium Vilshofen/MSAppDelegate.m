//
//  MSAppDelegate.m
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 09.12.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import <Appsee/Appsee.h>

#import "MSAppDelegate.h"

@implementation MSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Crash-Reporter initialisieren
    [Appsee start:@"0a398b27db6948a4a153c685b9f80811"];
    
    //Farbe der Navigation-Bar auf rot ändern
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(161.0/255) green:(15.0/255) blue:(21.0/255) alpha:1]];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
