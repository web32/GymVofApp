//
//  MSMensaViewController.m
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 09.12.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import "MSMensaViewController.h"

@implementation MSMensaViewController

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
    
    
	
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [[LocalyticsSession shared] tagScreen:@"Mensa"];
    
    [self loadMensa];
}

-(void)loadMensa
{
    self.loading.hidden = NO;
    [MSUtility loadURL:[NSURL URLWithString:@"http://gymvof.api.maximilian-soellner.de/api/r1/mensa"] withCompletionHandler:^(NSString *http) {
        self.webView.delegate = self;
        [self.webView loadHTMLString:http baseURL:[NSURL URLWithString:@"http://gymvof.api.maximilian-soellner.de/api/r1/mensa"]];
        self.loading.hidden = YES;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
