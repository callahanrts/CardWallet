//
//  StoreCollectionViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 11/4/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
<<<<<<< HEAD
#import "AddGiftCardViewController.h"
#import "StoreCell.h"
#import "Store.h"

@interface StoreCollectionViewController : UICollectionViewController
<AddGiftCardViewControllerDelegate, NSFetchedResultsControllerDelegate>
=======
#import "AddStoreViewController.h"

@interface StoreCollectionViewController : UICollectionViewController
<AddStoreViewControllerDelegate, NSFetchedResultsControllerDelegate>
>>>>>>> 13c914e0fe626ea90480339e679b5e7db076731c

@property (nonatomic, retain) AppDelegate *theAppDelegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSIndexPath *selectedStoreIndex;
@end
