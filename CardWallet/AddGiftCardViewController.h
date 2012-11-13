//
//  AddGiftCardViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 11/9/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftCard.h"
<<<<<<< HEAD
#import "ZBarSDK.h"
#import "Store.h"

@protocol AddGiftCardViewControllerDelegate;

@interface AddGiftCardViewController : UIViewController <ZBarReaderDelegate>

@property (strong, nonatomic) GiftCard *currentGiftCard;
@property (strong, nonatomic) ZBarReaderViewController *reader;
=======

@protocol AddGiftCardViewControllerDelegate;

@interface AddGiftCardViewController : UIViewController

@property (strong, nonatomic) GiftCard *currentGiftCard;
>>>>>>> 13c914e0fe626ea90480339e679b5e7db076731c
@property (weak, nonatomic) id <AddGiftCardViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *accountNumber;
@property (strong, nonatomic) IBOutlet UITextField *barCode;
@property (strong, nonatomic) IBOutlet UITextField *pinNumber;
<<<<<<< HEAD
@property (strong, nonatomic) IBOutlet UITextField *storeName;
@property BOOL initialLoad;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (void)scan;
=======
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

>>>>>>> 13c914e0fe626ea90480339e679b5e7db076731c
@end

@protocol AddGiftCardViewControllerDelegate
-(void)AddGiftCardViewControllerDidSave;
-(void)AddGiftCardViewControllerDidCancel:(GiftCard*)giftCardToDelete;

@end
