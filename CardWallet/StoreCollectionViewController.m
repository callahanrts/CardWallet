//
//  StoreCollectionViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 11/4/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "StoreCollectionViewController.h"

@interface StoreCollectionViewController()

@end

@implementation StoreCollectionViewController{
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

@synthesize theAppDelegate;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize selectedStoreIndex;


#pragma mark - Fetch and Store
-(void)AddGiftCardViewControllerDidCancel:(GiftCard *)giftCardToDelete{
    NSManagedObjectContext *context = self.managedObjectContext;
    [context deleteObject:giftCardToDelete.store];
    [context deleteObject:giftCardToDelete];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)AddGiftCardViewControllerDidSave:(GiftCard*)giftCardAdded
{
    NSString *url = [NSString stringWithFormat:@"http://codycallahan.com/cwallet.php?page=2&type=store&info=%@", giftCardAdded.store.name];
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    
    [[NSURLConnection alloc] initWithRequest:nsrequest delegate:self];
    
    NSString *url2 = [NSString stringWithFormat:@"http://codycallahan.com/cwallet.php?page=2&type=card&info=%@", giftCardAdded.name];
    NSURL *nsurl2=[NSURL URLWithString:url2];
    NSURLRequest *nsrequest2=[NSURLRequest requestWithURL:nsurl2];
    
    [[NSURLConnection alloc] initWithRequest:nsrequest2 delegate:self];
    
    
    NSError *error = nil;
    if(![self.managedObjectContext save:&error]){
        NSLog(@"Error Saving %@", error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.collectionView reloadData];
}

-(NSFetchedResultsController *)fetchedResultsController{
    if(_fetchedResultsController != nil){
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Store"
    inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
    ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}



#pragma mark - Fetched Results Delegate
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    
}


#pragma mark - Get and deal with changed content
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_objectChanges addObject:change];
}


-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @[@(sectionIndex)];
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @[@(sectionIndex)];
            break;
    }
    
    [_sectionChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([_sectionChanges count] > 0)
    {
        [self.collectionView performBatchUpdates:^{
            for (NSDictionary *change in _sectionChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    [self.collectionView reloadData];
    [_sectionChanges removeAllObjects];
}

#pragma mark - Colection view customization functions

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [secInfo numberOfObjects];
}


-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iconCell" forIndexPath:indexPath];
    Store *store = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //_foldImage.image = [UIImage imageNamed:@"fold1.png"];
    int rand = (arc4random() % 1000) + 1;
    if(rand % 2 == 0){
        cell.foldImage.image = [UIImage imageNamed:@"fold1.png"];
    } else {
        cell.foldImage.image = [UIImage imageNamed:@"fold2.png"];
    }
    cell.iconImage.image = [UIImage imageNamed:store.image];
    cell.storeLabel.text = store.name;
    return cell;
}

#pragma mark - Generated Functions

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedStoreIndex = indexPath;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"addCardAndStore"]){
        Store *store = (Store*)[NSEntityDescription insertNewObjectForEntityForName:@"Store" inManagedObjectContext:self.managedObjectContext];
        AddGiftCardViewController *agcvc = (AddGiftCardViewController*) segue.destinationViewController;
        agcvc.delegate = self;
        
        GiftCard *newGiftCard = (GiftCard*)[NSEntityDescription insertNewObjectForEntityForName:@"GiftCard" inManagedObjectContext:self.managedObjectContext];
        newGiftCard.store = store;
        agcvc.managedObjectContext = self.managedObjectContext;
        agcvc.currentGiftCard = newGiftCard;
        agcvc.initialLoad = NO;
        agcvc.fromInStore = NO;
    }
    else if([[segue identifier] isEqualToString:@"toCards"]){
        GiftCardCollectionViewController *gccvc = (GiftCardCollectionViewController*)[segue destinationViewController];
        Store *store = [self.fetchedResultsController objectAtIndexPath:selectedStoreIndex];
        gccvc.currentStore = store;
        gccvc.managedObjectContext = (NSManagedObjectContext*)self.managedObjectContext;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //get managed object context
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = appDelegate.managedObjectContext;
    
    //first launch
    BOOL foo = [[NSUserDefaults standardUserDefaults]boolForKey:@"previouslyLaunched"];
    if (!foo)
    {
        NSLog(@"FirstLaunch");
        [self showHelp];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"previouslyLaunched"];
    }
    
    self.collectionView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    //top left bottom right
    [self.collectionView setContentInset:UIEdgeInsetsMake(10, 0, 10, 0)];
    
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
    
    NSError *error = nil;
    if(![[self fetchedResultsController] performFetch:&error]){
        NSLog(@"error fetching %@", error);
        abort();
    }
}

-(void)showHelp{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey there, Awesome!" message:@"Welcome to Card Wallet. \n Use Card Wallet to store your gift cards for mobile use. Scan gift cards in using bar codes or enter the information manually. Use gift cards at stores that scan bar codes or simply keep information in app for online purchases. \n \n Let Card Wallet lighten your wallet so you can save room for cash!" delegate:self cancelButtonTitle:@"Begin!" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)infoBtn:(id)sender {
    NSString *text = @"Add gift cards to C Wallet to store and use gift cards right from your iOS Device. Click the + button to begin.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gift Cards"
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}
@end
