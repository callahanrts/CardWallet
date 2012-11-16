//
//  GiftCardCollectionViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 11/15/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddGiftCardViewController.h"
#import "GiftCardCell.h"
#import "Store.h"

@interface GiftCardCollectionViewController : UICollectionViewController
<AddGiftCardViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) AppDelegate *theAppDelegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) Store *currentStore;
@end
