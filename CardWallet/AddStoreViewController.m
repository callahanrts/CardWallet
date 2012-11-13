//
//  AddStoreViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 11/5/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "AddStoreViewController.h"

@interface AddStoreViewController ()

@end

@implementation AddStoreViewController
@synthesize  nameField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    nameField.text = self.currentStore.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self.delegate addStoreViewControllerDidCancel:self.currentStore];
}

- (IBAction)save:(id)sender {
    //Store
    self.currentStore.name = nameField.text;
    self.currentStore.image = @"costcoIcon.png";
    
    //Gift Card
    self.currentGiftCard.name = _giftCardName.text;
    self.currentGiftCard.accountNumber = _accountNumber.text;
    self.currentGiftCard.pin = _pinNumber.text;
    self.currentGiftCard.barCode = _barCode.text;
    self.currentGiftCard.store = self.currentStore;
    
    [self.delegate addStoreViewControllerDidSave];
}
@end




/*
//  AddGiftCardViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 11/9/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "AddGiftCardViewController.h"

@interface AddGiftCardViewController ()

@end

@implementation AddGiftCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _accountNumber.text = self.currentGiftCard.accountNumber;
    _barCode.text = self.currentGiftCard.barCode;
    _pinNumber.text = self.currentGiftCard.pin;
    _name.text  = self.currentGiftCard.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self.delegate AddGiftCardViewControllerDidCancel:self.currentGiftCard];
}

- (IBAction)save:(id)sender {
    self.currentGiftCard.name = _name.text;
    self.currentGiftCard.accountNumber = _accountNumber.text;
    self.currentGiftCard.pin = _pinNumber.text;
    self.currentGiftCard.barCode = _barCode.text;
    [self.delegate AddGiftCardViewControllerDidSave];
}
@end
*/
