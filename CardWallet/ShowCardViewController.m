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

@implementation ShowCardViewController{
    BOOL keyboardVisible;
    int negative;
    CGRect originalFrame;
}
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
            type = EAN13;
            break;
        case 12:
            type = EAN13;
            break;
        case 39:
            type = Code39;
            break;
        case 128:
            type = Code128;
            break;
        case 93://code 93
        case 25://i2/5
        case 14:
        case 10:
        case 2://ean2
        case 5://ean5
        default:
            NSLog(@"Unsupported Type");
            type = -1;
    }
    return type;
}

-(NSInteger)numberOfGiftCardsInStore:(Store*)store{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GiftCard" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    //Search predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(store == %@)", store];
    [fetchRequest setPredicate:predicate];
    return [[_managedObjectContext executeFetchRequest:fetchRequest error:&error] count];
}


-(NSString*)getAccountString:(NSString*)stringToConvertFrom{
    NSMutableString *string = [[NSMutableString alloc] init];
    if([_currentGiftCard.store.name isEqualToString:@"Kohls"] && [stringToConvertFrom length] == 30){
        NSMutableString *acc = [[NSMutableString alloc]init], *upc = [[NSMutableString alloc]init];
        [upc insertString:[stringToConvertFrom substringToIndex:11] atIndex:0];
        [acc insertString:[stringToConvertFrom substringFromIndex:11] atIndex:0];
        upc = [self addSpaces:upc];
        acc = [self addSpaces:acc];
        [string appendString:@"UPC: "];
        [string appendString:upc];
        [string appendString:@"\nACC: "];
        [string appendString:acc];
    }
    else{
        [string insertString:stringToConvertFrom atIndex:0];
        string = [self addSpaces: string];
    }
    return (NSString*)string;
}
-(NSMutableString*)addSpaces:(NSMutableString*)string{
    for(int i = 0; i < [string length]; i++){
        if(i % 5 == 0)
            [string insertString:@" " atIndex:i];
    }
    return string;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up animated:(BOOL)animated
{
    const int movementDistance = 140 * negative; //negative for upside down orientation (1 / -1)
    const float movementDuration = animated ? 0.3f : 0.0; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, movement, 0);
    [UIView commitAnimations];
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
    //set original view frame
    originalFrame = self.view.frame;
    
	// Do any additional setup after loading the view.
    //Change title of navigation bar
    _navigationBar.topItem.title = _currentGiftCard.name;
    
    //set background to gift card
    _cardImage.image = [UIImage imageNamed:@"card.png"];
    
    //background
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg3Horiz.png"]];
    
    self.navigationBar.frame = CGRectMake(0, 0, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
    
    //orientation change
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];

    //labels
    NSString *acctNumber = @"Acct: ";
    NSString *number = _currentGiftCard.accountNumber ? [self getAccountString:_currentGiftCard.accountNumber]:@"";
    _storeLabel.text = _currentGiftCard.store.name;
    _accountNumberLabel.numberOfLines = 0;
    _accountNumberLabel.text = [acctNumber stringByAppendingString:number];
    _pinLabel.text = _currentGiftCard.pin;
    _balanceField.delegate = self;
    _balanceField.text = _currentGiftCard.balance;
    negative = 1;
    if(!_currentGiftCard.pin)
        _pinTitle.text = @"";
    //barcode image
    UIImage *bc = [BarcodeManager
                           generateBarcodeImageWithContent: _currentGiftCard.accountNumber
                                                      type: [self getType]
                                                      size: CGSizeMake(0, 0)];
    
    
    //set barcode image to imageview
    UIImageView *bcImage = [[UIImageView alloc] initWithFrame:CGRectMake((480 / 2) - (bc.size.width / 2),
                                                                         (320 / 2) - (2 * bc.size.height / 3),
                                                                          bc.size.width, bc.size.height)];
    
    if([self getType] != -1){
        [self.view addSubview:bcImage];
        bcImage.image = bc;
    }
    if(bcImage.frame.size.width > 390){
        bc = [BarcodeManager generateBarcodeImageWithContent: _currentGiftCard.accountNumber type:[self getType] size:CGSizeMake(390, 0)];
        bcImage.frame = CGRectMake((480 / 2) - (390 / 2), (320 / 2) - (2 * bcImage.frame.size.height / 3), 390, bcImage.frame.size.height);
        bcImage.image = bc;
    }
}


-(void)deviceOrientationDidChange: (NSNotification *)notification {
    //Obtaining the current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    //Ignoring specific orientations
    if(keyboardVisible){
        [self animateTextField:_balanceField up:NO animated:NO];
    }
    if (orientation == UIDeviceOrientationLandscapeLeft)
        negative = -1;
    else
        negative = 1;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _currentGiftCard.balance = _balanceField.text;
    NSError *error = nil;
    if(![self.managedObjectContext save:&error]){
        NSLog(@"Error Saving Balance %@", error);
    }
    [textField resignFirstResponder];
    return YES;
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    keyboardVisible = YES;
    [self animateTextField: textField up: YES animated:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField: textField up: NO animated:YES];
    keyboardVisible = NO;
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
        BOOL isLast = ([self numberOfGiftCardsInStore:_currentGiftCard.store] < 1) ? YES : NO;
        [self dismissViewControllerAnimated:isLast completion:nil];
    }
}


@end
