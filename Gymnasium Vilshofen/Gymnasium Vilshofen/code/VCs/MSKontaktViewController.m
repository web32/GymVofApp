//
//  MSKontaktViewController.m
//  Gym Vilshofen
//
//  Created by Maximilian Söllner on 28.10.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//


#import "MSKontaktViewController.h"

@interface MSKontaktViewController ()

@end

@implementation MSKontaktViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.loading startAnimating];
    self.loading.hidden = NO;
    
    [MSUtility loadURL:[NSURL URLWithString:@"http://gymvof.api.maximilian-soellner.de/api/r1/kontakt"] withCompletionHandler:^(NSString *http) {
        self.webView.delegate = self;
        [self.webView loadHTMLString:http baseURL:[NSURL URLWithString:@"http://gymvof.api.maximilian-soellner.de/api/r1/kontakt"]];
        self.loading.hidden = YES;
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [[LocalyticsSession shared] tagScreen:@"Kontakt"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
