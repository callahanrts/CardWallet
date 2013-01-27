//
//  AddVehicleViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 1/18/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import "AddVehicleViewController.h"

@interface AddVehicleViewController ()

@end

@implementation AddVehicleViewController{
    
}

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
    _makeTF.delegate = self;
    _modelTF.delegate = self;
    _vinTF.delegate = self;
    _yearTF.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [_delegate addVehicleViewControllerDidCancel:_currentVehicle];
}

- (IBAction)save:(id)sender {
    //Set Field Values
    _currentVehicle.make = _makeTF.text;
    _currentVehicle.model = _modelTF.text;
    _currentVehicle.vinNum = _vinTF.text;
    _currentVehicle.year = _yearTF.text;
    
    [_delegate addVehicleViewControllerDidSave:_currentVehicle];
}


#pragma mark - Text Field Delegate Functions

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.frame.origin.y > ( self.view.frame.size.height - 200 - 71 ) ){
        [self animateTextField:textField up:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.frame.origin.y > ( self.view.frame.size.height - 200 - 71 ) ){
        [self animateTextField:textField up:NO];
    }
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = textField.frame.origin.y - ( 200 - 45 ); // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
@end
