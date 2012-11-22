//
//  GiftCardCollectionViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 11/15/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "GiftCardCollectionViewController.h"

@interface GiftCardCollectionViewController ()

@end

@implementation GiftCardCollectionViewController{
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

#pragma mark - Fetch and Store

-(void)AddGiftCardViewControllerDidCancel:(GiftCard *)giftCardToDelete{
    NSManagedObjectContext *context = self.managedObjectContext;
    [context deleteObject:giftCardToDelete];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)AddGiftCardViewControllerDidSave:(GiftCard*)giftCardAdded
{
    @autoreleasepool {
        NSError *error = nil;
        if(![self.managedObjectContext save:&error]){
            NSLog(@"Error Saving %@", error);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.collectionView reloadData];
    }
}


-(NSFetchedResultsController *)fetchedResultsController{
    if(_fetchedResultsController != nil){
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GiftCard" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //Search predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(store == %@)", _currentStore];
    [fetchRequest setPredicate:predicate];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
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
    GiftCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iconCell" forIndexPath:indexPath];
    GiftCard *giftCard = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    int rand = (arc4random() % 1000) + 1;
    if(rand % 2 == 0){
        cell.foldImage.image = [UIImage imageNamed:@"fold1.png"];
    } else {
        cell.foldImage.image = [UIImage imageNamed:@"fold2.png"];
    }
    cell.giftCardImage.image = [UIImage imageNamed:giftCard.store.image];
    cell.giftCardLabel.text = giftCard.name;
    return cell;
}


#pragma mark - Generated Functions
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    //top left bottom right
    [self.collectionView setContentInset:UIEdgeInsetsMake(10, 0, 10, 0)];
    NSError *error = nil;
    //Change title of navigation bar
    self.navigationController.topViewController.title = _currentStore.name;
    //fetch data
    if(![self.fetchedResultsController performFetch:&error]){
        NSLog(@"Error fetching data, %@", error);
        abort();
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"addCardWithoutStore"])
    {
        AddGiftCardViewController *agcvc = (AddGiftCardViewController*) segue.destinationViewController;
        agcvc.delegate = self;
        
        GiftCard *newGiftCard = (GiftCard*)[NSEntityDescription insertNewObjectForEntityForName:@"GiftCard" inManagedObjectContext:self.managedObjectContext];
        newGiftCard.store = _currentStore;
        agcvc.managedObjectContext = self.managedObjectContext;
        agcvc.currentGiftCard = newGiftCard;
        agcvc.initialLoad = YES;
        agcvc.fromInStore = YES;
    }
    if([segue.identifier isEqualToString:@"viewCard"])
    {
        ShowCardViewController *scvc = (ShowCardViewController*)[segue destinationViewController];
        GiftCard *giftCard = [self.fetchedResultsController objectAtIndexPath:_selectedCardIndex];
        scvc.currentGiftCard = giftCard;
        scvc.managedObjectContext = self.managedObjectContext;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.collectionView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    if([self numberOfGiftCardsInStore:_currentStore] < 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    _selectedCardIndex = indexPath;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Functions

-(NSInteger)numberOfGiftCardsInStore:(Store*)store{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GiftCard" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    //Search predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(store == %@)", store];
    [fetchRequest setPredicate:predicate];
    return [[_managedObjectContext executeFetchRequest:fetchRequest error:&error] count];
}
@end
