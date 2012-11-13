//
//  GiftCardTableViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 11/9/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddGiftCardViewController.h"
#import "Store.h"

@interface GiftCardTableViewController : UITableViewController <AddGiftCardViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) Store *currentStore;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@end
