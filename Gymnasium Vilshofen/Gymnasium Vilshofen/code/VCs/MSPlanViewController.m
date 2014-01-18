//
//  MSPlanViewController.m
//  Gym Vilshofen
//
//  Created by Maximilian Söllner on 25.10.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import "MSPlanViewController.h"

@interface MSPlanViewController ()

@end

@implementation MSPlanViewController

static MSNewsCell *newsCell;
static NSString *loginU = @"eltern";
static NSString *loginP = @"sj+*1314";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    self.data = [NSDictionary dictionary];
    self.day = @"";
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.tabBarController.tabBar.frame.size.height)];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
    
    dispatch_async(dispatch_get_main_queue(), ^() {
        self.day = [MSUtility httpStringFromURL:[NSURL URLWithString:@"http://gymvof.api.maximilian-soellner.de/api/r1/tag"]];
    });
        
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
}


-(void)viewDidAppear:(BOOL)animated
{
    [[LocalyticsSession shared] tagScreen:@"Vertretungsplan"];
    self.loggedIn = NO;
    self.cached = NO;
    [self reload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self loadView];
}

-(void)reload
{
    dispatch_async(dispatch_get_main_queue(), ^() {
        [self.refreshControl beginRefreshing];
        [self logInWithUsername:nil andPassword:nil];
        //Falls "alte" Daten gespeichert sind werden diese vorrübergehend angezeigt
        NSDictionary *cachedData = [self cachedData];
        if (cachedData) {
            NSLog(@"Lade Cache-Daten");
            self.data = cachedData;
            self.cached = YES;
            self.loaded = YES;
            [self.tableView reloadData];
        }
        [self loadData];
        [self loadInfoData];
        [self.tableView reloadData];
        [self performSelector:@selector(endRefreshing) withObject:self.refreshControl afterDelay:1];
    });
}

-(void)endRefreshing
{
    [self.refreshControl endRefreshing];
}

-(void)logInWithUsername:(NSString *)username andPassword:(NSString *)password
{
    if (!username && !password) {
        username = [[NSUserDefaults standardUserDefaults] stringForKey:@"u"];
        password = [[NSUserDefaults standardUserDefaults] stringForKey:@"p"];
    }
    
    //Überprüfung mit hinterlegtem Passwort
    if ([username isEqualToString:loginU] && [password isEqualToString:loginP]) {
        self.loggedIn = YES;
        return;
    }
    
    //Überprüfung am Webserver
    if (username && password) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gymvof.api.maximilian-soellner.de/api/r1/password/%@/%@", username, password]];
        NSString *response = [MSUtility httpStringFromURL: url];
        
        if ([response isEqualToString:@"OK"]) {
            self.loggedIn = YES;
            return;
        }
    }
    
    //Beide Überprüfungen sind Fehlgeschlagen (Entweder falsch oder null)
    UIAlertView *passwordPrompt = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Logge dich ein um Daten aus dem Eltern-Portal zu laden" delegate:self cancelButtonTitle:@"Zurück" otherButtonTitles:@"OK", nil];
    
    passwordPrompt.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [passwordPrompt show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *username = [alertView textFieldAtIndex:0].text;
        NSString *password = [alertView textFieldAtIndex:1].text;
        
        [self logInWithUsername:username andPassword:password];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)loadData
{
    NSString *response = [MSUtility httpStringFromURL: [NSURL URLWithString:[NSString stringWithFormat:@"http://gymvof.api.maximilian-soellner.de/api/r1/vplan"]]];
    
    response = [MSUtility cleanString:response];
    
    [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://gymvof.api.maximilian-soellner.de/api/r1/vplan"]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        id json = [NSJSONSerialization
                   JSONObjectWithData: data
                   options:0
                   error:nil];
        
        NSLog(@"JSON: %@", json);
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            self.data = json;
            self.cached = NO;
            self.loaded = YES;
            [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"vPlan"];
        } else {
            //Kein oder falsche json-Datei bleibe bei Cache-Dateien
            NSLog(@"Fehler beim vPlan-Donwload! Cache-Dateien: %s", self.cached ? "YES" : "NO");
            self.loaded = YES;
        }
        
        if (data.length == 0) {
            self.iNet = NO;
        }
        else {
            self.iNet = YES;
        }
    }];
}

-(void)loadInfoData
{
    [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://gymvof.api.maximilian-soellner.de/api/r1/vplan"]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
    }];
    self.infoData = [MSUtility cleanString:
                            [MSUtility httpStringFromURL:[NSURL URLWithString:@"http://gymvof.api.maximilian-soellner.de/api/r1/vplaninfo"]]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(NSDictionary *)cachedData {
    NSDictionary *cache = [[NSUserDefaults standardUserDefaults] objectForKey:@"vPlan"];
    
    return cache;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
           return [NSString  stringWithFormat:@" Vertretungsplan %@", self.day];
            break;
        default:
            return nil;
            break;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return [[self.data objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"]] count];
    }
    else if (section == 1) {
        if (([[self.data objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"]] count] == 0 && self.loaded) || self.cached) {
            return 1;
        }
        return 0;
    }
    else if (section == 2) {
        if([[self.data objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"]] count] > 0 && self.loaded) {
            return 1;
        }
        return 0;
    } else if (section == 3) {
        //Allgemeine Information
        if (self.infoData.length > 0) {
            return 1;
        }
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"PlanCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        MSPlanCell *plan = (MSPlanCell *) cell;
        
        NSArray *row = [[self.data objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"]] objectAtIndex:indexPath.row];
        
        //Grau bei ungerader Reihe
        if ((indexPath.row % 2) != 0) {
            plan.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        }
        
        plan.von.text = [row objectAtIndex:0];
        plan.stunde.text = [row objectAtIndex:1];
        plan.zu.text = [NSString stringWithFormat:@"-> %@", [row objectAtIndex:2]];
        plan.raum.text = [row objectAtIndex:3];
        plan.info.text = [row objectAtIndex:4];
        
        return cell;
    }
    else if(indexPath.section == 1) {
        static NSString *CellIdentifier = @"LeerCell";
        MSInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (self.iNet) {
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"] isEqualToString:@""]
                || [[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"] == NULL) {
                cell.info.text = @"Bitte wähle eine Klasse in den Einstellungen";
            } else {
                cell.info.text = @"Heute normaler Unterricht nach Stundenplan";
            }
        }
        else {
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"] isEqualToString:@""]
                || [[NSUserDefaults standardUserDefaults] stringForKey:@"klasse"] == NULL) {
                cell.info.text = @"Bitte wähle eine Klasse in den Einstellungen";
            } else {
                if (!self.cached) {
                    cell.info.text = @"Keine Internetverbindung";
                } else {
                    cell.info.text = @"Keine Internetverbindung -> Offline-Modus";
                }
            }
        }
        
        return cell;
    }
    else if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"LinkCell";
        MSLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        return cell;
        
        
    } else if (indexPath.section == 3) {
        static NSString *CellIdentifier = @"NewsCell";
        MSNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        [cell setCellText: self.infoData];
        
        //Custom row height
        if (!newsCell) {
            newsCell = cell;
            //Line Seperators
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            newsCell = cell;
        }
    
        return cell;
    } else {
        NSLog(@"Returned nil cell!");
        return nil;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        if (newsCell) {
             CGSize expected = [newsCell.textLabel sizeThatFits:CGSizeMake(newsCell.textLabel.bounds.size.width, CGFLOAT_MAX)];
            
            NSLog(@"Row: %f", expected.height);
            
             return expected.height + 20;
        }
    }
    
    return 44;
}






-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"stundenplan"]) {
        MSStundeplanController *vc = segue.destinationViewController;
        vc.data = self.data;
    }
    
}

/*
// Override to support conditional editing of the table view
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
