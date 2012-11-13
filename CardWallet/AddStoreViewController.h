//
//  AddStoreViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 11/5/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
#import "GiftCard.h"

@protocol AddStoreViewControllerDelegate;

@interface AddStoreViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *giftCardName;
@property (strong, nonatomic) IBOutlet UITextField *accountNumber;
@property (strong, nonatomic) IBOutlet UITextField *barCode;
@property (strong, nonatomic) IBOutlet UITextField *pinNumber;


@property (nonatomic, weak) id <AddStoreViewControllerDelegate> delegate;

@property (nonatomic, strong) Store *currentStore;
@property (nonatomic, strong) GiftCard *currentGiftCard;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol AddStoreViewControllerDelegate

-(void)addStoreViewControllerDidSave;
-(void)addStoreViewControllerDidCancel:(Store*)storeToDelete;

@end
