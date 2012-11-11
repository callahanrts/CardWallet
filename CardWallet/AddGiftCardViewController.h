//
//  AddGiftCardViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 11/9/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftCard.h"

@protocol AddGiftCardViewControllerDelegate;

@interface AddGiftCardViewController : UIViewController

@property (strong, nonatomic) GiftCard *currentGiftCard;
@property (weak, nonatomic) id <AddGiftCardViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *accountNumber;
@property (strong, nonatomic) IBOutlet UITextField *barCode;
@property (strong, nonatomic) IBOutlet UITextField *pinNumber;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol AddGiftCardViewControllerDelegate
-(void)AddGiftCardViewControllerDidSave;
-(void)AddGiftCardViewControllerDidCancel:(GiftCard*)giftCardToDelete;

@end
