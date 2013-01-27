//
//  VehicleTableViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 1/18/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddInsuranceViewController.h"
#import "DisplayInsuranceViewController.h"

@interface InsuranceTableViewController : UITableViewController
<AddInsuranceViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *insuranceTableView;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSIndexPath *selectedItemIndex;
- (IBAction)infoBtn:(id)sender;


@end
