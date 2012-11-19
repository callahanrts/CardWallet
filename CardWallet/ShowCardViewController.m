//
//  ShowCardViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 11/12/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "ShowCardViewController.h"

@interface ShowCardViewController ()

@end

@implementation ShowCardViewController
#pragma mark - Custom Functions

- (void)removeStoreIfNoCards:(NSString*)storeToTestForDeletion
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GiftCard" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"store.name == %@", storeToTestForDeletion];
    [fetchRequest setPredicate:predicate];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    int numOfCards = [fetchedObjects count];
    
    if(numOfCards == 0){
        entity = [NSEntityDescription entityForName:@"Store" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        predicate = [NSPredicate predicateWithFormat:@"name == %@", storeToTestForDeletion];
        [fetchRequest setPredicate:predicate];
        fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        [self.managedObjectContext deleteObject:[fetchedObjects objectAtIndex:0]];
    }
}

- (BarcodeType) getType{
    BarcodeType type;
    switch([_currentGiftCard.zbarCodeType intValue])
    {
        
        case 8:
            type = EAN8;
            break;
        case 13:
            type = EAN13;
            break;
        case 9:
            type = UPCE;
            break;
        case 12:
            type = UPCA;
            break;
        case 39:
            type = Code39;
            break;
        case 128:
            type = Code128;
            break;
        case 93:
        case 25:
        case 14:
        case 10:
        case 2:
        case 5:
        default:
            NSLog(@"Unsupported Type");
    }
    return type;
}

#pragma mark - Buttons
- (IBAction)deleteCard:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remove Gift Card?" message:@"Do you really want to delete this gift card?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
}

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Generated Functions
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
    //Change title of navigation bar
    _navigationBar.topItem.title = _currentGiftCard.name;
    
    //labels
    _storeLabel.text = _currentGiftCard.store.name;
    _accountNumberLabel.text = _currentGiftCard.accountNumber;
    _pinLabel.text = _currentGiftCard.pin;
    //barcode image
    _barCodeImage.image = [BarcodeManager generateBarcodeImageWithContent: _currentGiftCard.accountNumber
                                                                     type: [self getType]
                                                                     size: CGSizeMake(0,0)];
    
    NSLog(@"EAN2: %d", ZBAR_EAN2);
    NSLog(@"EAN5: %d", ZBAR_EAN5);
    NSLog(@"EAN8: %d", ZBAR_EAN8);
    NSLog(@"EAN13: %d", ZBAR_EAN13);
    NSLog(@"UPCE: %d", ZBAR_UPCE);
    NSLog(@"UPCA: %d", ZBAR_UPCA);
    NSLog(@"ISBN10: %d", ZBAR_ISBN10);
    NSLog(@"ISBN13: %d", ZBAR_ISBN13);
    NSLog(@"I25: %d", ZBAR_I25);
    NSLog(@"Code39: %d", ZBAR_CODE39);
    NSLog(@"Code128: %d", ZBAR_CODE128);
    NSLog(@"Code93: %d", ZBAR_CODE93);
    NSLog(@"QR: %d", ZBAR_QRCODE);
    NSLog(@"ZBARCODE: %d", [_currentGiftCard.zbarCodeType intValue]);
    
    //background
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg3.png"]];
    
    //set background to gift card
    _cardImage.image = [UIImage imageNamed:@"card.png"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {     // and they clicked OK.
        GiftCard *cardToDelete = _currentGiftCard;
        NSError *error = nil;
        
        NSString *storeToTestForDeletion = cardToDelete.store.name;
        
        [self.managedObjectContext deleteObject:cardToDelete];
        [self removeStoreIfNoCards:storeToTestForDeletion];
        
        if(![self.managedObjectContext save:&error]){
            NSLog(@"Error saving deleted object, %@", error);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
