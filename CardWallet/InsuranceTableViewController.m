//
//  VehicleTableViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 1/18/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import "InsuranceTableViewController.h"
#import "Insurance.h"

@interface InsuranceTableViewController ()

@end

@implementation InsuranceTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - Fetched Results Controller

-(NSFetchedResultsController *)fetchedResultsController{
    if(_fetchedResultsController != nil){
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Insurance" inManagedObjectContext:_managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"company" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"company" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - Add Insurance Delegate Functions

-(void)addInsuranceViewControllerDidCancel:(Insurance *)insuranceToDelete{
    NSManagedObjectContext *context = self.managedObjectContext;
    [context deleteObject:insuranceToDelete];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addInsuranceViewControllerDidSave:(Insurance*)currentInsurance
{
    NSString *url = [NSString stringWithFormat:@"http://codycallahan.com/cwallet.php?page=2&type=insurance&info=%@", currentInsurance.company];
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    
    [[NSURLConnection alloc] initWithRequest:nsrequest delegate:self];
    
    NSError *error = nil;
    if(![self.managedObjectContext save:&error]){
        NSLog(@"Error Saving %@", error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //Execute Fetch
    if(![[self fetchedResultsController] performFetch:&error]){
        NSLog(@"error fetching %@", error);
        abort();
    }
    
    [_insuranceTableView reloadData];
}

#pragma mark - Prepare For Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"addInsurance"]){
        Insurance *insurance = (Insurance*)[NSEntityDescription insertNewObjectForEntityForName:@"Insurance" inManagedObjectContext:_managedObjectContext];
        AddInsuranceViewController *aivc = (AddInsuranceViewController*)segue.destinationViewController;
        aivc.delegate = self;
        aivc.currentInsurance = insurance;
    }
    else if ([[segue identifier]isEqualToString:@"showInsurance"]){
        DisplayInsuranceViewController *divc = (DisplayInsuranceViewController*)[segue destinationViewController];
        Insurance *insurance = [self.fetchedResultsController objectAtIndexPath:_selectedItemIndex];
        divc.currentInsurance = insurance;
    }
}

#pragma mark - Generated Functions

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedItemIndex = indexPath;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*
     Use this line here for keeping the BACKGROUND FIXED
     self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg1.png"]];
     */
    //Set background image
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    self.tableView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    //get managed object context
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = appDelegate.managedObjectContext;
    
    
    //Execute Fetch
    NSError *error = nil;
    if(![[self fetchedResultsController] performFetch:&error]){
        NSLog(@"error fetching %@", error);
        abort();
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> secInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [secInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Insurance *insurance = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.7];
    
    cell.backgroundView = [[UIView alloc]initWithFrame:CGRectZero];
    cell.backgroundView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.7];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", insurance.type, insurance.policyNum];
    
    return cell;
}

//May or may not need this
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[[_fetchedResultsController sections]objectAtIndex:section]name];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         [_managedObjectContext deleteObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
         NSError *error = nil;
         if(![_managedObjectContext save:&error]){
             NSLog(@"Error! %@", error);
         }
         
         //Execute Fetch
         if(![[self fetchedResultsController] performFetch:&error]){
             NSLog(@"error fetching %@", error);
             abort();
         }
         
         [_insuranceTableView reloadData];
     }
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }
 

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)infoBtn:(id)sender {
    NSString *text = @"No longer will you need to dig in the filing cabnet for policy numbers or insurance agent contact information. Press the + button to begin storing your insurance policy numbers right in your phone.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gift Cards"
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}
@end
