//
//  StoreCollectionViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 11/4/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "StoreCollectionViewController.h"
#import "StoreCell.h"
#import "Store.h"

@interface StoreCollectionViewController ()

@end

@implementation StoreCollectionViewController{
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

@synthesize theAppDelegate;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;



#pragma mark - Fetch and Store
-(void)addStoreViewControllerDidCancel:(Store *)storeToDelete{
    NSManagedObjectContext *context = self.managedObjectContext;
    [context deleteObject:storeToDelete];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addStoreViewControllerDidSave{
    NSError *error;
    NSManagedObjectContext *context = self.managedObjectContext;
    if(![context save:&error]){
        NSLog(@"Error Saving! %@", error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
    NSLog(@"Number of Sections: %@", [NSString stringWithFormat:@"%i", [[self.fetchedResultsController sections] count]]);
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSLog(@"Number of Items in Section: %@", [NSString stringWithFormat:@"%i", [secInfo numberOfObjects]]);
    return [secInfo numberOfObjects];
}


-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iconCell" forIndexPath:indexPath];
    Store *store = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.iconImage.image = [UIImage imageNamed:store.image];
    cell.storeLabel.text = store.name;
    return cell;
}

#pragma mark - Generated Functions

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
    if([[segue identifier] isEqualToString:@"addStore"]){
        AddStoreViewController *asvc = (AddStoreViewController*)[segue destinationViewController];
        asvc.delegate = self;
        Store *store = (Store*)[NSEntityDescription insertNewObjectForEntityForName:@"Store" inManagedObjectContext:self.managedObjectContext];
        asvc.currentStore = store;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
