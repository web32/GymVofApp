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
    //Load the Mensa-webpage
    dispatch_async(dispatch_get_main_queue(), ^() {
        self.loading.hidden = NO;
        NSURL *url = [NSURL URLWithString:@"http://gymvof.api.maximilian-soellner.de/api/r1/mensa"];
        NSString *http = [MSUtility httpStringFromURL:url];
        
        if(!http)
        {
            NSLog(@"Could not load Mensa-data!");
        }
        
        self.webView.delegate = self;
        [self.webView loadHTMLString:http baseURL:[NSURL URLWithString:@"http://gymvof.api.maximilian-soellner.de/api/r1/mensa"]];
        self.loading.hidden = YES;
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
