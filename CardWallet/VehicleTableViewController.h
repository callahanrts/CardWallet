//
//  VehicleTableViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 1/18/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddVehicleViewController.h"
#import "DisplayVehicleViewController.h"

@interface VehicleTableViewController : UITableViewController
<AddVehicleViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *vehicleTableView;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSIndexPath *selectedItemIndex;
- (IBAction)infoBtn:(id)sender;



@end
