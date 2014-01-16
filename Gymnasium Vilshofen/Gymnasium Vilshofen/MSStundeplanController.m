//
//  MSStundeplanController.m
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 22.12.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import "MSStundeplanController.h"

@implementation MSStundeplanController


-(void)viewDidLoad
{
    [super viewDidLoad];

    dispatch_async(dispatch_get_main_queue(), ^() {
        self.navigationItem.title = [NSString  stringWithFormat:@"Stundenplan %@", [MSUtility httpStringFromURL:[NSURL URLWithString:@"http://gymvof.api.maximilian-soellner.de/api/r1/tag"]]];
        NSLog(@"%@", self.navigationItem.title);
    });
}

-(void)viewDidAppear:(BOOL)animated
{
    [[LocalyticsSession shared] tagScreen:@"Stundenplan"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger maxStunde = 0;
    
    NSLog(@"%@", [self.data objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"]]);
    
    for (NSArray *row in [self.data objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"]]) {
        NSInteger stunde = [[row objectAtIndex:1] integerValue];
        
        NSLog(@"%li", (long)[[row objectAtIndex:1] integerValue]);
        if (stunde > maxStunde) {
            maxStunde = stunde;
        }
    }
    return maxStunde;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StundenCell";
    
    MSStundenCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.stunde.text = [NSString stringWithFormat:@"%li", (long int) indexPath.row + 1];
    cell.raum.text = @"";
    cell.lehrer.text = @"Keine Änderung";
    
    //Grau bei ungerader Reihe
    if ((indexPath.row % 2) != 0) {
        cell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    }
    
    
    for (NSArray *row in [self.data objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"]]) {
        if ([[row objectAtIndex:1] integerValue] == indexPath.row + 1) {
            
            cell.raum.text = [row objectAtIndex: 3];
            cell.lehrer.text = [row objectAtIndex:2];
            if ([[row objectAtIndex:2] isEqualToString:@""]) {
                cell.lehrer.text = @"Entfällt";
            }
        }
    }

    
    
    

    
    return cell;
    
}

@end
