//
//  MSEinstellungsViewController.m
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 09.12.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import "MSEinstellungsViewController.h"

@implementation MSEinstellungsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"background"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"bInited"]) {
        self.background.on = NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"background"];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"bInited"];
    
    self.klasse.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"];
    
    //Lehrer-Modus
    self.lehrer.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"lehrer"];
    self.lehrerModus.on = [MSUtility teacherMode];
}

-(void)viewDidAppear:(BOOL)animated
{
    [[LocalyticsSession shared] tagScreen:@"Einstellungen"];
    
        
    
}



-(void)viewDidDisappear:(BOOL)animated
{
    NSString *vPlan;
    if (self.background.on) {
        vPlan = @"An";
    } else {
        vPlan = @"Aus";
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys: vPlan, @"Vertretungsplan Benachrichtigung",
                                                                            self.klasse.text.uppercaseString, @"Klasse",
                                                                            self.lehrer.text, @"Lehrer",
                                                                            nil];
    [[LocalyticsSession shared] tagEvent:@"Einstellungen gespeichert" attributes:dictionary];
    
    //Beim deaktivieren des Views wird die Klasse in die Einstellungen geschrieben
    NSLog(@"Klasse gespeichert: %@", self.klasse.text.uppercaseString);
    [[NSUserDefaults standardUserDefaults] setObject:self.klasse.text.uppercaseString forKey:@"klasse"];
    [[NSUserDefaults standardUserDefaults] setObject:self.lehrer.text forKey:@"lehrer"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(IBAction)backgroundSchalten:(id)sender
{
    if (self.background.on) {
        NSLog(@"Switched background update ON");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"background"];
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval: UIApplicationBackgroundFetchIntervalMinimum];
    }
    else {
        NSLog(@"Switched background update OFF");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"background"];
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval: UIApplicationBackgroundFetchIntervalNever];
    }
    
}

-(IBAction)lehrerSchalten:(id)sender
{
    if (self.lehrerModus.on) {
        [MSUtility setTeacherMode:YES];
        
    } else {
        [MSUtility setTeacherMode:NO];
    }
}

@end
