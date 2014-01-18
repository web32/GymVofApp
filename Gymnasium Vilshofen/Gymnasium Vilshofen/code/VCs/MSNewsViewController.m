//
//  MSNewsViewController.m
//  Gym Vilshofen
//
//  Created by Maximilian Söllner on 26.10.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import "MSNewsViewController.h"

@interface MSNewsViewController ()

@end

@implementation MSNewsViewController

static NSURLSessionDataTask *task;

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
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    self.webView.delegate = self;
	[self loadNews];
    
}

-(void)back:(id)sender
{
    NSLog(@"Back");
    [self loadNews];
}

-(void)viewDidAppear:(BOOL)animated
{
    [[LocalyticsSession shared] tagScreen:@"Aktuell"];
    [self checkPassword];
    [self loadNews];
}

-(void)swipe:(UIGestureRecognizer*)recognizer
{
    [self loadNews];
}

-(void)loadNews
{
    //Load the news-webpage
    self.loading.hidden = NO;
    [MSUtility loadURL:[NSURL URLWithString:@"http://gymvof.api.maximilian-soellner.de/api/r1/news"] withCompletionHandler:^(NSString *http) {
    
        
        [self.webView loadHTMLString:http baseURL:[NSURL URLWithString:@"http://gymvof.api.maximilian-soellner.de/api/r1/news"]];
        
        self.loading.hidden = YES;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkPassword {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"u"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"p"];
    
    if ([username isEqualToString:@"eltern"] && [password isEqualToString:@"sj+*1314"]) {
    } else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gymvof.api.maximilian-soellner.de/api/r1/password/%@/%@", username, password]];
        
        if ([[MSUtility httpStringFromURL: url] isEqualToString:@"OK"]) {
        }
        else {
            UIAlertView *passwordPrompt = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Logge dich ein um Daten aus dem Eltern-Portal zu laden" delegate:self cancelButtonTitle:@"Zurück" otherButtonTitles:@"OK", nil];
            
            passwordPrompt.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            
            [passwordPrompt show];
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
    
    
        NSString *username = [alertView textFieldAtIndex:0].text;
        NSString *password = [alertView textFieldAtIndex:1].text;
        
        if ([username isEqualToString:@"eltern"] && [password isEqualToString:@"sj+*1314"]) {
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"u"];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"p"];
        

        } else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gymvof.api.maximilian-soellner.de/api/r1/password/%@/%@", username, password]];
        
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"u"];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"p"];
            
            if ([[MSUtility httpStringFromURL: url] isEqualToString:@"OK"]) {

            }
            else {
                UIAlertView *passwordPrompt = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Das Passwort ist falsch! Versuchen sie es nocheinmal" delegate:self     cancelButtonTitle:@"Zurück" otherButtonTitles:@"OK", nil];
            
                passwordPrompt.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            
                [passwordPrompt show];
            }
        }
        
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.host isEqualToString:@"eltern.gym-vilshofen.de"]) {
        
        
        webView.scalesPageToFit = YES;
        
        
        self.backButton.hidden = NO;
        
    } else {
        webView.scalesPageToFit = NO;
        self.backButton.hidden = YES;


    }
    
    task = [[MSUtility sharedSession] dataTaskWithRequest:request];
    [task resume];

    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    self.loading.hidden = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loading.hidden = YES;
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Loading error: %@", error);
    self.loading.hidden = YES;
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //self.progress.hidden = YES;
}


@end
