//
//  StoreCollectionViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 11/4/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddGiftCardViewController.h"
#import "StoreCell.h"
#import "Store.h"

@interface StoreCollectionViewController : UICollectionViewController
<AddGiftCardViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) AppDelegate *theAppDelegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSIndexPath *selectedStoreIndex;

@end
