//
//  AddGiftCardViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 11/9/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftCard.h"
#import "ZBarSDK.h"
#import "Store.h"

@protocol AddGiftCardViewControllerDelegate;

@interface AddGiftCardViewController : UIViewController
<ZBarReaderDelegate, UITextFieldDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) GiftCard *currentGiftCard;
@property (strong, nonatomic) ZBarReaderViewController *reader;
@property (weak, nonatomic) id <AddGiftCardViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *accountNumber;
@property (strong, nonatomic) IBOutlet UITextField *barCode;
@property (strong, nonatomic) IBOutlet UITextField *pinNumber;
@property (strong, nonatomic) IBOutlet UITextField *storeName;
@property (strong, nonatomic) IBOutlet UITextField *balance;
@property (strong, nonatomic) IBOutlet UIPickerView *storePicker;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBtn;
@property BOOL initialLoad;
@property BOOL fromInStore;


- (IBAction)scanAgain:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (void)scan;
- (UITextField*)makeTexfieldWithCGRect:(CGRect)cgrect withPlaceholder:(NSString*)placeholder;
- (void)initZBarReader;
@end

@protocol AddGiftCardViewControllerDelegate
-(void)AddGiftCardViewControllerDidSave:(GiftCard*)giftCardAdded;
-(void)AddGiftCardViewControllerDidCancel:(GiftCard*)giftCardToDelete;

@end
