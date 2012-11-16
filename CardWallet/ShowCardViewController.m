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
    _storeLabel.text = _currentGiftCard.store.name;
    _barCodeLabel.text = @"|| | ||| | || | ||| | || || |||| | ||| | || | ||| | || || ||";
    _accountNumberLabel.text = _currentGiftCard.accountNumber;
    _pinLabel.text = _currentGiftCard.pin;
    _barCodeLabel.numberOfLines = 1;
    _barCodeLabel.adjustsFontSizeToFitWidth = YES;
    [_barCodeLabel sizeToFit];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg3.png"]];
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
