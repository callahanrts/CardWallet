//
//  ShowCardViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 11/12/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftCard.h"
#import "Store.h"

@interface ShowCardViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) GiftCard *currentGiftCard;

@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) IBOutlet UILabel *storeLabel;
@property (strong, nonatomic) IBOutlet UILabel *barCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *pinLabel;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)deleteCard:(id)sender;
- (IBAction)backBtn:(id)sender;

@end
