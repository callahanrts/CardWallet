//
//  AddStoreViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 11/5/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"

@protocol AddStoreViewControllerDelegate;

@interface AddStoreViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameField;

@property (nonatomic, weak) id <AddStoreViewControllerDelegate> delegate;

@property (nonatomic, strong) Store *currentStore;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol AddStoreViewControllerDelegate

-(void)addStoreViewControllerDidSave;
-(void)addStoreViewControllerDidCancel:(Store*)storeToDelete;

@end
