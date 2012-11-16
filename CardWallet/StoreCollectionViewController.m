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

-(void)AddGiftCardViewControllerDidSave
{
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
    
    if ([_objectChanges count] > 0 && [_sectionChanges count] == 0)
    {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in _objectChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    [_sectionChanges removeAllObjects];
    [_objectChanges removeAllObjects];
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
    self.collectionView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg1.png"]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
